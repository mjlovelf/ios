//
//  DataHelper.m
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper
//单例类保证了应用程序的生命周期中有且仅有一个该类的实例对象，而且易于外界访问。
+(instancetype) shareManager{
    static dispatch_once_t onceToken;
    static DataHelper *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc]init];
    });
    return helper;
}
@end
