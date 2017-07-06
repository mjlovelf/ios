//
//  Utils.m
//  CWTMExpressCourier

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <A0SimpleKeychain.h>
static NSDictionary *kColorDict;
static NSDictionary *kFontDict;
static NSDictionary *kSeperationSpaceDict;

@implementation Utils

+ (void)setCookieWithDomain:(NSString *)domain token:(NSString *)token
{
    // domain不能为空
    if (!domain)
    {
        return;
    }

    //本地user登录app server后的token
    NSString *cookieName_Token = @"token";
    //app server和UCenter维护的token(我们在app server登录后，app sever会在UCenter再登录)
    NSString *cookieName_UcenterToken = @"_TOKEN";
    if ( token )
    {
        //set cookie
        NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];

        [cookiePropertiesUser setObject:cookieName_Token forKey:NSHTTPCookieName];
        [cookiePropertiesUser setObject:token forKey:NSHTTPCookieValue];

        [cookiePropertiesUser setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];

        [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];

        [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];

        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
    }
    else
    {
        //变动:TMP-4064 [iOS]smart购买_退出登录后购买仍显示上一次登录账号的信息
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            if( [cookie.domain isEqualToString:domain] && ([cookie.name isEqualToString:cookieName_Token] || [cookie.name isEqualToString:cookieName_UcenterToken]) )
            {
                [storage deleteCookie:cookie];
            }
        }
    }
}
/**
 *  清除指定domain下的cookie
 *
 *  @param domain domain
 */
+ (void)clearCookieValue:(NSString *)domain {

    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        if([cookie.domain isEqualToString:domain])
        {
            [storage deleteCookie:cookie];

        }
    }
}

/**
 *  清除所有cookie
 */
+ (void)removeAllCookies {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}


/**
 *  将字符串进行md5加密
 */
+ (NSString *)md5:(NSString *)aStr{
    //判断参数，若astr为nil，CC_MD5会崩溃
    if (!aStr) {
        return nil;
    }
    const char *cStr = [aStr UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];

    return output;
}


+ (NSString *)md5:(NSString *)aStr withStartKey:(NSString *)startKey withEndKey:(NSString *)endKey
{
    if (startKey)
    {
        aStr = [startKey stringByAppendingFormat:@"%@",aStr];
    }

    if (endKey)
    {
        aStr = [aStr stringByAppendingString:endKey];
    }

    return [Utils md5:aStr];

}

/**
 *  获取字符串高度
 *
 *  @param text  字符串
 *  @param width 字符串固定最大宽度
 *  @param aFont font
 *
 *  @return 高度
 */
+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont{
    CGFloat result;
    CGSize textSize = { width, 20000.0f };
    CGSize size  = CGSizeZero;

#ifdef IOS7_SDK_AVAILABLE
    NSDictionary *attribute =@{NSFontAttributeName: aFont};
    size = [text boundingRectWithSize:textSize
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute
                              context:nil].size;
#else
    size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
#endif


    result = size.height;
    return result;
}

/**
 *  获取字符串宽带
 *
 *  @param text   字符串
 *  @param height 字符串固定最大高度
 *  @param aFont  font
 *
 *  @return 宽度
 */
+ (CGFloat)widthOfText:(NSString *)text theHeight:(float)height theFont:(UIFont*)aFont {
    CGFloat result;
    CGSize textSize = { 20000.0f,  height};
    CGSize size  = CGSizeZero;

#ifdef IOS7_SDK_AVAILABLE
    NSDictionary *attribute =@{NSFontAttributeName: aFont};
    size = [text boundingRectWithSize:textSize
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute
                              context:nil].size;
#else
    size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
#endif


    result = size.width;
    return result;
}


/**
 *  拉升图片
 *
 *  @param oriImg 原图
 *
 *  @return 处理后的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)oriImg{
    UIImage *resultImg = [oriImg stretchableImageWithLeftCapWidth:oriImg.size.width/2. topCapHeight:oriImg.size.height/2];
    return resultImg;
}

/**
 *  获取16进制转化后的UIColor对象
 *
 *  @param stringToConvert 16进制颜色值
 *
 *  @return UIColor对象
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    if (stringToConvert && stringToConvert.length>0) {
        return [Utils colorWithHexString:stringToConvert alpha:1.0];
    }
    return nil;
}

/**
 *  获取16进制转化后的UIColor对象
 *
 *  @param stringToConvert 16进制颜色值
 *
 *  @return UIColor对象
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert alpha:(CGFloat)alphaNum
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符

    // String should be 6 or 8 characters
    if ([cString length] < 6) return nil;

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return nil;
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    BOOL resultR = [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    BOOL resultG = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    BOOL resultB = [[NSScanner scannerWithString:bString] scanHexInt:&b];

    if( resultR && resultG && resultB )
    {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:alphaNum];
    }
    else
    {
        return nil;
    }
}


/**
 *  处理View为圆角带边框
 *
 *  @param aView  目标view
 *  @param aR     半径
 *  @param aB     边框宽度
 *  @param aColor 边框颜色
 */
+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor{
    if (aR>0.) {
        aView.layer.cornerRadius = aR;
    }
    if (aB>0.) {
        aView.layer.borderWidth = aB;
        aView.layer.borderColor = aColor.CGColor;//
    }
    aView.clipsToBounds = YES;
}

/**
 *  设置UINavigationBar
 *
 *  @param navBar UINavigationBar对象
 */
+ (void)setNavBarBgUI:(UINavigationBar*)navBar{
    navBar.barTintColor = [Utils colorWithHexString:@"252525"];//00c8e0
    navBar.tintColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont boldSystemFontOfSize:20],nil]
                                                      forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    navBar.titleTextAttributes = dict;

}


/**
 *  根据keyStr查找Colors.plist返回color
 *
 *  @param keyStr 颜色编号，如C1
 *
 *  @return UIColor obj
 *
 *  ps:Colors.plist中 C15--2D99EC 为native定义，设计没给
 */
+ (UIColor *)getColorWithKeyString:(NSString *)keyStr{
    UIColor *color = nil;

    if( !kColorDict )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Colors" ofType:@"plist"];
        kColorDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }

    if ([kColorDict.allKeys containsObject:keyStr]) {
        NSString *colorStr = kColorDict[keyStr];
        color = [Utils colorWithHexString:colorStr];
    }

    return color;
}

/**
 *  根据keyStr查找FontSize.plist返回UIFont
 *
 *  @param keyStr 字体大小编号，如A1
 *
 *  @return UIFont obj
 */
+ (UIFont *)getFontWithKeyString:(NSString *)keyStr{
    UIFont *font = nil;

    if( !kFontDict )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"];
        kFontDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }

    if ([kFontDict.allKeys containsObject:keyStr]) {
        font = [UIFont systemFontOfSize:[kFontDict[keyStr] floatValue]];
    }
    return font;
}

+ (UIFont *)getBoldFontWithKeyString:(NSString *)keyStr{
    UIFont *font = nil;

    if( !kFontDict )
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Fonts" ofType:@"plist"];
        kFontDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }

    if ([kFontDict.allKeys containsObject:keyStr]) {
        font = [UIFont boldSystemFontOfSize:[kFontDict[keyStr] floatValue]];
    }
    return font;
}

+ (CGFloat) getSeperationSpaceFromKey:(NSString *) key
{
    CGFloat space = 0;

    if (key.length > 0)
    {
        if( !kSeperationSpaceDict )
        {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Separation" ofType:@"plist"];
            kSeperationSpaceDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        }

        if ( kSeperationSpaceDict && [kSeperationSpaceDict.allKeys containsObject:key] )
        {
            space = [kSeperationSpaceDict[key] floatValue];
        }
    }

    return space;
}

/**
 *  获取已读的颜色
 *
 *  @return 已读的颜色
 */
+ (UIColor *)getColorOfDoRead{
    UIColor *color = [Utils colorWithHexString:@"9bb3c6"];
    return color;
}

/**
 *  获取关注的颜色
 *
 *  @return 关注的颜色
 */
+ (UIColor *)getColorOfFollow{
    UIColor *color = [Utils colorWithHexString:@"ffa101"];
    return color;
}

/**
 *  获取一个含 key ＝ user，value ＝ orgcode的字典
 *
 *  @return 字典
 */
+ (NSMutableDictionary *)getDicContainToken
{
    NSString *token = [Utils getMyToken];

    if (token) {
        return [NSMutableDictionary dictionaryWithObject:token forKey:@"token"];
    }
    return nil;
}

#pragma mark - jsonStr from obj
+ (NSString *)jsonStringWithArray:(NSArray *)ary{

    return [self jsonStringWithObject:ary];
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }

    if ([object isKindOfClass:[NSString class]])
    {
        value = [Utils jsonStringWithString:object];
        return value;

    }else if([object isKindOfClass:[NSNumber class]])
    {
        value = [Utils jsonStringWithString:[object stringValue]];
        return value;
    }

    if (![NSJSONSerialization isValidJSONObject:object])
    {
        return nil;
    }

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    NSString *jsonStr = nil;

    if( data == nil || error != nil )
    {
        NSLog(@"%s Json parse error:%@",__FUNCTION__,error);
    }
    else
    {
        jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }

    return jsonStr;

}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{

    return [self jsonStringWithObject:dictionary];

}

#pragma mark - jsonStr to Dic or array
+ (NSDictionary *)dictionaryFromJsonStr:(NSString *)jsonStr{
    if (!jsonStr || [jsonStr isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return dic;
}

+ (NSArray *)arrayFromJsonStr:(NSString *)jsonStr{
    if (!jsonStr
        || [jsonStr isKindOfClass:[NSNull class]]
        || [NSJSONSerialization isValidJSONObject:jsonStr]) {
        return nil;
    }
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    return array;
}

#pragma mark - create folder
+ (void)createUserInfoFolder{
    if (![Utils getMyId]) {
        return;
    }
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [pathArray objectAtIndex:0];
    NSString *filepath=[path stringByAppendingPathComponent:[Utils getMyId]];//添加我们需要的文件夹全称
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filepath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - remove all loc data
+ (void)removeAllLocationData{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =  [pathArray objectAtIndex:0];
    NSString *filepath= path;//[path stringByAppendingPathComponent:[Utils getMyId]];//添加我们需要的文件夹全称
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:filepath isDirectory:&isDir];
    if (existed) {
        [fileManager removeItemAtPath:filepath error:nil];//移除document里所有文件，document也会被移除
        [fileManager createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];//因为document也会被移除，故重建document文件夹
    }
}

#pragma mark - unit in notice details
+ (NSString *)stringFromTimestamp:(NSTimeInterval)time{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;

}

+ (NSString *)stringFromTimestampOfMDHM:(NSTimeInterval)time{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}


+ (NSString *)stringFromTimestamp:(NSTimeInterval)time withFormat:(NSString *)format
{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

/**
 *  检查字典里是有value为null的对象
 *
 *  @param aDic 目标字典
 *
 *  @return 处理后字典
 */
+ (NSDictionary *)setDicValueFromNullToString:(NSDictionary *)aDic{
    //若不为字典，则回传一个空字典，避免dictionaryWithDictionary崩溃
    if (![aDic isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionary];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:aDic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (!obj || [obj isKindOfClass:[NSNull class]]) {
            [dic setObject:@"" forKey:key];
        }
    }];
    return [NSDictionary dictionaryWithDictionary:dic];

}

/**
 *  根据时间返回显示
 *  @param aStr 20120908
 *  @return yyyy/MM/DD
 */
+ (NSString *)getTimeYYYY_MM_DDWith:(NSString *)aStr{

    NSString *dateStr = @"";
    if (aStr && aStr.length==8) {
        NSString *year = [aStr substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [aStr substringWithRange:NSMakeRange(4, 2)];
        NSString *date = [aStr substringWithRange:NSMakeRange(6, 2)];
        dateStr = [NSString stringWithFormat:@"%@/%@/%@",year,month,date];
    }
    return dateStr;

}
+ (NSString *)getTimeYYYYMMDDWith:(NSTimeInterval)time{

    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}


/**
 *  选择时间段显示
 *
 *  @param aStr 时间戳
 *
 *  @return 处理后的需要显示的时间
 */
+ (NSString *)getChooseTimeShowWithTimeInterval:(NSTimeInterval)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}


//判断两个date间隔是否在maxInterval内
+ (BOOL)isTimeSpaceInMaxInterval:(NSInteger)maxInterval date0:(NSDate *)d0 date1:(NSDate *)d1{
    if (!d0 || !d1) {
        return NO;
    }
    NSTimeInterval aTimer = [d1 timeIntervalSinceDate:d0];
    if (aTimer > maxInterval || aTimer < -maxInterval) {
        return NO;
    }
    return YES;
}

/**
 *  格式化日利率
 */
+ (NSString *)formatdateRate:(NSString *)originStr{
    NSString *result = @"";
    if (originStr) {
        double num = [originStr doubleValue];
        num = num*100;
        NSString *temp = [NSString stringWithFormat:@"%f",num];
        while ([temp characterAtIndex:temp.length - 1] == '0') {
            temp = [temp substringToIndex:temp.length - 1];
        }
        if ([temp characterAtIndex:temp.length - 1] == '.') {
            temp = [temp substringToIndex:temp.length - 1];
        }
        result = [temp stringByAppendingString:@"%"];
    }
    return result;
}

/**
 *  ETC 还款记录列表还款时间（具体）显示
 *
 *  @param aStr 时间戳
 *
 *  @return 处理后的需要显示的时间
 */
+ (NSString *)getRepayTimeWithStr:(NSString *)aStr{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[aStr doubleValue]];
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm    MM/dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}



+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment
{

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    return label;

}

+ (NSString *)stringFromDateWithFormat:(NSString *)format date:(NSDate *)date
{
    if( date != nil )
    {
        NSDateFormatter *formater =[[NSDateFormatter alloc] init];
        [formater setDateFormat:format];

        return [formater stringFromDate:date];
    }
    else
    {
        return nil;
    }
}

//dateStr format: @"yyyy-MM"
+ (NSArray *)monthBeginAndEndWith:(NSString *)dateStr{

    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setFirstWeekday:1];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
        return @[beginDate,endDate];
    }else {
        return nil;
    }
}

+ (NSArray *)etcBeginDate
{
    return @[@(2015),@(1)];
}

//如果date比etcBeginDate早，那么返回etcBeginDate。否则，反正date
+ (NSArray *)currentETCYearAndMonth:(NSDate *)date
{
    NSArray *etcBegin = [Utils etcBeginDate];

    NSInteger minYear = [etcBegin[0] integerValue];
    NSInteger minMonth = [etcBegin[1] integerValue];

    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearStr = [formatter stringFromDate:date];
    NSInteger yearNum = [yearStr integerValue];

    [formatter setDateFormat:@"MM"];
    NSString *monthStr = [formatter stringFromDate:date];
    NSInteger monthNum = [monthStr integerValue];

    if( yearNum < minYear || (yearNum == minYear && monthNum < minMonth) )
    {
        yearNum = minYear;
        monthNum = minMonth;
    }

    return @[@(yearNum),@(monthNum)];
}

+ (NSInteger)currentYear:(NSDate *)date
{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];

    NSString *dateStr = [formatter stringFromDate:date];
    return [dateStr integerValue];
}

+ (NSInteger)currentMonth:(NSDate *)date
{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];

    NSString *dateStr = [formatter stringFromDate:date];
    return [dateStr integerValue];
}

#pragma mark - sort
/*
 @param dicArray：待排序的NSMutableArray。
 @param key：按照排序的key。
 @param yesOrNo：升序或降序排列，yes为升序，no为降序。
 */
+ (void) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                       ascending:yesOrNo];

    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    [dicArray sortUsingDescriptors:descriptors];//@"127.0.0.1"
}

#pragma mark ip
+ (NSString *)getIPAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);

    //lxf
    if (!address) {
        address = @"127.0.0.1";
    }
    return address;
}


/**
 * 为账号信息格式化加星隐藏
 * @param originCarNoString 原始账号信息
 */
+ (NSString *)formatCarNoSecurityWithOriginString:(NSString *)originCarNoString{
    NSString *resultAccountStr = originCarNoString;
    if (originCarNoString && originCarNoString.length>8) {
        NSString *suffixStr = [originCarNoString substringFromIndex:originCarNoString.length-4];
        suffixStr = [NSString stringWithFormat:@"****%@",suffixStr];
        NSString *prefixStr = @"";
        prefixStr = [originCarNoString substringToIndex:4];
        resultAccountStr = [NSString stringWithFormat:@"%@%@",prefixStr,suffixStr];
    }
    return resultAccountStr;
}


/**
 拨打电话

 @param phoneNum 电话号码
 @param view 提示框显示在view上
 */
+ (void)callPhone:(NSString *)phoneNum InView:(UIView *)view
{
    NSUInteger tag = NSUIntegerMax - 111;
    UIWebView *webView = [view viewWithTag:tag];
    if( !webView )
    {
        webView = [[UIWebView alloc] init];
        webView.tag = tag;
        [view addSubview:webView];
    }
    else if( ![webView isKindOfClass:[UIWebView class]] )
    {
        //如果真的连这种tag都能巧合，那么不管泄露的问题，直接alloc再显示。
        webView = [[UIWebView alloc] init];
        [view addSubview:webView];
    }

    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    [webView loadRequest:[NSURLRequest requestWithURL:telURL]];
}

#pragma mark - error


/**
 *  app启动时调用此方法，以便能够正确调用[[NSURLCache sharedURLCache] removeAllCachedResponses]
 */
+ (void)setShareCache{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}



+ (NSString*)documentsPathWithFileName:(NSString*)aFileName
{
    aFileName=aFileName?:@"";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:aFileName];
}

+ (BOOL)fileExists:(NSString*)aFilePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:aFilePath];
}

+ (void)deletePersistentAccounts
{
    NSString* path=[self documentsPathWithFileName:@"accounts.dic"];

    if([self fileExists:path])
    {
        [self deleteFileWithPath:path];
    }
}

+ (BOOL)deleteFileWithPath:(NSString*)aFilePath
{
    BOOL ret=YES;
    NSFileManager *fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:aFilePath])
    {
        ret=[fm removeItemAtPath:aFilePath error:nil];
    }
    return ret;
}

#pragma mark alertView
+ (void)showAlertView:(UIViewController *)superVC title:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelTitle{
    if(iOSVersionGreaterThanOrEqualTo(@"8.0.0")){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:msgStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];

        [alertVC addAction:defaultAction];
        [superVC presentViewController:alertVC animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleStr
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:cancelTitle
                                                 otherButtonTitles:nil, nil];
        [alertView show];
    }
}

+ (NSString *)decimalNumberDividingWithNSInteger:(long long int)dividend byFloat:(CGFloat)divisor
{
    NSDecimalNumber *dividendNumber = [[NSDecimalNumber alloc]initWithLongLong:dividend];

    NSDecimalNumber *divisorNumber = [[NSDecimalNumber alloc]initWithFloat:divisor];

    NSDecimalNumber *quotientNumber = [dividendNumber decimalNumberByDividingBy:divisorNumber];

    NSString *decimalString = nil;

    if (dividend % 100 == 0)
    {
        decimalString = [NSString stringWithFormat:@"%@.00",quotientNumber.stringValue];

    }else if (dividend % 10 == 0)
    {
        decimalString = [NSString stringWithFormat:@"%@0",quotientNumber.stringValue];

    }else if (dividend == 0)
    {
        decimalString = @"0.00";
    }
    else
    {
        decimalString = quotientNumber.stringValue;
    }

    return decimalString;

}
+(NSString *)substringToInputLength:(NSString *)dataString Length:(NSInteger) length{
    NSString *result  = dataString;
    if (result  != nil && result.length>length && length >0 && result.length > length) {
        result = [dataString substringToIndex:length];
    }
    return result;
}

+(NSInteger)getTommorowAllDay{
    NSDate *current = [[NSDate alloc]init];
    NSTimeInterval interval = [current timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    NSInteger allDays = interval / daySeconds+1;
    return allDays;
}

+(NSString *) hideCardNoMiddleString :(NSString *) carNumStr{
    NSString *aCardNumStr = nil;
    if (carNumStr.length >8) {
        NSString *first = [carNumStr substringToIndex:4];
        NSString *last = [carNumStr substringFromIndex:carNumStr.length-4];
        aCardNumStr = [NSString stringWithFormat:@"%@ * %@",first,last];
    }
    else{
        aCardNumStr = [NSString stringWithFormat:@"%@",carNumStr];
    }

    return  aCardNumStr;
}

#pragma mark
#pragma mark 参数校验
+ (NSString *)generateCheckCodeWithDictonary:(NSDictionary *)parameterDic
{
    NSArray *keys = [parameterDic allKeys];

    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){

        return [obj1 compare:obj2 options:NSNumericSearch];

    }];

    NSString *signString = nil;

    if (keys.count > 0)
    {
        signString = @"";
    }

    for (NSString *key in sortedArray)
    {
        signString = [signString stringByAppendingFormat:@"%@",[parameterDic objectForKey:key]];

    }

    return signString;
}
/**
 *  获取string值
 */
+ (NSString *)getStringValueFrom:(id)obj{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj stringValue];
    }
    else if([obj isKindOfClass:[NSString class]]){
        return obj;
    }
    else
        return nil;
}

#pragma mark - 隔天
//入参date距离现在时间是否早于1天
//举例：入参date为5月1日23:59,现在时间5月2日00:01, 那么结果返回YES
+ (BOOL)oneDayEarlierThanNow:(NSDate *)date
{
    BOOL result = NO;

    NSString *day = [Utils stringFromDateWithFormat:@"dd" date:date];
    NSDate *currentDate = [NSDate date];
    NSString *currentDay = [Utils stringFromDateWithFormat:@"dd" date:currentDate];

    //比现在时间早
    if( date != nil && [date timeIntervalSinceDate:currentDate] < 0 )
    {
        //天数不相等，一定相差了一天
        if( [day integerValue] != [currentDay integerValue] )
        {
            result = YES;
        }
        else
        {
            //一天的秒数
            NSTimeInterval oneDayInterval = 60*60*24;

            //天数相等，可能为3月3日和5月3日比较，也可能是3月3日和3月3日。此时比较时间差是否大于1天
            if( [currentDate timeIntervalSinceDate:date] > oneDayInterval )
            {
                result = YES;
            }
        }
    }

    return  result;
}
/**
 *  获取定制的button
 *
 *  @param aType btn类型
 *  @param title title
 *  @param img   image
 *
 *  @return 定制化的button
 */
+ (UIButton*)createButtonWith:(CustomButtonType)aType text:(NSString *)title img:(UIImage *)img{
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (aType == CustomButtonType_Back) {
        UIImage *img = [UIImage imageNamed:@"topbar_icon_back"];
        aBtn.frame = CGRectMake(0, 0, 30, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [aBtn setImage:img forState:UIControlStateNormal];
        //aBtn.backgroundColor = [UIColor redColor];
    }
    else if(aType == CustomButtonType_Text){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.]];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat width =[Utils widthOfText:title theHeight:30 theFont:aBtn.titleLabel.font];
        if (width<50) {
            width= 50;
        }
        aBtn.frame = CGRectMake(0, 0, width, 30);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
    else if (aType == CustomButtonType_Img){
        CGSize imgSize = img.size;
        [aBtn setImage:img forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, imgSize.width, imgSize.height);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
    }
    return aBtn;
}
+ (NSArray *) getUnRepetitiveArray:(NSArray *)array{
    
    NSArray *newArr = [array valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    return newArr;
}

+ (UIImage *)captureImgWithView:(UIView *)view{

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)cl_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
