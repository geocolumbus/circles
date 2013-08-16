//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_Model.h"
#import "GC_Circle.h"
#import "GC_Global.h"

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    NSMutableArray *circles;
    NSTimer *timer;
}

#pragma mark - Lifcycle Functions

/*
 *
 */
- (void)viewDidLoad
{
    DLog(@"viewDidLoad");
    [super viewDidLoad];
    
    circles = [NSMutableArray new];
    self.model = [[GC_Model alloc]initWithWidth:self.view.frame.size.width andHeight:self.view.frame.size.height];
    [self initializeUIViewArray];
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
}

#pragma mark - Initialize Objects
 
/*
 *
 */
- (void)initializeUIViewArray
{
    DLog(@"initializeUIViewArray");
    for (int i=0; i<QUANTITY; i++) {
        [circles addObject:[[GC_Circle alloc] initWithFrame:[_model getObjectFrameForIndex:i]]];
        [circles[i] setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:circles[i]];
    }
}

#pragma mark - Move UIViews to next position

/*
 *
 */
- (void)executeNextMove {
    
    [_model calculateNextPosition];
    
    for (int i=0; i<QUANTITY; i++) {
        [circles[i] setFrame:[_model getObjectFrameForIndex:i]];
        [circles[i] setNeedsDisplay];
    }
}

@end
