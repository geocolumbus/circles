//
//  GC_Circle.h
//  circles
//
//  Created by George Campbell on 8/13/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GC_Circle : UIView

@property (assign,atomic) double x, y;
@property (assign,atomic) double vx, vy;
@property (assign,atomic) double r;

@property (retain,atomic) GC_Circle *next;
@property (retain,atomic) GC_Circle *prev;

@end
