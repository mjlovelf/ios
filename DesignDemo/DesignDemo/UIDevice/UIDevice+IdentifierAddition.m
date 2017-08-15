//
//  UIDevice+IdentifierAddition.m
//  TruckDriver
//
//  Created by steven on 6/10/15.
//  Copyright (c) 2015 chinaway. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "A0SimpleKeychain.h"

static NSString* const kUUIDName = @"kUUIDSafeCache";

@interface UIDevice()

@end

@implementation UIDevice (IdentifierAddition)

#pragma mark -
#pragma mark Private Methods

- (NSString*)getUUID
{
    // 先检查有没有新版本的数据
    NSString *strUUID = [[A0SimpleKeychain keychain] stringForKey:kUUIDName];

    if ([strUUID length] > 0)
    {
        return strUUID;
    }
    else
    {
        NSLog(@"UUID From Keychain is empty");

        // 如果没有找到老版本的数据，重新生成UUID
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef ref = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        strUUID = [NSString stringWithString:(__bridge NSString *)ref];
        //注意create的东西都必须要释放
        CFRelease(ref);
        CFRelease(uuidRef);

        // 直接按照新版本的格式存储
        if( [[A0SimpleKeychain keychain] setString:strUUID forKey:kUUIDName] )
        {
            return strUUID;
        }
        else
        {
            NSLog(@"Set UUID to keychain failed!");
            return nil;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    return [self getUUID];
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    return [self getUUID];
}


@end
