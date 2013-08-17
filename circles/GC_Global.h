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


#define QUANTITY 200
#define CALCULATIONS_PER_SECOND 48
#define TIME_INCREMENT .0005
#define VELOCITY 0
#define RADIUS_MAX 40
#define RADIUS_MIN 15
#define RADIUS_BOUNDS 110
#define BALL_ATTENUATION 0.9
#define WALL_ATTENUATION 0.9
#define GRAVITY -20
#define HASH_SIZE 200
#define RADIUS_ATTENUATION 0.99
#define VANISH_SIZE 3


@interface GC_Global : NSObject

@end
