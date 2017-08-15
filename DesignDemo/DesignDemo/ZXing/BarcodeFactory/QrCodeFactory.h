//
//  CWTMBarcodeFactory.h
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QrCodeView.h"

@protocol QrcodeFactory <NSObject>

- (id<QrCodeView>)getBarCodeViewWithFrame:(CGRect)rect view:(UIView *)view;

@end
