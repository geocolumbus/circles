//
//  GC_ViewController.h
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GC_Model;

@interface GC_ViewController : UIViewController /*<UIAccelerometerDelegate>*/

@property (weak,atomic) NSTimer *repeatingTimer;
@property (strong,atomic) GC_Model *model;

@end
