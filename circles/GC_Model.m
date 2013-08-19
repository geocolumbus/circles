//
//  GC_Model.m
//  circles
//
//  Created by George Campbell on 8/15/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import "GC_Model.h"
#import "GC_Global.h"

@implementation GC_Model {
    long width, height;
    circType c[QUANTITY];
    int lastCollision1, lastCollision2;
    long counter;
}

/*
 *
 */
- (GC_Model *)initWithWidth:(long)viewWidth andHeight:(long)viewHeight {
    DLog(@"initializeUIViewDataArray");
    
    width = viewWidth;
    height = viewHeight;
    counter = 0;
    
    self.manager = [[CMMotionManager alloc] init];
    self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.manager startDeviceMotionUpdates];
    
    double dx, dy, dr;
    
    // Randomly create circles
    
    c[0].x = 50;
    c[0].y = height / 2;
    c[0].vx = 0;
    c[0].vy = 0;
    c[0].r = c[0].x;
    
    for (int i = 0; i < QUANTITY; i++) {
        if (RADIUS_MAX - RADIUS_MIN == 0) {
            c[i].r = RADIUS_MIN;
        } else {
            c[i].r = rand() % (RADIUS_MAX - RADIUS_MIN) + RADIUS_MIN;
        }
        
        c[i].x = 600-rand() % (8 * width - (int)c[i].r) + c[i].r;
        c[i].y = rand() % (height - (int)c[i].r) + c[i].r;
        c[i].vx = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        c[i].vy = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        
        // Reject any circle that overlaps an already existing circle
        for (int j = 0; j < i; j++) {
            dr = (c[i].r + c[j].r) * (c[i].r + c[j].r);
            dx = c[i].x - c[j].x;
            dy = c[i].y - c[j].y;
            
            if (dx * dx + dy * dy < dr) {
                i -= 1;
                break;
            }
        }
    }
    
    // Once a two circles collide, ignore future collisions until one of them hits another ball
    // or the wall. Otherwise the balls will stick together and vibrate.
    
    lastCollision1 = -1; // Stores the first ball in the most recent collisiom. Initialize to -1 => no collision
    lastCollision2 = -1; //       "    second                            "
    
    return self;
}

/*
 * Calcuate the frame size for drawing the circle
 */

- (void)setObjectFrameFor: (UIView *)view withIndex: (int)i {
    circType *a = &(c[i]);
    double r = a->r;
    double r2 = r * 2;
    CGRect rect =  CGRectMake(a->x - r, a->y - r, r2, r2);
    [view setFrame:rect];
}

/*
 * Calcuate the frame size for drawing the circle
 */
- (CGRect)getObjectFrameForIndex:(int)i {
    circType *a = &c[i];
    double r = a->r;
    double r2 = r * 2;
    return CGRectMake(a->x - r, a->y - r, r2, r2);
}


/*
 * Calculate the next position of all circles. Circle and wall collisions are handled too.
 */
- (void)calculateNextPosition {
    [self calculateCollisions];
    [self moveCirclesToNextPosition];
}

/*
 * Test for and handle circle-circle collisions, and circle-wall collisions
 */
- (void)calculateCollisions {
    //DLog(@"calculateCollisions");
    
    double dx, dy, rsum;
    
    // Test for, and handle, circle collisions
    for (int i = 0; i < QUANTITY; i++) {
        if (i != lastCollision1) {
            for (int j = i + 1; j < QUANTITY; j++) {
                if (j != lastCollision2) {
                    dx = c[i].x - c[j].x;
                    
                    if (dx > RADIUS_BOUNDS) {
                        continue;
                    }
                    
                    dy = c[i].y - c[j].y;
                    
                    if (dy > RADIUS_BOUNDS) {
                        continue;
                    }
                    
                    rsum = c[i].r + c[j].r;
                    
                    if (dx * dx + dy * dy < rsum * rsum) {
                        [self collisionPositionAndVelocity:i with:j];
                        lastCollision1 = i;
                        lastCollision2 = j;
                    }
                }
            }
        }
    }
    
    // Test for, and handle, wall collisions
    for (int i = 0; i < QUANTITY; i++) {
        if ([self adjustUIViewVelocityForWallCollision:i]) {
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
 * Move the circles to the next position
 * Also determines the tilt of the device, and applies a force to roll the circles downhill
 */
- (void)moveCirclesToNextPosition {
    //DLog(@"moveCirclesToNextPosition");
    
    double pitch = self.manager.deviceMotion.attitude.pitch;
    double roll = self.manager.deviceMotion.attitude.roll;
    
    // Calculate the accelleration due to tilt in the X direction
    double ax = cos(pitch) * GRAVITY;
    
    if (signbit(roll)) {
        ax = -ax;
    }
    
    // Calculate the accelleration due to tilt in the Y direction
    double ay = sin(pitch) * GRAVITY;
    
    for (int i = 0; i < QUANTITY; i++) {
        c[i].vx -= ax;
        c[i].vy -= ay;
        c[i].x = c[i].x + c[i].vx * TIME_INCREMENT;
        c[i].y = c[i].y + c[i].vy * TIME_INCREMENT;

    }
}

/*
 * When two circles collide, calculate the new velocity values
 */
- (void)collisionPositionAndVelocity:(int)i with:(int)j {
    circType *a = &(c[i]);
    circType *b = &(c[j]);
    
    // Circle Collision
    double mb = a->r * a->r;
    double ma = b->r * b->r;
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    
    if (d < 0.01) {
        d = 0.01;
    }
    
    double nx = (b->x - a->x) / d;
    double ny = (b->y - a->y) / d;
    double p = 2 * (a->vx * nx + a->vy * ny - b->vx * nx - b->vy * ny) / (ma + mb);
    
    a->vx = (a->vx - p * ma * nx) * BALL_ATTENUATION;
    a->vy = (a->vy - p * ma * ny) * BALL_ATTENUATION;
    b->vx = (b->vx + p * mb * nx) * BALL_ATTENUATION;
    b->vy = (b->vy + p * mb * ny) * BALL_ATTENUATION;

    // Separate Circles
    
    double ra = a->r + 0.01;
    double rb = b->r + 0.01;
    
    double midpointx = (a->x * rb + b->x * ra) / (ra + rb);
    double midpointy = (a->y * rb + b->y * ra) / (ra + rb);
    
    a->x = midpointx + ra * (a->x - b->x) / d;
    a->y = midpointy + ra * (a->y - b->y) / d;
    b->x = midpointx + rb * nx;
    b->y = midpointy + rb * ny;
}

/*
 * When a circle hits a wall, calculate the new velocity values
 */
- (BOOL)adjustUIViewVelocityForWallCollision:(int)i {
    //Dlog(@"adjustUIViewVelocityForWallCollision:");
    
    circType *a = &(c[i]);
    
    // You have to check all four walls, because if a ball is in a corner and you return after checking
    // just one wall, the ball will act erratically
    BOOL ret = NO;
    /*
    if (a->x < a->r) {
        a->x = a->r;
        a->vx = abs(a->vx) * WALL_ATTENUATION;
        ret = YES;
    }
    */
    if (a->x > width - a->r) {
        a->x = width - a->r;
        a->vx = -abs(a->vx) * WALL_ATTENUATION;        
        ret = YES;
    }
    if (a->y < a->r) {
        a->y = a->r;
        a->vy = abs(a->vy) * WALL_ATTENUATION;
        ret = YES;
    }
    
    if (a->y > height - a->r) {
        a->y = height - a->r;
        a->vy = -abs(a->vy) * WALL_ATTENUATION;
        ret = YES;
    }
    
    return ret;
}

@end