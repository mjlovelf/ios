//
//  baseMethod.m
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MiddleMethod.h"
#import <objc/runtime.h>
@implementation MiddleMethod

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    if ([propertyName isEqualToString: @"hide"]){
        return YES;
    }

    return NO;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int varCount = 0;
    Ivar *ivarList = class_copyIvarList([self class], &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = *(ivarList + i);
        const char *varName = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:varName];
        id varValue = [self valueForKey:key];//使用KVC获取key对应的变量值
        if (varValue) {
            [coder encodeObject:varValue forKey:key];
        }
    }
    free(ivarList);
}
//对变量解码
- (id)initWithCoder:(NSCoder *)coder
{
    unsigned int iVarCount = 0;
    Ivar *iVarList = class_copyIvarList([self class], &iVarCount);//取得变量列表,[self class]表示对自身类进行操作
    for (int i = 0; i < iVarCount; i++) {
        Ivar var = *(iVarList + i);
        const char * varName = ivar_getName(var);//取得变量名字，将作为key
        NSString *key = [NSString stringWithUTF8String:varName];
        //decode
        id  value = [coder decodeObjectForKey:key];//解码
        if (value) {
            [self setValue:value forKey:key];//使用KVC强制写入到对象中
        }
    }
    free(iVarList);//记得释放内存
    return self;
}


- (void)writeBaseSome{

    NSLog(@"执行了.......");
}

@end

