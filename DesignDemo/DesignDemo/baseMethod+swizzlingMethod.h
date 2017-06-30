//
//  baseMethod+swizzlingMethod.h
//  DesignDemo
//
//  Created by mjbest on 17/6/29.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "baseMethod.h"

@interface baseMethod (swizzlingMethod)

@property(nonatomic, copy)NSString *categaryProperite;

-(void)logAllProperite;

-(void)logPublicProperite;
@end
