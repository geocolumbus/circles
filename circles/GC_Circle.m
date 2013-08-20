//
//  GC_Circle.m
//  circles
//
//  Created by George Campbell on 8/13/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_Circle.h"

@implementation GC_Circle {
}

/*
 *
 */
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)removeCircle {
    GC_Circle *a = self.prev;
    GC_Circle *b = self.next;
    a.next = b;
    b.prev = a;
    [self removeFromSuperview];
}

/*
 *
 */
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillPath(ctx);
}

@end
