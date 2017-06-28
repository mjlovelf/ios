//
//  baseModel.h
//  DesignDemo
//
//  Created by mjbest on 17/6/13.
//  Copyright © 2017年 majian. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface baseModel : NSObject

@property(nonatomic,copy) NSString *msg1;

@property(nonatomic,copy) NSString *msg2;

-(void)initDataWithMsg:(NSString *)msg1 msg2:(NSString *)msg2;

@end
