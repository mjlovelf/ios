//
//  baseMethod+swizzlingMethod.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MiddleMethod+swizzlingMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
static const char *ignoreActionKey = "ignoreActionKey";

@implementation MiddleMethod (swizzlingMethod)

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
    Ivar *ivars = class_copyIvarList([MiddleMethod class], &count);
    for (int i = 0; i<count; i++) {
        NSLog(@"所有属性有＝%@",[NSString stringWithUTF8String:ivar_getName(ivars[i])]);
    }
}

-(void)logPublicProperite{

    unsigned int count = 0;
      objc_property_t *ivars = class_copyPropertyList([MiddleMethod class], &count);
    for (int i = 0; i<count; i++) {
        NSLog(@"公共属性有＝%@",[NSString stringWithUTF8String:property_getName(ivars[i])]);
    }
}
//通过设置getset方法，可在categary中添加属性
- (void)setCategaryProperite:(NSString *)categaryProperite{
    objc_setAssociatedObject([rootMethod class], ignoreActionKey, categaryProperite, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)categaryProperite{

   return  objc_getAssociatedObject([rootMethod class], ignoreActionKey);
}
//此方法只能打印当前class的类，不能打印父类的
-(void)printAllMethod:(Class) idcontent idtest:(id)idtest{
    unsigned int count = 0;
    Method *method = class_copyMethodList(idcontent, &count);
    //实例 化后的方法是可以获取出来的
    for (int i = 0; i<count; i++) {
        NSLog(@"打印使用的方法=%@",[NSString stringWithUTF8String:sel_getName(method_getName(method[i]))]);

    }
    //调用类实例化方法
    NSString *returnValue = ((NSString *(*)(id, SEL, NSString *)) objc_msgSend)((id) idtest, NSSelectorFromString(@"privateMethod:"), @"参数1");
    NSLog(@"打印结果=%@",returnValue);
    free(method);
}

-(void)printAllStaticMethod:(Class)idcontent idtest:(id)idtest{
    unsigned int count = 0;
    //加入object_getClass就只会获取到静态方法，原因是静态的为类方法，需要到metaclass中去获取
    Method *method = class_copyMethodList(object_getClass(idcontent), &count);
    //打印发现，静态的私有方法是无法获取出来的
    for (int i = 0; i<count; i++) {
        NSLog(@"打印使用的方法=%@",[NSString stringWithUTF8String:sel_getName(method_getName(method[i]))]);

    }
    //调用类静态方法
    NSString *returnValue = ((NSString *(*)(id, SEL)) objc_msgSend)((id)self , NSSelectorFromString(@"test"));
    NSLog(@"打印结果=%@",returnValue);
    free(method);

}

-(NSString *)test{
    NSString *returnValue = ((NSString *(*)(id, SEL, NSString *)) objc_msgSend)((id) [rootMethod class] , NSSelectorFromString(@"privateStaticMethod:"), @"参数1");
    NSLog(@"test打印结果=%@",returnValue);
    return returnValue;
}
//总结：objc_msgSend调用静态方法，id需要传class，调用实例化方法需要传递类的实例
@end
