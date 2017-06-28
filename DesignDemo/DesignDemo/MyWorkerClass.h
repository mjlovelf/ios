//
//  MyWorkerClass.h
//  DesignDemo
//
//  Created by mjbest on 17/6/27.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kMsg1 100
#define kMsg2 101

@interface MyWorkerClass : NSObject

- (void)launchThreadWithPort:(NSPort *)port;
@end
