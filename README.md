# GSRotationMotion iOS

The GSRotationMotion class allows to handle shake rotation easily.

## Install Instruction

1. Import the GSRotationMotion.h and GSRotationMotion.m into your project.
2. make sure that the CoreMotion.framework and UIKit.framework is in the project
3. Implement "GSRotationMotionDelegate" in your header
4. Implement the method "finishedMotion" in the main class
5. start the the GSRotationMotion with:
GSRotationMotion *motion = [[GSRotationMotion alloc] init];
motion.delegate = self;
[motion startDetect];

6. For stopping it call the "[motion stopDetect]"



