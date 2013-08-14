//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_Circle.h"

#define SIZE 5

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
        
    [self initData];
    [self setObjectsWithData];
    [self print];
    [self calculateMove];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(callBackWithData) userInfo:nil repeats:YES];
}

/*
 *
 */
- (void)callBackWithData {
    [self move];
    [self updateObjects];
}

/*
 *
 */
- (void)updateObjects {
    for (int i=0; i<SIZE; i++) {
        double r = c[i].r;
        [circles[i] setFrame:CGRectMake(c[i].x, c[i].y, r, r)];
        [circles[i] setNeedsDisplay];
    }
}

/*
 *
 */
- (void)setObjectsWithData
{
    for (int i=0; i<SIZE; i++) {
        GC_Circle *circ = [[GC_Circle alloc] initWithFrame:CGRectMake(c[i].x, c[i].y, c[i].r, c[i].r)];
        circ.backgroundColor = [UIColor whiteColor];
        [circles addObject:circ];
        [self.view addSubview:circ];
    }
}

/*
 *
 */
- (void) print {
    for (int i=0; i<SIZE; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

/*
 *
 */
- (void)initData {
    
    for (int i=0; i<SIZE; i++) {
        c[i].x = rand() % width;
        c[i].y = rand() % height;
        c[i].vx = 1;
        c[i].vy = 1;
        c[i].r = 20;
    }
    
}

/*
 *
 */
- (void)calculateMove {
    
    for (int i=0; i<SIZE; i++) {
        for (int j=i; j<SIZE; j++) {
            if ( i!= j && [self intersect: c[i] with: c[j]]) {
                [self collision: c[i] with: c[j]];
            }
        }
    }
}

/*
 *
 */
- (BOOL)intersect: (circType)a with: (circType)b {
    double d = (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
    return d < a.r * b.r;
}

/*
 *
 */
- (void)collision: (circType)a with: (circType)b {
    if (a.r > 0) {
        a.r = a.r - 0.01;
    }
    if (b.r > 0) {
        b.r = b.r - 0.01;
    }
}

/*
 *
 */
- (void)move {
    
    for (int i=0; i<SIZE; i++) {
        c[i].x = c[i].x + c[i].vx;
        c[i].y = c[i].y + c[i].vy;
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
