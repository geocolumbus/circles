//
//  GC_Global.h
//  circles
//
//  Created by campbelg on 8/14/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @" %@ %d  %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#define ELog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define ILog( s, ... ) NSLog( @"<%p %@:(%d)>\n%@\n\n", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )


#define QUANTITY 2500
#define CALCULATIONS_PER_SECOND 48
#define TIME_INCREMENT .0025
#define VELOCITY 0
#define RADIUS_MAX 10
#define RADIUS_MIN 3
#define RADIUS_BOUNDS 16
#define BALL_ATTENUATION1 1.01
#define BALL_ATTENUATION2 .8
#define BALL_ATTENUATION_SWITCH 160
#define WALL_ATTENUATION 0.9
#define GRAVITY -50


@interface GC_Global : NSObject

@end
