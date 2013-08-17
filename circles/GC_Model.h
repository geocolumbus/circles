//
//  GC_Model.h
//  circles
//
//  Created by George Campbell on 8/15/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface GC_Model : NSObject <UIAccelerometerDelegate>

typedef struct {
    double x,y;
    double vx,vy;
    double r;
} circType;

@property (strong,nonatomic) CMMotionManager *manager;

- (GC_Model *)initWithWidth: (long)width andHeight: (long)height;
- (CGRect)getObjectFrameForIndex: (int)i;
- (void)calculateNextPosition;

@end
