//
//  simpleFactory.h
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,DoWhat) {
    //
    DoWhat_UserInfo = 0,
    //
    DoWhat_UserAction,
};

@interface simpleFactory : NSObject

-(void)test:(DoWhat)what;
@end
