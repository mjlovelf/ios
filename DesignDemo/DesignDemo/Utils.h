//
//  Utils.h
//  CWTMExpressCourier

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "JSONModel.h"
#import "SDiPhoneVersion.h"
#import "Global.h"

#define IS_IPHONE4  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE5  ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

static NSString *iconImgName_Normal = @"list_icon_%@_nor";
static NSString *iconImgName_Disable = @"list_icon_%@_disable";

static NSInteger PWD_MIN_INPUT_LENGTH = 7;

@interface Utils : NSObject

/**
 *  登录后，设置用户信息
 *
 *  @param userInfoDict 接口返回的user层数据
 */
+ (void)setUserInfo:(NSDictionary *)userInfoDict;
/**
 *  获取我的id
 */
+ (NSString *)getMyId;

/**
 *  获取我的orgCode
 */
+ (NSString *)getMyOrgCode;

/**
 *  save bindMobild bool value
 */
+ (void)saveIsBindMobile:(NSString *)isBindStr;

/**
 *  get bindMobild bool value
 */
+ (NSString *)getIsBindMobile;

/**
 *  获取我的Username
 */
+ (NSString *)getMyUsername;

/**
 *  获取当前登录帐号的密码
 */
+ (NSString *)getMyPassword;

/**
 *  设置token到cookie。
 *
 *  @param token token的值。cookie的name是"token"。
 *  @param domain cookie所在的domain。
 */
+ (void)setCookieWithDomain:(NSString *)domain token:(NSString *)token;

/**
 *  清除指定domain下的cookie
 *
 *  @param domain domain
 */
+ (void)clearCookieValue:(NSString *)domain;

/**
 *  清除所有cookie
 */
+ (void)removeAllCookies;

/**
 *  获取我的Token
 */
+ (void)saveMyToken:(id)tokenObj;

/**
 *  获取我的Token
 */
+ (NSString *)getMyToken;

/**
 *  设置银行账户用户信息
 */
+ (void)setBankUserInfo:(id)dic;

/**
 *  获取银行账户用户信息
 *  nsdictionary 内包含的键值对分别为:
 name		登陆名
 contact	联系人
 mobile		电话号码
 email		邮箱地址
 orgname	车老板APP	所属机构
 idcard		身份证号码
 */
+ (NSDictionary *)getBankUserInfo;

/**
 *  将字符串进行md5加密
 */
+ (NSString *)md5:(NSString *)aStr;
+ (NSString *)md5ForGetData:(NSString *)aStr;

//微众支付应用级参数sign生成规则时使用
+ (NSString *)md5:(NSString *)aStr withStartKey:(NSString *)startKey withEndKey:(NSString *)endKey;

/**
 *  获取字符串高度
 *
 *  @param text  字符串
 *  @param width 字符串固定最大宽度
 *  @param aFont font
 *
 *  @return 高度
 */
+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont;

/**
 *  获取字符串宽带
 *
 *  @param text   字符串
 *  @param height 字符串固定最大高度
 *  @param aFont  font
 *
 *  @return 宽度
 */
+ (CGFloat)widthOfText:(NSString *)text theHeight:(float)height theFont:(UIFont*)aFont ;

/**
 *  拉升图片
 *
 *  @param oriImg 原图
 *
 *  @return 处理后的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)oriImg;

/**
 *  获取16进制转化后的UIColor对象
 *
 *  @param stringToConvert 16进制颜色值
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert alpha:(CGFloat)alphaNum;


/**
 *  根据keyStr查找Colors.plist返回color
 *
 *  @param keyStr 颜色编号，如C1
 *
 *  @return UIColor obj
 */
+ (UIColor *)getColorWithKeyString:(NSString *)keyStr;

/**
 *  根据keyStr查找FontSize.plist返回UIFont
 *
 *  @param keyStr 字体大小编号，如A1
 *
 *  @return UIFont obj
 */
+ (UIFont *)getBoldFontWithKeyString:(NSString *)keyStr;


/**
 *  根据keyStr查找FontSize.plist返回UIFont
 *
 *  @param keyStr 字体大小编号，如A1
 *
 *  @return UIFont obj
 */
+ (UIFont *)getFontWithKeyString:(NSString *)keyStr;


/**
 *  处理View为圆角带边框
 *
 *  @param aView  目标view
 *  @param aR     半径
 *  @param aB     边框宽度
 *  @param aColor 边框颜色
 */
+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor;

/**
 *  设置UINavigationBar
 *
 *  @param navBar UINavigationBar对象
 */
+ (void)setNavBarBgUI:(UINavigationBar*)navBar;

/**
 *  设置两行title
 *
 */
+(void)setNavBarTitleText:(UINavigationItem*)navItem str0:(NSString *)str0 str1:(NSString *)str1;


/**
 *  获取已读的颜色
 *
 *  @return 已读的颜色
 */
+ (UIColor *)getColorOfDoRead;

/**
 *  获取关注的颜色
 *
 *  @return 关注的颜色
 */
+ (UIColor *)getColorOfFollow;

/**
 *  获取一个含 key ＝ Token，value ＝ Token值的字典
 *
 *  @return 字典
 */
+ (NSMutableDictionary *)getDicContainToken;

+ (NSString *)stringFromTimestamp:(NSTimeInterval)time;
+ (NSString *)stringFromTimestamp:(NSTimeInterval)time withFormat:(NSString *)format;

/**
 *  检查字典里是有value为null的对象
 *
 *  @param aDic 目标字典
 *
 *  @return 处理后字典
 */
+ (NSDictionary *)setDicValueFromNullToString:(NSDictionary *)aDic;

/**
 *  根据时间戳返回显示
 *  @param aStr 20120908
 *  @return YYYY/MM/DD
 */
+ (NSString *)getTimeYYYY_MM_DDWith:(NSString *)aStr;

/**
 *  格式化日利率
 */
+ (NSString *)formatdateRate:(NSString *)originStr;

//当前网络是否可用
+ (BOOL)currentNetworkReachable;

/**
 *  根据时间戳返回显示
 *
 *  @param aStr 时间戳str
 *
 *  @return 处理后str
 */
+ (NSString *)getTimeWithStr:(NSString *)aStr;

/**
 *  根据时间戳返回显示, 今天显示14:20格式；昨天；根据传入format格式显示其它时间
 *
 *  @param aStr 时间戳str
 *  @param formatString 时间格式
 *  @return 处理后str
 */
+ (NSString *)getTimeWithStr:(NSString *)aStr formatString:(NSString *)formatString;

//根据两个date，获取其间隔时间用于显示
+ (NSString *)getTimeSpaceShowWithDate0:(NSDate *)d0 date1:(NSDate *)d1;

//判断两个date间隔是否在maxInterval内
+ (BOOL)isTimeSpaceInMaxInterval:(NSInteger)maxInterval date0:(NSDate *)d0 date1:(NSDate *)d1;

/**
 *  ETC 还款记录列表还款时间（具体）显示
 *
 *  @param aStr 时间戳
 *
 *  @return 处理后的需要显示的时间
 */
+ (NSString *)getRepayTimeWithStr:(NSString *)aStr;

/**
 *  选择时间段显示
 *
 *  @param time 时间戳
 *
 *  @return 处理后的需要显示的时间
 */
+ (NSString *)getChooseTimeShowWithTimeInterval:(NSTimeInterval)time;

/**
 *   选择时间段显示，根据传入的formatstring要求来格式化
 *
 *  @param time         时间
 *  @param formatString 格式化标准string
 *
 *  @return 符合formatstring格式的字串
 */
+ (NSString *)getChooseTimeShowWithTimeInterval:(NSTimeInterval)time formatString:(NSString *)formatString;
/**
 *  ETC 还款记录列表还款时间（年月）显示
 *
 *  @param aStr 时间戳
 *
 *  @return 处理后的需要显示的时间
 */
+ (NSString *)getRepayTimeOfYearAndMounthWithStr:(NSString *)aStr;


#pragma mark - jsonStr from obj
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

#pragma mark - jsonStr to Dic or array
+ (NSDictionary *)dictionaryFromJsonStr:(NSString *)jsonStr;
+ (NSArray *)arrayFromJsonStr:(NSString *)jsonStr;

#pragma mark - save and get native data
+ (void)createUserInfoFolder;


#pragma mark - remove all loc data
+ (void)removeAllLocationData;

#pragma mark - label
/**
 *  创建label
 *
 *  @param frame         frame
 *  @param title         title
 *  @param font          font
 *  @param color         color
 *  @param bgColor       bgColor
 *  @param textAlignment 对齐方式
 *
 *  @return return UILabel Object
 */
+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment;

/*
 * 获取某年某月的第一天和最后一天。
 *
 * @param dateStr：某年某月，格式：@"yyyy-MM"
 *
 * @return 数组第一个元素为第一天，第二个元素为最后一天。返回值可以为nil。
 */
+ (NSArray *)monthBeginAndEndWith:(NSString *)dateStr;

/*
 * 按照格式返回date string。
 *
 * @param format：时间格式串
 * @param date：时间
 *
 * @return 格式化后的字符串
 */
+ (NSString *)stringFromDateWithFormat:(NSString *)format date:(NSDate *)date;

/*
 * 获取ETC数据初始时间
 *
 * @return [2015,01]
 */
+ (NSArray *)etcBeginDate;

/*
 * 获取当前年和月(最早时间点返回ETC数据初始时间201501)。
 *
 * @param date：时间戳
 *
 * @return [2015,12]
 */
+ (NSArray *)currentETCYearAndMonth:(NSDate *)date;

/*
 * 获取当前年。
 *
 * @param date：时间戳
 *
 * @return 年份。
 */
+ (NSInteger)currentYear:(NSDate *)date;

/*
 * 获取当前月。
 *
 * @param date：时间戳
 *
 * @return 月份。
 */
+ (NSInteger)currentMonth:(NSDate *)date;

#pragma mark - sort
/*
 @param dicArray：待排序的NSMutableArray。
 @param key：按照排序的key。
 @param yesOrNo：升序或降序排列，yes为升序，no为降序。
 */
+ (void) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;

#pragma mark - ip
/*
 获取设备ip地址
 */
+ (NSString *)getIPAddress ;
/**
 * 为账号信息格式化加星隐藏
 * @param originCarNoString 原始账号信息
 */
+ (NSString *)formatCarNoSecurityWithOriginString:(NSString *)originCarNoString;


/**
 拨打电话

 @param phoneNum 电话号码
 @param view 提示框显示在view上
 */
+ (void)callPhone:(NSString *)phoneNum InView:(UIView *)view;

#pragma mark - error

/**
 *  app启动时调用此方法，以便能够正确调用[[NSURLCache sharedURLCache] removeAllCachedResponses]
 */
+ (void)setShareCache;


/**
 *  获取文件的路径
 *  @param aFileName         文件名字
 *  @return 文件路径
 */
+ (NSString*)documentsPathWithFileName:(NSString*)aFileName;

//判断文件是否存在
+ (BOOL)fileExists:(NSString*)aFilePath;

//根据文件名字删除文件
+ (BOOL)deleteFileWithPath:(NSString*)aFilePath;

//删除本地缓存的帐号信息
+ (void)deletePersistentAccounts;

//根据用户名字获取单个帐号信息
+ (NSDictionary *)loadOneAccountWithUserName:(NSString *)userName;

//所有保存的用户信息
+ (NSArray*)loadAllAccounts;

//根据名字删除帐号
+ (void)deleteAccountWithUserName:(NSString *)userName;

#pragma mark alertView
+ (void)showAlertView:(UIViewController *)superVC title:(NSString *)titleStr msg:(NSString *)msgStr cancel:(NSString *)cancelTitle;


/**
 *  创建保存或更新保存的帐号信息
 *  @param dividend NSInteger类型的被除数
 *  @param divisor  CGFloat类型的除数
 *  @return 商的字符串类型
 */
+ (NSString *)decimalNumberDividingWithNSInteger:(long long int)dividend byFloat:(CGFloat)divisor;
/**
 *将datastring按照length截取，如果datastring小于length则返回原字串
 */
+(NSString *)substringToInputLength:(NSString *)dataString Length:(NSInteger) length;
/**
 *获取手机时间明天整点的天数
 **/
+(NSInteger)getTommorowAllDay;

/**
 *格式化卡号，如果大于8位则隐藏中间返回（1234*4567）类型
 *如果小于8位则返回完整string
 **/
+(NSString *) hideCardNoMiddleString :(NSString *) carNumStr;

/**
 *  所有接口均要求做参数校验，校验规则是将所有传递到接口的参数按照key进行正向排序，然后与appkey字符串拼接进行md5加密，加密得到的字符串作为code参数传递给接口
 *
 *  @param parameterDic 需要生成checkcode的参数
 *
 *  @return 根据key生序生成的checkcode
 */
+ (NSString *)generateCheckCodeWithDictonary:(NSDictionary *)parameterDic;
/**
 *  获取string值
 */
+ (NSString *)getStringValueFrom:(id)obj;

+ (BOOL)oneDayEarlierThanNow:(NSDate *)date;

//获取当前系统版本，前面带有V
+ (NSString *)getCurrentAppVersionWithV;

+ (UIButton*)createButtonWith:(CustomButtonType)aType text:(NSString *)title img:(UIImage *)img;

/**
 去掉数组中重复数据

 @param array 有重复数据的数组
 @return 无重复数据的数组
 */
+ (NSArray *) getUnRepetitiveArray:(NSArray *)array;


/**
 对view进行截图

 @param view 传入view
 @return 图片
 */
+ (UIImage *)captureImgWithView:(UIView *)view;

/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
+ (UIImage *)cl_imageWithColor:(UIColor *)color;
@end
