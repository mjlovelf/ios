//
//  CWTMBarCodeManager.m
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//
#import "QrCodeManager.h"
#import "QrZXingController.h"

@interface QrCodeManager ()

@property (nonatomic, strong) ScanCodeSucess scanSucess;
@property (nonatomic, strong) ScanCodeFailure scanFailure;
@property (nonatomic, strong) ScanCodeCancel scanCancel;

@end

@implementation QrCodeManager

+ (instancetype)sharedInstance
{
    static QrCodeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {

    }

    return self;
}

- (void)openBarCodeViewController:(UINavigationController *)navigationController
                        openStyle:(OpenBarCodeViewControllerStyle)style
                           sucess:(ScanCodeSucess)sucess
                          failure:(ScanCodeFailure)failure
                           cancel:(ScanCodeCancel)cancel
{
    self.scanSucess = sucess;
    self.scanFailure = failure;
    self.scanCancel = cancel;

    if (navigationController)
    {
        switch (style) {
            case OpenBarCodeViewControllerStyle_Push:
            {
                QrZXingController *barCodeViewController = [[QrZXingController alloc] init];
                [navigationController pushViewController:barCodeViewController animated:YES];
            }
                break;
            case OpenBarCodeViewControllerStyle_present:
            {
                QrZXingController *barCodeViewController = [[QrZXingController alloc] init];
                [navigationController presentViewController:barCodeViewController animated:YES completion:nil];
            }
                break;
            default:
            {
                QrZXingController *barCodeViewController = [[QrZXingController alloc] init];
                [navigationController pushViewController:barCodeViewController animated:YES];
            }
                break;
        }

    }

}

- (void)scanBarCodeSucess:(NSString *)barCode scanStatus:(NSInteger)status
{
    if (self.scanSucess)
    {
        self.scanSucess(barCode,status);
    }
}

- (void)scanBarCodeFailure:(NSString *)errStr scanStatus:(NSInteger)status isPopViewController:(BOOL)isPopViewController
{
    if (self.scanFailure)
    {
        self.scanFailure(errStr,status,isPopViewController);
    }
}

- (void)scanBarCodeCancel:(NSString *)cancelStr scanStatus:(NSInteger)status
{
    if (self.scanCancel)
    {
        self.scanCancel(cancelStr,status);
    }
}

- (BOOL)popToViewController:(UINavigationController *)navigationController
{
    if (navigationController && self.popToViewController)
    {
        [navigationController popToViewController:self.popToViewController animated:YES];

        return YES;
    }

    return NO;
}
@end
