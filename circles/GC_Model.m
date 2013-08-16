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
    int ch[HASH_SIZE][HASH_SIZE];
    int lastCollision1, lastCollision2;
    //double ball_attenuation;
    long counter;
}

/*
 *
 */
- (GC_Model *)initWithWidth: (long)viewWidth andHeight: (long)viewHeight {
    DLog(@"initializeUIViewDataArray");
    
    width = viewWidth;
    height = viewHeight;
    counter = 0;
    //ball_attenuation = BALL_ATTENUATION1;
    
    self.manager = [[CMMotionManager alloc] init];
    self.manager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.manager startDeviceMotionUpdates];
    
    double dx, dy, dr;
    
    // Randomly create circles
    
    c[0].x = 50;
    c[0].y = height/2;
    c[0].vx = 0;
    c[0].vy = 0;
    c[0].r = c[0].x;
    
    // Initialize hash to -1 (no circle in that slot)
    for (int i=0; i<HASH_SIZE; i++) {
        for (int j=0; j<HASH_SIZE; j++) {
            ch[i][j] = -1;
        }
    }
    
    // Initialize circle data
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
        
        // Each circle hashes into one slot. We only have to check the 8 slots surrounding this circle's slot
        // when we do collision detection
        c[i].hashX = (int)round(c[i].x/c[i].r);
        c[i].hashY = (int)round(c[i].y/c[i].r);
        ch[c[i].hashX][c[i].hashY] = i;
        
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
    double r = c[i].r;
    double r2 = r*2;
    return CGRectMake(c[i].x - r, c[i].y - r, r2, r2);
}

/*
 * Calculate the next position of all circles. Circle and wall collisions are handled too.
 */
- (void)calculateNextPosition {
    [self calculateCollisions];
    [self moveCirclesToNextPosition];
    //if (++counter % BALL_ATTENUATION_SWITCH == 0) {
    //    DLog(@"Ball Attenuation Switch!");
    //    ball_attenuation = BALL_ATTENUATION2;
    //}
}

/*
 * Test for and handle circle-circle collisions, and circle-wall collisions
 */
- (void)calculateCollisions {
    //DLog(@"calculateCollisions");
    
    double dx,dy,rsum;
    circType nb[8];
    bool flag[8];
    int hx, hy;
    int hashIndex;
    
    // Test for, and handle, circle collisions
    for (int i=0; i<QUANTITY; i++) {
        hx = c[i].hashX;
        hy = c[i].hashY;
        flag[0]=NO;
        flag[1]=NO;
        flag[2]=NO;
        flag[3]=NO;
        flag[4]=NO;
        flag[5]=NO;
        flag[6]=NO;
        flag[7]=NO;
        
        if (i != lastCollision1) {
            if (hy != 0) {
                if (hx != 0) {
                    nb[0] = c[ch[hx-1][hy-1]];
                    flag[0] = YES;
                }
                nb[1] = c[ch[hx+0][hy-1]];
                flag[1] = YES;
                nb[2] = c[ch[hx+1][hy-1]];
                flag[2] = YES;
            }
            
            if (hx != 0) {
                nb[3] = c[ch[hx-1][hy+0]];
                flag[3] = YES;
            }
            
            nb[4] = c[ch[hx+1][hy+0]];
            flag[4] = YES;
            
            if (hx != 0) {
                nb[5] = c[ch[hx-1][hy+1]];
                flag[5] = YES;
            }
            nb[6] = c[ch[hx+0][hy+1]];
            flag[6] = YES;
            nb[7] = c[ch[hx+1][hy+1]];
            flag[7] = YES;
            
            for (int j=0; j<8; j++)
                if (flag[j]) {
                    hashIndex = ch[nb[j].hashX][nb[j].hashY];
                    
                    if (hashIndex != -1 && hashIndex != lastCollision2) {
                        
                        dx = c[i].x - c[hashIndex].x;
                        dy = c[i].y - c[hashIndex].y;
                        rsum = c[i].r + c[hashIndex].r;
                        if (dx * dx + dy * dy < rsum * rsum) {
                            [self separateCircles: i with: hashIndex];
                            [self adjustUIViewVelocityForCollision: i with: hashIndex];
                            lastCollision1 = i;
                            lastCollision2 = hashIndex;
                        }
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
        
        ch[c[i].hashX][c[i].hashY] = -1;
        
        c[i].x = c[i].x + c[i].vx * TIME_INCREMENT;
        if (c[i].x < 0) {
            c[i].x = 0;
        }
        
        c[i].y = c[i].y + c[i].vy * TIME_INCREMENT;
        if (c[i].y < 0) {
            c[i].y = 0;
        }
        
        c[i].hashX = round(c[i].x/c[i].r);
        c[i].hashY = round(c[i].y/c[i].r);
        
        if (c[i].hashX > HASH_SIZE-1) {
            c[i].hashX = HASH_SIZE-1;
        }
        if (c[i].hashY > HASH_SIZE-1) {
            c[i].hashY = HASH_SIZE-1;
        }
        ch[c[i].hashX][c[i].hashY] = i;
    }
}

/*
 * Once a circle collision is detected, move the two circles apart so they are not overlapping
 */
- (void)separateCircles: (int)i with: (int)j {
    
    circType *a = &c[i];
    circType *b = &c[j];
    
    double ra = a->r + 0.01;
    double rb = b->r + 0.01;
    
    double midpointx = (a->x * rb + b->x * ra) / (ra + rb);
    double midpointy = (a->y * rb + b->y * ra) / (ra + rb);
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    if (d ==0) {
        d=0.01;
    }
    
    double ax = midpointx + ra * (a->x - b->x) / d;
    double ay = midpointy + ra * (a->y - b->y) / d;
    double bx = midpointx + rb * (b->x - a->x) / d;
    double by = midpointy + rb * (b->y - a->y) / d;
    
    ch[a->hashX][a->hashY] = -1;
    
    a->x = ax;
    a->hashX = round(a->x / a->r);
    if (a->hashX > HASH_SIZE-1) {
        a->hashX = HASH_SIZE-1;
    }
    a->y = ay;
    a->hashY = round(a->y / a->r);
    if (a->hashY > HASH_SIZE-1) {
        a->hashY = HASH_SIZE-1;
    }
    
    
    ch[a->hashX][a->hashY] = i;
    
    ch[b->hashX][b->hashY] = -1;
    b->x = bx;
    b->hashX = round(b->x / b->r);
    if (b->hashX > HASH_SIZE-1) {
        b->hashX = HASH_SIZE-1;
    }
    b->y = by;
    b->hashY = round(b->y / b->r);
    if (b->hashY > HASH_SIZE-1) {
        b->hashY = HASH_SIZE-1;
    }
    ch[b->hashX][b->hashY] = j;
    
}

/*
 * When two circles collide, calculate the new velocity values
 */
- (void)adjustUIViewVelocityForCollision: (int)i with: (int)j {
    //DLog(@"adjustUIViewVelocityForCollision:");
    
    circType *a = &c[i];
    circType *b = &c[j];
    
    double mb = a->r * a->r;
    double ma = b->r * b->r;
    
    double d = sqrt((a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y));
    if (d == 0) {
        d = 0.01;
    }
    
    double nx = (b->x - a->x) / d;
    double ny = (b->y - a->y) / d;
    double p = 2 * (a->vx * nx + a->vy * ny - b->vx * nx - b->vy * ny) / (ma + mb);
    double new_aVx = a->vx - p * ma * nx;
    double new_aVy = a->vy - p * ma * ny;
    double new_bVx = b->vx + p * mb * nx;
    double new_bVy = b->vy + p * mb * ny;
    
    a->vx = new_aVx * BALL_ATTENUATION;
    a->vy = new_aVy * BALL_ATTENUATION;
    b->vx = new_bVx * BALL_ATTENUATION;
    b->vy = new_bVy * BALL_ATTENUATION;
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
        a->vx = abs(a->vx) * WALL_ATTENUATION;
        ret = YES;
    }
    
    if (a->x > width - a->r) {
        a->x = width - a->r;
        a->vx = -abs(a->vx) * WALL_ATTENUATION;
        ret = YES;
    }
    
    if (a->y < a->r) {
        a->y = a->r;
        a->vy = abs(a->vy) *WALL_ATTENUATION;
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
