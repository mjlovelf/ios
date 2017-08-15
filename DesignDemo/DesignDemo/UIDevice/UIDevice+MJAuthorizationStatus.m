//
//  UIDevice+MJAuthorizationStatus.m
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "UIDevice+MJAuthorizationStatus.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation UIDevice (MJAuthorizationStatus)

- (BOOL)isCameraAuthorization
{
    /// 用户是否允许摄像头使用
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        return NO;
    }

    return YES;
}
//相册是否授权
- (BOOL)isPhotoLibraryAuthorization {
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

@end
