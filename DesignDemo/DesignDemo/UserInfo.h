//
//  UserInfo.h
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseModel.h"

@interface UserInfo : baseModel

@property(nonatomic,copy) NSString *name;

@property(nonatomic,copy) NSString*age;

-(void)initDataWithName:(NSString *)name age:(NSString *)age;

@end
