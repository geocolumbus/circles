//
//  GC_Circle.m
//  circles
//
//  Created by George Campbell on 8/13/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_Circle.h"

@implementation GC_Circle

/*
 *
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 *
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(ctx);
}

@end
