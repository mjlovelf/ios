//
//  QrCodeView.h
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ScanCodeSucess)(NSString *barCode,NSInteger status);
typedef void (^ScanCodeFailure)(NSString *errStr,NSInteger status,BOOL isPopViewController);

@protocol QrCodeView <NSObject>

//初始化扫码
- (instancetype)initWithFrame:(CGRect)rect view:(UIView *)view;

//打开摄像头扫描
- (void)startScan;

//关闭摄像头
- (void)stopScan;

@optional
//打开或关闭手电筒
- (void)changeTorchStatus:(id)sender;

//获取扫描的View
- (UIView *)getBarCodeView;

//判断摄像头的权限
- (BOOL)requestAccessForCamera;

//显示无权限弹框，点击取消不执行任何操作，确定跳转到权限设置页面
- (void)showCameraAlert;

//二维码失败回调，并且不关闭当前页面
- (void)scanFailedAndNotPopViewController;

//扫描成功
@property (nonatomic, copy) ScanCodeSucess scanCodeSucess;

//扫描失败
@property (nonatomic, copy) ScanCodeFailure scanCodeFailure;

@end
