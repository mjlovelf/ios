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
/*
 NSString *data = @"http://www.jianshu.com/users/b8b48d8bdb6b/latest_articles";
 if (data == 0)
 return;
 ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
 ZXBitMatrix *result = [writer encode:data
 format:kBarcodeFormatQRCode
 width:self.imageView.frame.size.width
 height:self.imageView.frame.size.width error:nil];
 if (result) {
 ZXImage *image = [ZXImage imageWithMatrix:result];
 _imageView.image = [UIImage imageWithCGImage:image.cgimage];
 } else {
 _imageView.image = nil;
 }
 CGImageRef imageToDecode;  // Given a CGImage in which we are looking for barcodes

 ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage: _imageView.image.CGImage];
 ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];

 NSError *error = nil;

 // There are a number of hints we can give to the reader, including
 // possible formats, allowed lengths, and the string encoding.
 ZXDecodeHints *hints = [ZXDecodeHints hints];

 ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
 ZXResult *kresult = [reader decode:bitmap
 hints:hints
 error:&error];
 if (kresult) {
 // The coded result as a string. The raw data can be accessed with
 // result.rawBytes and result.length.
 NSString *contents = kresult.text;

 // The barcode format, such as a QR code or UPC-A
 ZXBarcodeFormat format = kresult.barcodeFormat;
 } else {
 // Use error to determine why we didn't get a result, such as a barcode
 // not being found, an invalid checksum, or a format inconsistency.
 }
 */
@end
