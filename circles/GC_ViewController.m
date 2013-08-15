//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_Circle.h"
#import "GC_Global.h"

#define QUANTITY 50
#define TIME_INCREMENT .01;
#define CALCULATIONS_PER_SECOND 48;
#define VELOCITY 10
#define RADIUS 10
#define ATTENUATION .9
#define GRAVITY -10

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    long width, height;
    NSMutableArray *circles;
    NSTimer *timer;
    circType c[QUANTITY];
    int lastCollision1, lastCollision2;
}

#pragma mark - Lifcycle Functions

/*
 *
 */
- (void)viewDidLoad
{
    DLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        width = self.view.frame.size.height;
        height = self.view.frame.size.width;
    } else {
        width = self.view.frame.size.height;
        height = self.view.frame.size.width;
    }
    
    circles = [NSMutableArray new];
    
    [self initializeUIViewDataArray];
    [self initializeUIViewArray];
    //[self printUIViewObjectData];
    
    double timerDelay = 1.0 / CALCULATIONS_PER_SECOND;
    timer = [NSTimer scheduledTimerWithTimeInterval:timerDelay target:self selector:@selector(executeNextMove) userInfo:nil repeats:YES];
}

/*
 *
 */
- (void)didReceiveMemoryWarning
{
    DLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize data

/*
 *
 */
- (void)initializeUIViewDataArray {
    DLog(@"initializeUIViewDataArray");
    
    double dx, dy, dr;
    
    for (int i=0; i<QUANTITY; i++) {
        c[i].r = RADIUS;
        c[i].x = rand() % (width - (int)c[i].r) + c[i].r;
        c[i].y = rand() % (height - (int)c[i].r) + c[i].r;
        c[i].vx = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        c[i].vy = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        
        for (int j=0; j<i; j++) {
            dr = (c[i].r + c[j].r)*(c[i].r + c[j].r);
            dx = c[i].x - c[j].x;
            dy = c[i].y - c[j].y;
            if (dx*dx + dy*dy < dr) {
                i -= 1;
                break;
            }
        }
    }
    
    lastCollision1 = -1;
    lastCollision2 = -1;
}

- (void)swapDataCoordinates {
    DLog(@"swapDataCoordinates");
    
    double temp;
    
    for (int i=0; i<QUANTITY; i++) {
        temp = c[i].x;
        c[i].x = c[i].y;
        c[i].y = temp;
    }

}

/*
 *
 */
- (void)initializeUIViewArray
{
    DLog(@"initializeUIViewArray");
    for (int i=0; i<QUANTITY; i++) {
        [circles addObject:[[GC_Circle alloc] initWithFrame:CGRectMake(c[i].x - c[i].r, c[i].y - c[i].r, c[i].r*2, c[i].r*2)]];
        [circles[i] setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:circles[i]];
    }
}

#pragma mark - Calculate next move

/*
 *
 */
- (void)calculateNextMoveForUIViewData {
    //DLog(@"calculateNextMoveForUIViewData");
    
    double dx,dy,dr;
    
    for (int i=0; i<QUANTITY; i++) {
        for (int j=i+1; j<QUANTITY; j++) {
            dr = (c[i].r + c[j].r)*(c[i].r + c[j].r);
            dx = c[i].x - c[j].x;
            dy = c[i].y - c[j].y;
            if (dx * dx + dy * dy < dr) {
                if (i!=lastCollision1 || j!=lastCollision2) {
                    [self separateCircles: &(c[i]) with: &(c[j])];
                    [self adjustUIViewVelocityForCollision: &(c[i]) with: &(c[j])];
                    lastCollision1 = i;
                    lastCollision2 = j;
                }
            }
        }
    }
    
    for (int i=0; i<QUANTITY; i++) {
        if ([self adjustUIViewVelocityForWallCollision: &(c[i])]) {
            if (lastCollision1 == i) {
                lastCollision1 = -1;
            }
            if (lastCollision2 == i) {
                lastCollision2 = -1;
            }
        }
    }
}

/*
 *
 */
- (void)separateCircles: (circType *)a with: (circType *)b {
    double midpointx = (a->x + b->x) / 2.0;
    double midpointy = (a->y + b->y) / 2.0;
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    if (d < 0.00000001) {
        d = 0.00000001;
    }
    
    double ax = midpointx + a->r * (a->x - b->x) / d;
    double ay = midpointy + a->r * (a->y - b->y) / d;
    double bx = midpointx + b->r * (b->x - a->x) / d;
    double by = midpointy + b->r * (b->y - a->y) / d;
    
    a->x = ax;
    a->y = ay;
    b->x = bx;
    b->y = by;
}

/*
 *
 */
- (void)adjustUIViewVelocityForCollision: (circType *)a with: (circType *)b {
    //DLog(@"adjustUIViewVelocityForCollision:");
    
    double mb = a->r * a->r;
    double ma = b->r * b->r;
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    if (d < 0.00000001) {
        d = 0.00000001;
    }
    
    double nx = (b->x - a->x) / d;
    double ny = (b->y - a->y) / d;
    double p = 2 * (a->vx * nx + a->vy * ny - b->vx * nx - b->vy * ny) / (ma + mb);
    double new_aVx = a->vx - p * ma * nx;
    double new_aVy = a->vy - p * ma * ny;
    double new_bVx = b->vx + p * mb * nx;
    double new_bVy = b->vy + p * mb * ny;
    
    a->vx = new_aVx * ATTENUATION;
    a->vy = new_aVy * ATTENUATION;
    b->vx = new_bVx * ATTENUATION;
    b->vy = new_bVy * ATTENUATION;
}

/*
 *
 */
- (BOOL)adjustUIViewVelocityForWallCollision: (circType *)a {
    //Dlog(@"adjustUIViewVelocityForWallCollision:");
    
    BOOL ret = NO;
    
    if (a->x < a->r) {
        a->x = a->r;
        a->vx = -a->vx;
        ret = YES;
    }
    
    if (a->x > width - a->r) {
        a->x = width - a->r;
        a->vx = -a->vx;
        ret = YES;
    }
    
    if (a->y < a->r) {
        a->y = a->r;
        a->vy = -a->vy;
        ret = YES;
    }
    
    if (a->y > height - a->r) {
        a->y = height - a->r;
        a->vy = -a->vy;
        ret = YES;
    }
    
    return ret;
}

#pragma mark - Move UIViews to next position

/*
 *
 */
- (void)executeNextMove {
    //DLog(@"executeNextMove");
    
    [self calculateNextMoveForUIViewData];
    [self incrementUIViewPosition];
    [self redrawUIViewObjects];
}

/*
 *
 */
- (void)incrementUIViewPosition {
    //DLog(@"incrementUIViewPosition");
    
    for (int i=0; i<QUANTITY; i++) {
        c[i].x = c[i].x + c[i].vx * TIME_INCREMENT;
        c[i].y = c[i].y + c[i].vy * TIME_INCREMENT;
        c[i].vy -= GRAVITY;
    }
}

/*
 *
 */
- (void)redrawUIViewObjects {
    //DLog(@"redrawUIViewObjects");
    
    for (int i=0; i<QUANTITY; i++) {
        double r = c[i].r;
        [circles[i] setFrame:CGRectMake(c[i].x - c[i].r, c[i].y - c[i].r, r*2, r*2)];
        [circles[i] setNeedsDisplay];
    }
}

#pragma mark - Utility functions

/*
 *
 */
- (void)printUIViewObjectData {
    DLog(@"printUIViewObjectData");
    
    for (int i=0; i<QUANTITY; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

/*
 *
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    DLog(@"willRotateToInterfaceOrientation:");
   
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            width = self.view.frame.size.width+20;
            height = self.view.frame.size.height-20;
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            width = self.view.frame.size.height+20;
            height = self.view.frame.size.width-20;
            break;
    }
    
    [self swapDataCoordinates];
}

@end
