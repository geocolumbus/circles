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
}

/*
 *
 */
- (GC_Model *)initWithWidth: (long)viewWidth andHeight: (long)viewHeight {
    DLog(@"initializeUIViewDataArray");
    
    width = viewWidth;
    height = viewHeight;
    
    self.manager = [[CMMotionManager alloc] init];
    self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.manager startDeviceMotionUpdates];
    
    double dx, dy, dr;
    
    // Randomly create circles
    for (int i=0; i<QUANTITY; i++) {
        if (RADIUS_MAX - RADIUS_MIN == 0) {
            c[i].r = RADIUS_MIN;
        } else {
            c[i].r = rand() % (RADIUS_MAX - RADIUS_MIN) + RADIUS_MIN;
        }
        c[i].x = rand() % (width - (int)c[i].r) + c[i].r;
        c[i].y = rand() % (height - (int)c[i].r) + c[i].r;
        c[i].vx = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        c[i].vy = ((rand() % 1000) / 1000.0 - .5) * VELOCITY / TIME_INCREMENT;
        
        // Reject any circle that overlaps an already existing circle
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
    
    // Once a two circles collide, ignore future collisions until one of them hits another ball
    // or the wall. Otherwise the balls will stick together and vibrate.
    
    lastCollision1 = -1; // Stores the first ball in the most recent collisiom. Initialize to -1 => no collision
    lastCollision2 = -1; //       "    second                            "
    
    return self;
}

/*
 * Calcuate the frame size for drawing the circle
 */
- (CGRect)getObjectFrameForIndex: (int)i {
    return CGRectMake(c[i].x - c[i].r, c[i].y - c[i].r, c[i].r*2, c[i].r*2);
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
    
    double dx,dy,dr;
    
    // Test for, and handle, circle collisions
    for (int i=0; i<QUANTITY; i++) {
        for (int j=i+1; j<QUANTITY; j++) {
            dr = (c[i].r + c[j].r)*(c[i].r + c[j].r);
            dx = c[i].x - c[j].x;
            dy = c[i].y - c[j].y;
            if (dx * dx + dy * dy < dr) {
                if (i!=lastCollision1 || j!=lastCollision2) {
                    [self separateCircles: &(c[i]) with: &(c[j])];
                    [self adjustUIViewVelocityForCollision: &(c[i]) with: &(c[j])];
                    lastCollision1 = i;
                    lastCollision2 = j;
                }
            }
        }
    }
    
    // Test for, and handle, wall collisions
    for (int i=0; i<QUANTITY; i++) {
        if ([self adjustUIViewVelocityForWallCollision: &(c[i])]) {
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
    
    for (int i=0; i<QUANTITY; i++) {
        c[i].vx -= ax;
        c[i].vy -= ay;
        c[i].x = c[i].x + c[i].vx * TIME_INCREMENT;
        c[i].y = c[i].y + c[i].vy * TIME_INCREMENT;
    }
}

/*
 * Once a circle collision is detected, move the two circles apart so they are not overlapping
 */
- (void)separateCircles: (circType *)a with: (circType *)b {
    
    //double midpointx = (a->x + b->x) / 2.0;
    //double midpointy = (a->y + b->y) / 2.0;
    
    double midpointx = (a->x * b->r + b->x * a->r) / (a->r + b->r);
    double midpointy = (a->y * b->r + b->y * a->r) / (a->r + b->r);
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    
    double ax = midpointx + a->r * (a->x - b->x) / d;
    double ay = midpointy + a->r * (a->y - b->y) / d;
    double bx = midpointx + b->r * (b->x - a->x) / d;
    double by = midpointy + b->r * (b->y - a->y) / d;
    
    a->x = ax;
    a->y = ay;
    b->x = bx;
    b->y = by;
    
}

/*
 * When two circles collide, calculate the new velocity values
 */
- (void)adjustUIViewVelocityForCollision: (circType *)a with: (circType *)b {
    //DLog(@"adjustUIViewVelocityForCollision:");
    
    double mb = a->r * a->r;
    double ma = b->r * b->r;
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    
    double nx = (b->x - a->x) / d;
    double ny = (b->y - a->y) / d;
    double p = 2 * (a->vx * nx + a->vy * ny - b->vx * nx - b->vy * ny) / (ma + mb);
    double new_aVx = a->vx - p * ma * nx;
    double new_aVy = a->vy - p * ma * ny;
    double new_bVx = b->vx + p * mb * nx;
    double new_bVy = b->vy + p * mb * ny;
    
    a->vx = new_aVx * ATTENUATION;
    a->vy = new_aVy * ATTENUATION;
    b->vx = new_bVx * ATTENUATION;
    b->vy = new_bVy * ATTENUATION;    
}

/*
 * When a circle hits a wall, calculate the new velocity values
 */
- (BOOL)adjustUIViewVelocityForWallCollision: (circType *)a {
    //Dlog(@"adjustUIViewVelocityForWallCollision:");
    
    // You have to check all four walls, because if a ball is in a corner and you return after checking
    // just one wall, the ball will act erratically
    BOOL ret = NO;
    
    if (a->x < a->r) {
        a->x = a->r;
        a->vx = abs(a->vx);
        ret = YES;
    }
    
    if (a->x > width - a->r) {
        a->x = width - a->r;
        a->vx = -abs(a->vx);
        ret = YES;
    }
    
    if (a->y < a->r) {
        a->y = a->r;
        a->vy = abs(a->vy);
        ret = YES;
    }
    
    if (a->y > height - a->r) {
        a->y = height - a->r;
        a->vy = -abs(a->vy);
        ret = YES;
    }
    
    return ret;
}

@end
