//
//  UIDevice+MJiPhoneType.m
//  DesignDemo
//  Created by mjbest on 2017/8/7.
//  Copyright © 2017年 majian. All rights reserved.
//

#import "UIDevice+MJDeviceName.h"
#import <sys/utsname.h>

//iPhone DevicePlatform
NSString *const DevicePlatform_i386         = @"i386";
NSString *const DevicePlatform_x86_64       = @"x86_64";
NSString *const DevicePlatform_iPhone4_1    = @"iPhone4,1";
NSString *const DevicePlatform_iPhone5_1    = @"iPhone5,1";
NSString *const DevicePlatform_iPhone5_2    = @"iPhone5,2";
NSString *const DevicePlatform_iPhone5_3    = @"iPhone5,3";
NSString *const DevicePlatform_iPhone5_4    = @"iPhone5,4";
NSString *const DevicePlatform_iPhone6_1    = @"iPhone6,1";
NSString *const DevicePlatform_iPhone6_2    = @"iPhone6,2";
NSString *const DevicePlatform_iPhone7_1    = @"iPhone7,1";
NSString *const DevicePlatform_iPhone7_2    = @"iPhone7,2";
NSString *const DevicePlatform_iPhone8_1    = @"iPhone8,1";
NSString *const DevicePlatform_iPhone8_2    = @"iPhone8,2";
NSString *const DevicePlatform_iPhone9_1    = @"iPhone9,1";
NSString *const DevicePlatform_iPhone9_2    = @"iPhone9,2";

//ipad DevicePlatform
NSString *const DevicePlatform_iPad2_1      = @"iPad2,1";
NSString *const DevicePlatform_iPad2_2      = @"iPad2,2";
NSString *const DevicePlatform_iPad2_3      = @"iPad2,3";
NSString *const DevicePlatform_iPad2_4      = @"iPad2,4";
NSString *const DevicePlatform_iPad2_5      = @"iPad2,5";
NSString *const DevicePlatform_iPad2_6      = @"iPad2,6";
NSString *const DevicePlatform_iPad2_7      = @"iPad2,7";
NSString *const DevicePlatform_iPad3_1      = @"iPad3,1";
NSString *const DevicePlatform_iPad3_2      = @"iPad3,2";
NSString *const DevicePlatform_iPad3_3      = @"iPad3,3";
NSString *const DevicePlatform_iPad3_4      = @"iPad3,4";
NSString *const DevicePlatform_iPad3_5      = @"iPad3,5";
NSString *const DevicePlatform_iPad3_6      = @"iPad3,6";
NSString *const DevicePlatform_iPad4_1      = @"iPad4,1";
NSString *const DevicePlatform_iPad4_2      = @"iPad4,2";
NSString *const DevicePlatform_iPad4_4      = @"iPad4,4";
NSString *const DevicePlatform_iPad4_5      = @"iPad4,5";
NSString *const DevicePlatform_iPad4_6      = @"iPad4,6";
NSString *const DevicePlatform_iPad4_7      = @"iPad4,7";
NSString *const DevicePlatform_iPad4_8      = @"iPad4,8";
NSString *const DevicePlatform_iPad4_9      = @"iPad4,9";
NSString *const DevicePlatform_iPad5_1      = @"iPad5,1";
NSString *const DevicePlatform_iPad5_2      = @"iPad5,2";
NSString *const DevicePlatform_iPad5_3      = @"iPad5,3";
NSString *const DevicePlatform_iPad5_4      = @"iPad5,4";

//iPhone DeviceName
NSString *const Device_Simulator    = @"Simulator";
NSString *const Device_iPhone4S     = @"iPhone 4S";
NSString *const Device_iPhone5      = @"iPhone 5";
NSString *const Device_iPhone5S     = @"iPhone 5S";
NSString *const Device_iPhone5C     = @"iPhone 5C";
NSString *const Device_iPhone6      = @"iPhone 6";
NSString *const Device_iPhone6plus  = @"iPhone 6 Plus";
NSString *const Device_iPhone6S     = @"iPhone 6S";
NSString *const Device_iPhone6Splus = @"iPhone 6S Plus";
NSString *const Device_iPhone7      = @"iPhone 7";
NSString *const Device_iPhone7Plus  = @"iPhone 7 Plus";

//ipad DeviceName
NSString *const Device_iPad2        = @"iPad 2";
NSString *const Device_iPad3        = @"iPad 3";
NSString *const Device_iPad4        = @"iPad 4";
NSString *const Device_iPadMini1    = @"iPad Mini 1";
NSString *const Device_iPadMini2    = @"iPad Mini 2";
NSString *const Device_iPadMini3    = @"iPad Mini 3";
NSString *const Device_iPadAir1     = @"iPad Air 1";
NSString *const Device_iPadAir2     = @"iPad Air 2";
NSString *const Device_iPadmini4    = @"iPad mini 4";
NSString *const Device_Unrecognized = @"unrecognized";


@implementation UIDevice (MJDeviceName)

- (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    static NSDictionary *deviceNamesByPlatformDic = nil;

    if (deviceNamesByPlatformDic == nil) {

        deviceNamesByPlatformDic = @{DevicePlatform_i386      : Device_Simulator,
                                     DevicePlatform_x86_64    : Device_Simulator,
                                     DevicePlatform_iPhone4_1 : Device_iPhone4S,
                                     DevicePlatform_iPhone5_1 : Device_iPhone5,
                                     DevicePlatform_iPhone5_2 : Device_iPhone5,
                                     DevicePlatform_iPhone5_3 : Device_iPhone5C,
                                     DevicePlatform_iPhone5_4 : Device_iPhone5C,
                                     DevicePlatform_iPhone6_2 : Device_iPhone5S,
                                     DevicePlatform_iPhone6_2 : Device_iPhone5S,
                                     DevicePlatform_iPhone7_1 : Device_iPhone6plus,
                                     DevicePlatform_iPhone7_2 : Device_iPhone6,
                                     DevicePlatform_iPhone8_1 : Device_iPhone6S,
                                     DevicePlatform_iPhone8_2 : Device_iPhone6Splus,
                                     DevicePlatform_iPhone9_1 : Device_iPhone7,
                                     DevicePlatform_iPhone9_2 : Device_iPhone7Plus,
                                     DevicePlatform_iPad2_1   : Device_iPad2,
                                     DevicePlatform_iPad2_2   : Device_iPad2,
                                     DevicePlatform_iPad2_3   : Device_iPad2,
                                     DevicePlatform_iPad2_4   : Device_iPad2,
                                     DevicePlatform_iPad2_5   : Device_iPadMini1,
                                     DevicePlatform_iPad2_6   : Device_iPadMini1,
                                     DevicePlatform_iPad2_7   : Device_iPadMini1,
                                     DevicePlatform_iPad3_1   : Device_iPad3,
                                     DevicePlatform_iPad3_2   : Device_iPad3,
                                     DevicePlatform_iPad3_3   : Device_iPad3,
                                     DevicePlatform_iPad3_4   : Device_iPad4,
                                     DevicePlatform_iPad3_5   : Device_iPad4,
                                     DevicePlatform_iPad3_6   : Device_iPad4,
                                     DevicePlatform_iPad4_1   : Device_iPadAir1,
                                     DevicePlatform_iPad4_2   : Device_iPadAir2,
                                     DevicePlatform_iPad4_4   : Device_iPadMini2,
                                     DevicePlatform_iPad4_5   : Device_iPadMini2,
                                     DevicePlatform_iPad4_6   : Device_iPadMini2,
                                     DevicePlatform_iPad4_7   : Device_iPadMini3,
                                     DevicePlatform_iPad4_8   : Device_iPadMini3,
                                     DevicePlatform_iPad4_9   : Device_iPadMini3,
                                     DevicePlatform_iPad5_1   : Device_iPadmini4,
                                     DevicePlatform_iPad5_2   : Device_iPadmini4,
                                     DevicePlatform_iPad5_3   : Device_iPadMini2,
                                     DevicePlatform_iPad5_4   : Device_iPadMini2,};
    }

    NSString *deviceName = [deviceNamesByPlatformDic objectForKey:platform];

    if (deviceName == nil)
    {
        deviceName = Device_Unrecognized;
    }

    return deviceName;
}

@end
