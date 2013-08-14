//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_Circle.h"

#define SIZE 20
#define TIME_INCREMENT 0.01

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    long width, height;
    NSMutableArray *circles;
    NSTimer *timer;
    circType c[SIZE];
}

/*
 *
 */
- (void)viewDidLoad
{
    NSLog(@"GC_ViewController viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    circles = [NSMutableArray new];
        
    [self initializeUIViewDataArray];
    [self initializeUIViewArray];
    //[self printUIViewObjectData];
    [self calculateNextMoveForUIViewData];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INCREMENT target:self selector:@selector(executeNextMove) userInfo:nil repeats:YES];
}

#pragma mark - Initialize data

/*
 *
 */
- (void)initializeUIViewArray
{
    for (int i=0; i<SIZE; i++) {
        [circles addObject:[[GC_Circle alloc] initWithFrame:CGRectMake(c[i].x, c[i].y, c[i].r, c[i].r)]];
        [circles[i] setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:circles[i]];
    }
}

/*
 *
 */
- (void)initializeUIViewDataArray {
    
    for (int i=0; i<SIZE; i++) {
        c[i].r = 20;
        c[i].x = rand() % (width - (int)c[i].r);
        c[i].y = rand() % (height - (int)c[i].r);
        c[i].vx = 1;
        c[i].vy = 1;
    }
}

#pragma mark - Calculate next move

/*
 *
 */
- (void)calculateNextMoveForUIViewData {
    
    for (int i=0; i<SIZE; i++) {
        for (int j=i; j<SIZE; j++) {
            if ( i!= j && [self detectUIViewIntersection: c[i] with: c[j]]) {
                [self adjustUIViewVelocityForCollision: c[i] with: c[j]];
            }
        }
    }
    
    for (int i=0; i<SIZE; i++) {
        
    }
}

/*
 *
 */
- (BOOL)detectUIViewIntersection: (circType)a with: (circType)b {
    double d = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
    return d < a.r * b.r;
}

/*
 *
 */
- (void)adjustUIViewVelocityForCollision: (circType)a with: (circType)b {
    if (a.r > 0) {
        a.r = a.r - 0.01;
    }
    if (b.r > 0) {
        b.r = b.r - 0.01;
    }
}

#pragma mark - Move UIViews to next position

/*
 *
 */
- (void)executeNextMove {
    [self incrementUIViewPosition];
    [self redrawUIViewObjects];
}

/*
 *
 */
- (void)incrementUIViewPosition {
    
    for (int i=0; i<SIZE; i++) {
        c[i].x = c[i].x + c[i].vx;
        c[i].y = c[i].y + c[i].vy;
    }
}

/*
 *
 */
- (void)redrawUIViewObjects {
    for (int i=0; i<SIZE; i++) {
        double r = c[i].r;
        [circles[i] setFrame:CGRectMake(c[i].x, c[i].y, r, r)];
        [circles[i] setNeedsDisplay];
    }
}

#pragma mark - Utility functions

/*
 *
 */
- (void) printUIViewObjectData {
    for (int i=0; i<SIZE; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

/*
 *
 */
- (void)didReceiveMemoryWarning
{
    NSLog(@"GC_ViewController didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
