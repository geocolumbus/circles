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


#define QUANTITY 30
#define TIME_INCREMENT .00001
#define VELOCITY 4
#define RADIUS_MAX 16
#define RADIUS_MIN 4
#define RADIUS_BOUNDS 40
#define BALL_ATTENUATION 0.98
#define WALL_ATTENUATION 0.98
#define GRAVITY -40
#define TIMER_INTERVAL 0.04

@interface GC_Global : NSObject

@end
