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

#define QUANTITY 100
#define TIME_INCREMENT .001
#define VELOCITY 0
#define MAXSIZE .25
#define ATTENUATION 0.999
#define GRAVITY -.0005

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    long width, height;
    NSMutableArray *circles;
    NSTimer *timer;
    circType c[QUANTITY];
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
        width = self.view.frame.size.width;
        height = self.view.frame.size.height;
    } else {
        width = self.view.frame.size.height;
        height = self.view.frame.size.width;
    }
    
    circles = [NSMutableArray new];
    
    [self initializeUIViewDataArray];
    [self initializeUIViewArray];
    //[self printUIViewObjectData];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INCREMENT target:self selector:@selector(executeNextMove) userInfo:nil repeats:YES];
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
        c[i].r = 5 + rand() % 650 /10.0 * MAXSIZE;
        c[i].x = rand() % (width - (int)c[i].r) + c[i].r;
        c[i].y = rand() % (height - (int)c[i].r) + c[i].r;
        c[i].vx = ((rand() % 1000) / 1000.0 - .5)*VELOCITY;
        c[i].vy = ((rand() % 1000) / 1000.0 - .5)*VELOCITY;
        
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
                [self adjustUIViewVelocityForCollision: &(c[i]) with: &(c[j])];
            }
        }
    }
    
    for (int i=0; i<QUANTITY; i++) {
        [self adjustUIViewVelocityForWallCollision: &(c[i])];
    }
}

/*
 *
 */
- (void)adjustUIViewVelocityForCollision: (circType *)a with: (circType *)b {
    //DLog(@"adjustUIViewVelocityForCollision:");
    
    a->x -= a->vx;
    a->y -= a->vy;
    b->x -= b->vx;
    b->y -= b->vy;
    
    double denom = a->r*a->r + b->r*b->r;
    
    double newVelX1 = (a->vx * (a->r*a->r - b->r*b->r) + (2 * b->r*b->r * b->vx)) / denom;
    double newVelY1 = (a->vy * (a->r*a->r - b->r*b->r) + (2 * b->r*b->r * b->vy)) / denom;
    double newVelX2 = (b->vx * (b->r*b->r - a->r*a->r) + (2 * a->r*a->r * a->vx)) / denom;
    double newVelY2 = (b->vy * (b->r*b->r - a->r*a->r) + (2 * a->r*a->r * a->vy)) / denom;
    
    a->vx = newVelX1;
    a->vy = newVelY1;
    b->vx = newVelX2;
    b->vy = newVelY2;
}

/*
 *
 */
- (void)adjustUIViewVelocityForWallCollision: (circType *)a {
    //Dlog(@"adjustUIViewVelocityForCollision:");
    if (a->x < a->r) {
        a->x = a->r;
        a->vx = -a->vx;
    }
    if (a->x > width - a->r) {
        a->x = width - a->r;
        a->vx = -a->vx;
    }
    if (a->y < a->r) {
        a->y = a->r;
        a->vy = -a->vy;
    }
    if (a->y > height - a->r) {
        a->y = height - a->r;
        a->vy = -a->vy;
    }
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
        c[i].x = c[i].x + c[i].vx;
        c[i].y = c[i].y + c[i].vy;
        c[i].vx *= ATTENUATION;
        c[i].vy *= ATTENUATION;
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
- (void) printUIViewObjectData {
    DLog(@"printUIViewObjectData");
    
    for (int i=0; i<QUANTITY; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

@end
