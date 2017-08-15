//
//  QrZxingCodeView.h
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

typedef NS_ENUM(NSInteger,ScanBarCodeStatus)
{
    ScanBarCodeStatus_Sucess=0,
    ScanBarCodeStatus_Cancel,
    ScanBarCodeStatus_Failure
};

#import <Foundation/Foundation.h>
#import "QrCodeView.h"
#import <AVFoundation/AVFoundation.h>

@interface QrZxingCodeView : NSObject<QrCodeView, AVCaptureMetadataOutputObjectsDelegate>

@end
