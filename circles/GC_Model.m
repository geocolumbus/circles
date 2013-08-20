//
//  GC_Model.m
//  circles
//
//  Created by George Campbell on 8/15/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_Model.h"
#import "GC_Global.h"
#import "GC_Circle.h"

@implementation GC_Model {
    long width, height;
    GC_Circle *lastCollision1, *lastCollision2;
    long counter;
}

/*
 *
 */
- (GC_Model *)initWithWidth:(long)viewWidth andHeight:(long)viewHeight andView: (UIView*)view {
    DLog(@"initWithWidth: %ld andHeight: %ld",viewWidth,viewHeight);
    
    width = viewWidth;
    height = viewHeight;
    GC_Circle *circle;
    
    self.manager = [[CMMotionManager alloc] init];
    self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.manager startDeviceMotionUpdates];
    
    double dx, dy, dr;
    
    // Randomly create circles
    
    self.root = [GC_Circle new];
    
    circle = _root;
    
    for (int i = 0; i < QUANTITY; i++) {
        if (RADIUS_MAX - RADIUS_MIN == 0) {
            circle.r = RADIUS_MIN;
        } else {
            circle.r = rand() % (RADIUS_MAX - RADIUS_MIN) + RADIUS_MIN;
        }
        
        circle.x = rand() % (width - (int)circle.r) + circle.r;
        circle.y = rand() % (height - (int)circle.r) + circle.r;
        circle.vx = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        circle.vy = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        
        // Reject any circle that overlaps an already existing circle
        BOOL reject = NO;
        
        GC_Circle *item = _root;
        while (item && item != circle) {
            dr = (circle.r + item.r) * (circle.r + item.r);
            dx = circle.x - item.x;
            dy = circle.y - item.y;
            
            if (dx * dx + dy * dy < dr) {
                reject = YES;
                break;
            }
            item = item.next;
        }
        
        if (reject) {
            i -= 1;
        } else {
            [circle setFrame:CGRectMake(circle.x - circle.r, circle.y - circle.r, circle.r*2, circle.r*2)];
            [view addSubview:circle];
            circle.next = [GC_Circle new];
            circle.next.prev = circle;
            circle = circle.next;
        }
        
    }
    
    // Once a two circles collide, ignore future collisions until one of them hits another ball
    // or the wall. Otherwise the balls will stick together and vibrate.
    
    lastCollision1 = nil; // Stores the first ball in the most recent collisiom. Initialize to -1 => no collision
    lastCollision2 = nil; //       "    second                            "
    
    return self;
}

/*
 * Draw the circles
 */
-(void) draw {
    //DLog(@"draw");
    GC_Circle *circle = _root;
    while (circle) {
        CGRect rect = CGRectMake(circle.x - circle.r, circle.y - circle.r, circle.r*2, circle.r*2);
        [circle setFrame:rect];
        circle = circle.next;
    }
}

/*
 * Calculate the next position of all circles. Circle and wall collisions are handled too.
 */
- (void)calculateNextPosition: (UIView *)view {
    //DLog(@"calculateNextPosition");
    [self calculateCollisions];
    [self moveCirclesToNextPosition];
    
    if (counter++ % ADD_NEW_SPHERE == 0) {
        GC_Circle *circle = [GC_Circle new];
        circle.x = width/2 + 80;
        circle.y = height - 40;
        circle.vy = -50000;
        circle.vx = rand() % 80000 - 40000;
        if (RADIUS_MAX - RADIUS_MIN == 0) {
            circle.r = RADIUS_MIN;
        } else {
            circle.r = rand() % (RADIUS_MAX - RADIUS_MIN) + RADIUS_MIN;
        }
        [circle setFrame:CGRectMake(circle.x - circle.r, circle.y - circle.r, circle.r*2, circle.r*2)];
        [view addSubview:circle];
        
        circle.next = _root;
        self.root.prev = circle;
        self.root = circle;
        
        circle = [GC_Circle new];
        circle.x = width/2 - 80;
        circle.y = height - 40;
        circle.vy = -50000;
        circle.vx = rand() % 80000 - 40000;
        if (RADIUS_MAX - RADIUS_MIN == 0) {
            circle.r = RADIUS_MIN;
        } else {
            circle.r = rand() % (RADIUS_MAX - RADIUS_MIN) + RADIUS_MIN;
        }
        [circle setFrame:CGRectMake(circle.x - circle.r, circle.y - circle.r, circle.r*2, circle.r*2)];
        [view addSubview:circle];
        
        circle.next = _root;
        self.root.prev = circle;
        self.root = circle;

    }
}

/*
 * Test for and handle circle-circle collisions, and circle-wall collisions
 */
- (void)calculateCollisions {
    //DLog(@"calculateCollisions");
    
    GC_Circle *circle1 = _root;
    while (circle1) {
        GC_Circle *circle2 = circle1.next;
        while (circle2) {
            if (circle1 != lastCollision1 && circle2 != lastCollision2) {
                double dx = circle1.x - circle2.x;
                double dy = circle1.y - circle2.y;
                
                if (abs(dx) < RADIUS_BOUNDS && abs(dy) < RADIUS_BOUNDS) {
                    double rsum = circle1.r + circle2.r;
                    
                    if (dx * dx + dy * dy < rsum * rsum) {
                        [self collisionPositionAndVelocity:circle1 with:circle2];
                        lastCollision1 = circle1;
                        lastCollision2 = circle2;
                    }
                }
            }
            circle2 = circle2.next;
        }
        circle1 = circle1.next;
    }
    
    // Test for, and handle, wall collisions
    circle1 = _root;
    while (circle1) {
        GC_Circle *next = circle1.next;
        if ([self adjustUIViewVelocityForWallCollision:circle1]) {
            if (lastCollision1 == circle1) {
                lastCollision1 = nil;
            }
            
            if (lastCollision2 == circle1) {
                lastCollision2 = nil;
            }
        }
        circle1 = next;
    }
}

/*
 * Move the circles to the next position
 * Also determines the tilt of the device, and applies a force to roll the circles downhill
 */
- (void)moveCirclesToNextPosition {
    //DLog(@"moveCirclesToNextPosition");
    
    GC_Circle *circle;
    double pitch = self.manager.deviceMotion.attitude.pitch;
    double roll = self.manager.deviceMotion.attitude.roll;
    
    // Calculate the accelleration due to tilt in the X direction
    double ax = cos(pitch) * GRAVITY;
    
    if (signbit(roll)) {
        ax = -ax;
    }
    
    // Calculate the accelleration due to tilt in the Y direction
    double ay = sin(pitch) * GRAVITY;
    
    circle = _root;
    while (circle) {
        circle.vx -= ax;
        circle.vy -= ay;
        circle.x = circle.x + circle.vx * TIME_INCREMENT;
        circle.y = circle.y + circle.vy * TIME_INCREMENT;
        circle.r *= 0.992;
        if (circle.r < 2) {
            [circle removeCircle];
        }
        circle = circle.next;
    }    
}

/*
 * When two circles collide, calculate the new velocity values
 */
- (void)collisionPositionAndVelocity:(GC_Circle *)c1 with:(GC_Circle *)c2 {
    //DLog(@"collisionPositionAndVelocity:");
    
    // Circle Collision
    double mb = c1.r * c1.r;
    double ma = c2.r * c2.r;
    
    double d = sqrt((c1.x - c2.x) * (c1.x - c2.x) + (c1.y - c2.y) * (c1.y - c2.y));
    
    if (d == 0) {
        d = 0.0001;
    }
    
    double nx = (c2.x - c1.x) / d;
    double ny = (c2.y - c1.y) / d;
    double p = 2 * (c1.vx * nx + c1.vy * ny - c2.vx * nx - c2.vy * ny) / (ma + mb);
    
    c1.vx = (c1.vx - p * ma * nx) * BALL_ATTENUATION;
    c1.vy = (c1.vy - p * ma * ny) * BALL_ATTENUATION;
    c2.vx = (c2.vx + p * mb * nx) * BALL_ATTENUATION;
    c2.vy = (c2.vy + p * mb * ny) * BALL_ATTENUATION;
    
    // Separate Circles
    
    d = sqrt((c1.x - c2.x) * (c1.x - c2.x) + (c1.y - c2.y) * (c1.y - c2.y)) + 0.001;

    if (d == 0) {
        d = 0.0001;
    }

    double ra = c1.r;
    double rb = c2.r;
    
    double midpointx = (c1.x * rb + c2.x * ra) / (ra + rb);
    double midpointy = (c1.y * rb + c2.y * ra) / (ra + rb);
    
    c1.x = midpointx + ra * (c1.x - c2.x) / d;
    c1.y = midpointy + ra * (c1.y - c2.y) / d;
    c2.x = midpointx + rb * nx;
    c2.y = midpointy + rb * ny;
}

/*
 * When a circle hits a wall, calculate the new velocity values
 */
- (BOOL)adjustUIViewVelocityForWallCollision:(GC_Circle *)c {
    //Dlog(@"adjustUIViewVelocityForWallCollision:");
    
    // You have to check all four walls, because if a ball is in a corner and you return after checking
    // just one wall, the ball will act erratically
    BOOL ret = NO;
    
    if (c.x < c.r) {
        c.x = c.r;
        c.vx = abs(c.vx) * WALL_ATTENUATION;
        ret = YES;
    }
    
    if (c.x > width - c.r) {
        c.x = width - c.r;
        c.vx = -abs(c.vx) * WALL_ATTENUATION;
        ret = YES;
    }
    if (c.y < c.r) {
        c.y = c.r;
        c.vy = abs(c.vy) * WALL_ATTENUATION;
        ret = YES;
    }
    
    if (c.y > height - c.r) {
        c.y = height - c.r;
        c.vy = -abs(c.vy) * WALL_ATTENUATION;
        ret = YES;
    }
    
    return ret;
}

@end