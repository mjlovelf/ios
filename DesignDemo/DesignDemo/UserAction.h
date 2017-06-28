//
//  UserAction.h
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "baseModel.h"

@interface UserAction : baseModel

@property(nonatomic,copy) NSString *buy;
@property(nonatomic,copy) NSString *sell;

-(void)initDataWithBuy:(NSString *)buy sell:(NSString *)sell;

@end
