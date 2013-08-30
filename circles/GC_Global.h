//
//  GC_Global.h
//  circles
//
//  Created by campbelg on 8/14/13.
//  Copyright (c) 2013 george. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(s, ...) NSLog(@ " %@ %d  %@", [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat: (s), ## __VA_ARGS__])
#else
#define DLog(s, ...)
#endif

#define ELog(s, ...) NSLog(@ "<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat: (s), ## __VA_ARGS__])
#define ILog(s, ...) NSLog(@ "<%p %@:(%d)>\n%@\n\n", self, [[NSString stringWithUTF8String: __FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat: (s), ## __VA_ARGS__])


#define QUANTITY 0
#define TIME_INCREMENT .00001
#define VELOCITY 0
#define RADIUS_MAX 6
#define RADIUS_MIN 6
#define RADIUS_BOUNDS 40
#define BALL_ATTENUATION 1
#define WALL_ATTENUATION 1
#define GRAVITY 0
#define TIMER_INTERVAL 0.05
#define ADD_NEW_SPHERE 1
#define RADIUS_SHRINK_RATE 0.997
#define INITIAL_VELOCITY 500000
#define MAX_NUMBER_OF_BALLS 200

@interface GC_Global : NSObject

@end
