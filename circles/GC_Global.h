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


#define QUANTITY 100
#define CALCULATIONS_PER_SECOND 48
#define TIME_INCREMENT .00025
#define VELOCITY 0
#define RADIUS_MAX 10
#define RADIUS_MIN 10
#define RADIUS_BOUNDS 18
#define BALL_ATTENUATION .9
//#define BALL_ATTENUATION1 .9
//#define BALL_ATTENUATION2 .9
//#define BALL_ATTENUATION_SWITCH 300
#define WALL_ATTENUATION 0.9
#define GRAVITY -60
#define HASH_SIZE 200


@interface GC_Global : NSObject

@end
