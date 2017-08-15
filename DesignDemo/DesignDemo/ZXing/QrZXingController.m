//
//  ZXingQRController.m
//  DesignDemo
//
//  Created by mjbest on 2017/8/10.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "QrZXingController.h"
#import "QrCodeManager.h"
#import "QrZxingCodeFactory.h"


@interface QrZXingController ()
{
    id<QrCodeView> barCodeView;

}
@end

@implementation QrZXingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码扫描";
    self.view.backgroundColor = [UIColor blackColor];
    [self initBarCode];
    [self scanBarCodeSucess];
    [self scanBarCodeFailure];
}

- (void)initBarCode
{
    id<QrcodeFactory> barCodeFactory = [[QrZxingCodeFactory alloc] init];
    barCodeView = [barCodeFactory getBarCodeViewWithFrame:self.view.bounds view:self.view];
    [barCodeView startScan];
}

//扫码成功执行的回调
- (void)scanBarCodeSucess
{
    barCodeView.scanCodeSucess = ^(NSString *barCode,NSInteger status){
        [[QrCodeManager sharedInstance] scanBarCodeSucess:barCode scanStatus:status];
    };
}

//扫码失败之行的回调
- (void)scanBarCodeFailure
{
    barCodeView.scanCodeFailure = ^(NSString *errStr,NSInteger status, BOOL isPopViewController)
    {
        [[QrCodeManager sharedInstance] scanBarCodeFailure:errStr scanStatus:status isPopViewController:isPopViewController
         ];
    };
}

- (IBAction)clickBack:(id)sender
{
    [[QrCodeManager sharedInstance] scanBarCodeFailure:nil scanStatus:ScanBarCodeStatus_Failure isPopViewController:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [barCodeView stopScan];

}
@end
