//
//  GC_view.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_view.h"

@implementation GC_view {
    double x,y;
}

/*
 *
 */
- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"GC_view initWithFrame");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"GC_view drawRect:(%f,%f)",rect.size.height,rect.size.width);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetRGBFillColor(ctx, 0.2f, 0.2f, 1.0f, 1.0f);  // blue color
    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, rect.size.height, rect.size.width));
    UIGraphicsPopContext();
}


@end
