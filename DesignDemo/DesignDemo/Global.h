//
//  Global.h
//  DesignDemo
//
//  Created by mjbest on 17/6/28.
//  Copyright © 2017年 majian. All rights reserved.
//

#ifndef Global_h
#define Global_h

/*
 *  弱引用&强引用
 */
#define WEAK_SELF_OBJ(obj)   __weak __typeof(obj) weakSelf = obj;
#define STRONG_SELF_OBJ(obj)  __strong __typeof(obj) strongSelf = obj; if (!strongSelf) {DLog(@">>>>> strongSelf = nil >>>>>");return ;}

/**
 *  自定义button类型
 */
typedef NS_ENUM(NSInteger, CustomButtonType){
    CustomButtonType_Back,//返回
    CustomButtonType_Text,//文字
    CustomButtonType_Img,//图片
};

#endif /* Global_h */
