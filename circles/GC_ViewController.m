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
    double posX, posY, sizeX, sizeY;
    double boundaryX, boundaryY;
    double incX, incY;
    UIView *vw;
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
    
    posX = 50;
    posY = 50;
    sizeX = 100;
    sizeY = 100;
    
    boundaryX = self.view.frame.size.width - 50;
    boundaryY = self.view.frame.size.height - 50;
    
    incX = 1;
    incY = 1;
    
    vw = [[GC_view alloc] initWithFrame:CGRectMake(0, 0, sizeX, sizeY)];
    
    vw.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:vw];
    [vw setNeedsDisplay];
    
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval: 0.001 target:self selector:@selector(animate) userInfo:nil repeats:YES];

}

-(void) animate {
    vw.center = CGPointMake(posX,posY);
    posX += incX;
    posY += incY;
    
    if (posX > boundaryX || posX < 50) {
        incX = -incX;
    }
    
    if (posY > boundaryY || posY < 50) {
        incY = -incY;
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
