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

@implementation GC_ViewController {
//    NSMutableArray *circles;
    NSTimer *timer;
}

#pragma mark - Lifcycle Functions

/*
 *
 */
- (void)viewDidLoad {
    DLog(@"viewDidLoad");
    [super viewDidLoad];

    self.model = [[GC_Model alloc]initWithWidth:self.view.frame.size.width andHeight:self.view.frame.size.height andView: self.view];
    [self start];
}

/*
 *
 */
- (void)didReceiveMemoryWarning {
    DLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}

#pragma mark - Master Run Loop

/*
 *
 */
-(void)start {
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(masterRunLoop) userInfo:nil repeats:NO];
}

/*
 *
 */
-(void)stop {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

/*
 *
 */
- (void)masterRunLoop {
    //DLog(@"masterRunLoop");
    [_model calculateNextPosition];
    [_model draw];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(masterRunLoop) userInfo:nil repeats:NO];
}

@end
