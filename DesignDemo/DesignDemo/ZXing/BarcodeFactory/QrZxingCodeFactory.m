//
//  CWTMZBarCodeFactory.m
//  TruckManager
//
//  Created by steven on 2017/8/3.
//  Copyright © 2017年 XQ. All rights reserved.
//

#import "QrZxingCodeFactory.h"

@implementation QrZxingCodeFactory

- (id<QrCodeView>)getBarCodeViewWithFrame:(CGRect)rect view:(UIView *)view
{
    QrZxingCodeView *zbarCodeView = [[QrZxingCodeView alloc] initWithFrame:rect view:view];

    return zbarCodeView;
}

@end
