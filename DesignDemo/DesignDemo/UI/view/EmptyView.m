//
//  EmptyView.m
//  DesignDemo
//
//  Created by mjbest on 2017/9/22.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "EmptyView.h"

@interface EmptyView(){

    UIImageView *imageView;
    UIButton    *button;
}

@end

@implementation EmptyView

//初始化
- (void)initView:(UIImage *)image labelArray:(NSArray<NSString *> *)labelArray buttonText:(NSString *)buttonText{




}
//更新ui

//更新约束
- (void)updateViewConstraints:(CGFloat) ImageTopConstraints{


}
//ui
- (UIImageView *)drawImageView:(UIImage *)image{

    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    imageView.image = image;
    return imageView;
}

- (UIButton *)drawUIButton:(NSString *)buttonText{

    if(!button){
        button = [[UIButton alloc] init];
    }
    [button setTitle:buttonText forState:UIControlStateNormal];
    return button;
}
//自定义部分属性

@end
