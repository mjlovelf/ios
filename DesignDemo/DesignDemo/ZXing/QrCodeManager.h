//
//  QrCodeManager.h
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OpenBarCodeViewControllerStyle)
{
    OpenBarCodeViewControllerStyle_Push = 1,
    OpenBarCodeViewControllerStyle_present
};

typedef void (^ScanCodeSucess)(NSString *barCode, NSInteger status);//扫描成功回调

/**
 二维码扫描失败block

 @param errStr 失败原因
 @param status 状态
 @param isPopViewController 是否需要pop出当前viewcontroller，yes为需要
 */
typedef void (^ScanCodeFailure)(NSString *errStr, NSInteger status,BOOL isPopViewController);//扫描失败回调
typedef void (^ScanCodeCancel)(NSString *cancelStr, NSInteger status);//扫描取消回调

@interface QrCodeManager : NSObject

@property (nonatomic, weak) UIViewController *popToViewController;

+ (instancetype)sharedInstance;

/**
 *  进入扫码页面
 *  navigationController:导航控制器
 *  sucess  : 扫描成功回调
 *  failure : 扫描失败回调
 *  cancel  : 扫描取消回调
 */
- (void)openBarCodeViewController:(UINavigationController *)navigationController
                        openStyle:(OpenBarCodeViewControllerStyle)style
                           sucess:(ScanCodeSucess)sucess
                          failure:(ScanCodeFailure)failure
                           cancel:(ScanCodeCancel)cancel;

/**
 *  扫码成功
 *  barCode:  二维码或条形码
 *  status : 扫码状态（0:成功，1:取消，2:失败）
 */
- (void)scanBarCodeSucess:(NSString *)barCode scanStatus:(NSInteger)status;

/**
 *  扫码失败
 *  errStr:  二维码扫描失败原因
 *  status : 扫码状态（0:成功，1:取消，2:失败）
 *  isPopViewController 是否需要pop出当前viewcontroller，yes为需要
 */
- (void)scanBarCodeFailure:(NSString *)errStr scanStatus:(NSInteger)status isPopViewController:(BOOL)isPopViewController;

//暂时未用
/**
 *  扫码失败
 *  errStr:  二维码扫描失败原因
 *  status : 扫码状态（0:成功，1:取消，2:失败）
 */
- (void)scanBarCodeCancel:(NSString *)cancelStr scanStatus:(NSInteger)status;

/**
 *  扫码成功、失败或取消返回的页面
 *  navigationController:  导航控制器
 */
- (BOOL)popToViewController:(UINavigationController *)navigationController;

@end
