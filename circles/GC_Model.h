//
//  GC_Model.h
//  circles
//
//  Created by George Campbell on 8/15/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@class GC_Circle;

@interface GC_Model : NSObject <UIAccelerometerDelegate>

@property (strong, nonatomic) CMMotionManager *manager;
@property (retain, nonatomic) GC_Circle *root;

- (GC_Model*)initWithWidth: (long)width andHeight: (long)height andView: (UIView *)view;
- (void)calculateNextPosition: (UIView *)view;
- (void)draw;
@end
