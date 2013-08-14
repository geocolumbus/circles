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

#define SIZE 30
#define TIME_INCREMENT .01

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    long width, height;
    NSMutableArray *circles;
    NSTimer *timer;
    circType c[SIZE];
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
    
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
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
    
    for (int i=0; i<SIZE; i++) {
        c[i].r = 5 + rand() % 650 /10.0;
        c[i].x = rand() % (width - (int)c[i].r) + c[i].r;
        c[i].y = rand() % (height - (int)c[i].r) + c[i].r;
        c[i].vx = (rand() % 1000) / 200.0 - 2.5;
        c[i].vy = (rand() % 1000) / 200.0 - 2.5;
        
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
    for (int i=0; i<SIZE; i++) {
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
    
    for (int i=0; i<SIZE; i++) {
        for (int j=i+1; j<SIZE; j++) {
            dr = (c[i].r + c[j].r)*(c[i].r + c[j].r);
            dx = c[i].x - c[j].x;
            dy = c[i].y - c[j].y;
            if (dx * dx + dy * dy < dr) {
                [self adjustUIViewVelocityForCollision: &(c[i]) with: &(c[j])];
            }
        }
    }
    
    for (int i=0; i<SIZE; i++) {
        [self adjustUIViewVelocityForWallCollision: &(c[i])];
    }
}

/*
 *
 */
- (void)adjustUIViewVelocityForCollision: (circType *)a with: (circType *)b {
    //DLog(@"adjustUIViewVelocityForCollision:");
    
    double newVelX1 = (a->vx * (a->r - b->r) + (2 * b->r * b->vx)) / (a->r + b->r);
    double newVelY1 = (a->vy * (a->r - b->r) + (2 * b->r * b->vy)) / (a->r + b->r);
    double newVelX2 = (b->vx * (b->r - a->r) + (2 * a->r * a->vx)) / (a->r + b->r);
    double newVelY2 = (b->vy * (b->r - a->r) + (2 * a->r * a->vy)) / (a->r + b->r);

    a->vx = newVelX1;
    a->vy = newVelY1;
    b->vx = newVelX2;
    b->vy = newVelY2;
    
    a->x += a->vx;
    a->y += a->vy;
    b->x += b->vx;
    b->y += b->vy;
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
    
    for (int i=0; i<SIZE; i++) {
        c[i].x = c[i].x + c[i].vx;
        c[i].y = c[i].y + c[i].vy;
    }
}

/*
 *
 */
- (void)redrawUIViewObjects {
    //DLog(@"redrawUIViewObjects");
    
    for (int i=0; i<SIZE; i++) {
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
    
    for (int i=0; i<SIZE; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

@end
