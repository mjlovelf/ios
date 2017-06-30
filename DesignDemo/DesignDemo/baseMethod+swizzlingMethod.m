//
//  baseMethod+swizzlingMethod.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "baseMethod+swizzlingMethod.h"
#import <objc/runtime.h>
@implementation baseMethod (swizzlingMethod)

+ (void)load{

    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{

    SEL parentSelector   = @selector(writeSome);
    SEL currentSelector  = @selector(godIsGoodMan);
    Method parentMethod  = class_getInstanceMethod(self, parentSelector);
    Method currentMethod = class_getInstanceMethod(self, currentSelector);


});

}
- (void)godIsGoodMan{

    NSLog(@"godisgood");
}
@end
