//
//  baseMethod+swizzlingMethod.h
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "MiddleMethod.h"

@interface MiddleMethod (swizzlingMethod)

@property(nonatomic, copy)NSString *categaryProperite;

-(void)logAllProperite;

-(void)logPublicProperite;

-(void)printAllMethod:(Class) idcontent idtest:(id)idtest;

-(void)printAllStaticMethod:(Class)idcontent idtest:(id)idtest;
@end
