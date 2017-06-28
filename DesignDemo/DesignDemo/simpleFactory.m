//
//  simpleFactory.m
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//
#import "UserInfo.h"
#import "UserAction.h"
#import "simpleFactory.h"

@implementation simpleFactory

//简单工厂模式就是由一个工厂类根据传入的参数决定创建哪一种的产品类。
//简单工厂模式会包含过多的判断条件，维护起来不是特别方便
-(void)test:(DoWhat)what{
    switch (what) {
        case DoWhat_UserInfo:{
            UserInfo *info = [[UserInfo alloc]init];
            [info initDataWithName:@"ds" age:@"123"];
        }
            break;
        case DoWhat_UserAction:{
            UserAction *action = [[UserAction alloc] init];
            [action initDataWithBuy:@"332232" sell:@"dfs"];
        }
            break;
    }

}

- (UserInfo *)createInfo{

    return [[UserInfo alloc]init];

}
- (UserAction *)createAction{

    return [[UserAction alloc]init];
    
}
-(void)initData{

    UserInfo *base  = [[UserInfo alloc]init];
    [base initDataWithMsg:@"ddd" msg2:@"3333"];

    UserAction *base1  = [[UserAction alloc]init];
    [base1 initDataWithMsg:@"dd2" msg2:@"3334"];
}
@end
