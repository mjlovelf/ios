//
//  baseMethod.h
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rootMethod.h"

@interface MiddleMethod : rootMethod

//应用名
@property(nonatomic, copy)NSString *appname;
//应用url
@property(nonatomic, copy)NSString *url;
//是否隐藏
@property(nonatomic, assign)BOOL hide;

+(void)startTest;
@end
