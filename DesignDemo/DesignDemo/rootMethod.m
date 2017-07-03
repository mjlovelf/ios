//
//  middleMethod.m
//  DesignDemo
//
//  Created by mjbest on 17/6/30.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "rootMethod.h"

@implementation rootMethod

- (void)writeSome{

    NSLog(@"执行了writeSome");
}

//私有实例化方法
- (NSString *)privateMethod:(NSString *)inputString{

    NSString *result = [NSString stringWithFormat:@"私有实例化方法=%@",inputString];
    return result;
}
//私有静态方法
+ (NSString *)privateStaticMethod:(NSString *)inputString{

    NSString *result = [NSString stringWithFormat:@"私有静态方法=%@",inputString];
    return result;
}
@end
