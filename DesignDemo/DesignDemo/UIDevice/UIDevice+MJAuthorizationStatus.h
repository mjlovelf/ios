//
//  MJAuthorizationStatus
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIDevice (MJAuthorizationStatus)

//判断摄像头是否已经授权可以使用
- (BOOL)isCameraAuthorization;
//相册是否授权
- (BOOL)isPhotoLibraryAuthorization;

@end
