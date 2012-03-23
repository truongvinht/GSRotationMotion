/*
 
 GSRotationMotion.h
 
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

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

//define Rotation direction
typedef enum{
  GSRotationMotionDirectionUnknown,
  GSRotationMotionDirectionLeft,
  GSRotationMotionDirectionRight
}GSRotationMotionDirection;

@protocol GSRotationMotionDelegate <NSObject>

/** Method which will be called after motion is finished (replace finishedMotion method)
 
 @since 1.0.1
 */
- (void)finishedMotion:(GSRotationMotionDirection)direction;

@end

/*! Custom class for detect instant shake rotation.*/
@interface GSRotationMotion : NSObject

/// @name Variables

/// delegation
@property(nonatomic,assign) id<GSRotationMotionDelegate> delegate;

/// motion manager
@property (nonatomic, retain) CMMotionManager *motionManager;

/// @name Methods

/** Method to start listening to shake roation
 
 @since 1.0
 */
- (void)startDetect;

/** Method to stop listening to shake roation
 
 @since 1.0
 */
- (void)stopDetect;

@end
