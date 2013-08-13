//
//  GC_ViewController.m
//  circles
//
//  Created by George Campbell on 8/11/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_ViewController.h"
#import "GC_view.h"

@interface GC_ViewController ()

@end

@implementation GC_ViewController {
    NSTimer *timer;
    double posX, posY, sizeX, sizeY;
}


/*
 *
 */
- (void)viewDidLoad
{
    NSLog(@"GC_ViewController viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"width: %f  height: %f",self.view.frame.size.width,self.view.frame.size.height);
    
    posX = 10;
    posY = 10;
    sizeX = 100;
    sizeY = 100;
    
    
    UIView *vw = [[GC_view alloc] initWithFrame:CGRectMake(0, 0, sizeX, sizeY)];
    
    vw.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:vw];
    [vw setNeedsDisplay];

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
