//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_Circle.h"

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    long width, height;
    long size;
    NSMutableArray *circles;
    NSTimer *timer;
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
    
    size = 5;
    circType c[size];
    
    [self initData: c];
    NSMutableArray *circles = [self setObjectsWithData: c];
    [self print: c];
    [self calculateMove: c];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callBackWithData:andCircles:) withObject:c withObject: circles userInfo:nil repeats:YES];
}

/*
 *
 */
- (void)callBackWithData: (circType *)c andCircles: (NSArray *)circles {
    [self move:c];
    [self updateObjects:c];
}

/*
 *
 */
- (void)updateObjects: (circType *)c {
    for (int i=0; i<size; i++) {
        circles[i].f
    }
}

/*
 *
 */
- (NSMutableArray *)setObjectsWithData: (circType *)c {
    
    NSMutableArray *circs = [NSMutableArray new];
    
    for (int i=0; i<size; i++) {
        GC_Circle *circ = [[GC_Circle alloc] initWithFrame:CGRectMake(c[i].x, c[i].y, c[i].r, c[i].r)];
        circ.backgroundColor = [UIColor whiteColor];
        [circs addObject:circ];
        [self.view addSubview:circ];
    }
    return circs;
}

/*
 *
 */
- (void) print: (circType *)c {
    for (int i=0; i<size; i++) {
        NSLog(@"%f %f %f %f %f",c[i].x,c[i].y,c[i].vx,c[i].vy,c[i].r);
    }
}

/*
 *
 */
- (void)initData: (circType *)c {
    
    for (int i=0; i<size; i++) {
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
- (void)calculateMove: (circType *)c {
    
    for (int i=0; i<size; i++) {
        for (int j=i; j<size; j++) {
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
- (void)move: (circType *)c {
    
    for (int i=0; i<size; i++) {
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
