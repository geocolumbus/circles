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


#define QUANTITY 40
#define CALCULATIONS_PER_SECOND 48
#define TIME_INCREMENT .005
#define VELOCITY 0
#define RADIUS_MAX 30
#define RADIUS_MIN 2
#define ATTENUATION .9
#define GRAVITY -10


@interface GC_Global : NSObject

@end
