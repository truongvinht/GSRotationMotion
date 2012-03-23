/*
 
 GSRotationMotion.m
 
 Copyright (c) 2012 Truong Vinh Tran
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "GSRotationMotion.h"

#define GSROTATIONMOTION_WAIT_DURATION 1.0f
#define GSROTATIONMOTION_MOTION_THRESHOLD 7.0f

@interface GSRotationMotion()

/// last complete rotation time stamp
@property (nonatomic,retain) NSDate *lastCompleteRotateAt;

/// last left/right rotation time stamp
@property (nonatomic,retain) NSDate *lastPartRotateAt;

/// variable for determine left or right rotation
@property (nonatomic,readwrite) float lastRotation;

@end


#pragma mark - GSRotationMotion Implementation

@implementation GSRotationMotion

@synthesize delegate;
@synthesize motionManager;
@synthesize lastCompleteRotateAt,lastPartRotateAt,lastRotation;


- (void)startDetect{
  
  //dont allow double running
  if (self.motionManager != nil) {
    NSLog(@"####ERROR: GSRotationMotion is already running");
  }
  
  //init rotation
  self.motionManager = [[[CMMotionManager alloc] init] autorelease];
  self.lastRotation = 0.0f;
  
  self.motionManager.deviceMotionUpdateInterval = 1/15.0;
  
  // check wether motion is available
  if (self.motionManager.deviceMotionAvailable) {
    NSLog(@"Device Motion Available");
    
    //start detection
    [self.motionManager startDeviceMotionUpdatesToQueue:
      [NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
        [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                              
    }];
    
  } else {
    NSLog(@"####ERROR: No device motion on device.");
    [self setMotionManager:nil];
  }
}

- (void)stopDetect{
  [self.motionManager stopDeviceMotionUpdates];
  
  // reset all rotation
  self.motionManager = nil;
  self.lastCompleteRotateAt = self.lastPartRotateAt = nil;
  self.lastRotation = 0.0f;
}

#pragma mark - Handle Motion

- (void)handleDeviceMotion:(CMDeviceMotion*)motion{
  
  float accelerationThreshold = 0.2; // or whatever is appropriate - play around with different values
  CMAcceleration userAcceleration = motion.userAcceleration;
  
  float rotationRateThreshold = GSROTATIONMOTION_MOTION_THRESHOLD;
  CMRotationRate rotationRate = motion.rotationRate;
  
  if (self.lastPartRotateAt&&self.lastRotation) {
    if ([self.lastPartRotateAt timeIntervalSinceNow]<-1*GSROTATIONMOTION_WAIT_DURATION) {
      self.lastRotation = 0.0f;
    }
  }
  
  // right rotation
  if ((rotationRate.y) > rotationRateThreshold) {
    if (fabs(userAcceleration.x) > accelerationThreshold || fabs(userAcceleration.y) > accelerationThreshold || fabs(userAcceleration.z) > accelerationThreshold) {
      
      if (self.lastRotation<0.0f&&(!self.lastCompleteRotateAt||
                                [self.lastCompleteRotateAt timeIntervalSinceNow]<-1*GSROTATIONMOTION_WAIT_DURATION)) {
        
        //trigger action
        [self.delegate finishedMotion:GSRotationMotionDirectionRight];
        self.lastRotation = 0.0f;
        self.lastCompleteRotateAt = [NSDate date];
      }
      
      self.lastRotation = rotationRate.y;
      self.lastPartRotateAt = [NSDate date];
      
    }
  }
  
  // left rotation
  else if ((-rotationRate.y) > rotationRateThreshold) {
    if (fabs(userAcceleration.x) > accelerationThreshold || fabs(userAcceleration.y) > accelerationThreshold || fabs(userAcceleration.z) > accelerationThreshold) {
      
      if (self.lastRotation>0.0f&&(!self.lastCompleteRotateAt||[self.lastCompleteRotateAt timeIntervalSinceNow]<-1*GSROTATIONMOTION_WAIT_DURATION)) {
        
        //trigger action
        [self.delegate finishedMotion:GSRotationMotionDirectionLeft];
        
        self.lastRotation = 0.0f;
        self.lastCompleteRotateAt = [NSDate date];
      }
      
      self.lastRotation = rotationRate.y;
      self.lastPartRotateAt = [NSDate date];
    }
  }
}

- (void)dealloc{
  [motionManager release];
  [lastCompleteRotateAt release];
  [lastPartRotateAt release];
  [super dealloc];
}

@end
