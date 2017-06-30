//
//  baseMethod+swizzlingMethod.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "baseMethod+swizzlingMethod.h"
#import <objc/runtime.h>
static const char *ignoreActionKey = "ignoreActionKey";

@implementation baseMethod (swizzlingMethod)

+ (void)load{

    static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{

    SEL parentSelector   = @selector(writeSome);
    SEL currentSelector  = @selector(godIsGoodMan);
    Method parentMethod  = class_getInstanceMethod(self, parentSelector);
    Method currentMethod = class_getInstanceMethod(self, currentSelector);
  //  主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。这时使用 class_getInstanceMethod 函数获取到的 parentSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, currentSelector, method_getImplementation(parentMethod), method_getTypeEncoding(parentMethod));
   // 将父类的实现替换到我们自定义的 godIsGoodMan 方法中。这样就达到了在 godIsGoodMan 方法的实现中调用父类实现的目的
    // class_addMethod 和 class_replaceMethod 的逻辑一定要加。因为就是要防止 Swizzling 掉父类的方法。如果父类方法被 Swizzling 掉的话，其他继承这个类没实现这个方法，且调用了的话，会 unrecognized selector，因为它会调 那个 swizzling 的方法。
    BOOL success = class_addMethod(self, parentSelector, method_getImplementation(currentMethod), method_getTypeEncoding(currentMethod));
    if (success) {
        class_replaceMethod(self, currentSelector, method_getImplementation(parentMethod), method_getTypeEncoding(parentMethod));
    }else{
        method_exchangeImplementations(parentMethod, currentMethod);

    }

});

}
- (void)godIsGoodMan{

    NSLog(@"godisgood");
}

-(void)logAllProperite{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([baseMethod class], &count);
    for (int i = 0; i<count; i++) {
        NSLog(@"所有属性有＝%@",[NSString stringWithUTF8String:ivar_getName(ivars[i])]);
    }
}

-(void)logPublicProperite{

    unsigned int count = 0;
      objc_property_t *ivars = class_copyPropertyList([baseMethod class], &count);
    for (int i = 0; i<count; i++) {
        NSLog(@"公共属性有＝%@",[NSString stringWithUTF8String:property_getName(ivars[i])]);
    }
}
//通过设置getset方法，可在categary中添加属性
- (void)setCategaryProperite:(NSString *)categaryProperite{
    objc_setAssociatedObject([middleMethod class], ignoreActionKey, categaryProperite, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)categaryProperite{

   return  objc_getAssociatedObject([middleMethod class], ignoreActionKey);
}
@end
