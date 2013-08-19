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


#define QUANTITY 500
#define TIME_INCREMENT .00001
#define VELOCITY 0
#define RADIUS_MAX 8
#define RADIUS_MIN 4
#define RADIUS_BOUNDS 64
#define BALL_ATTENUATION 0.9
#define WALL_ATTENUATION 0.9
#define GRAVITY -40
#define TIMER_INTERVAL 0.001

@interface GC_Global : NSObject

@end
