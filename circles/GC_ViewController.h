//
//  GC_ViewController.h
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GC_ViewController : UIViewController <UIAccelerometerDelegate>

@property (weak,atomic) NSTimer *repeatingTimer;

typedef struct {
    double x,y;
    double vx,vy;
    double r;
} circType;

@property (strong,nonatomic) CMMotionManager *manager;

@end
