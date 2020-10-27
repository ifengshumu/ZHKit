//
//  NSString+DDAdd.h
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DDAdd)


/**
获取Documents目录

 @return 返回Documents路径
 */
+ (NSString *)documentPath;


/**
 获取Cache目录

 @return 返回Cache路径
 */
+ (NSString *)cachePath;

/**
 电话号码中间4位*显示
 
 @param phoneNum 电话号码
 @return 135****1262
 */
+ (NSString *)getSecrectStringWithPhoneNumber:(NSString*)phoneNum;


/**
 电话号码3-4-4分隔
 */
+ (NSString*)separatePhoneNumber:(NSString*)phoneNum;

/**
 删除空格

 @return string
 */
- (NSString *)deleteBlankSpace;


/**
 判断是否是有效的电话号码

 @return bool
 */
- (BOOL)isValidMobileNumber;


/**
 是否是有效的邮箱

 @return bool
 */
- (BOOL)isValidEmail;

/**
 是否是有效的密码（长度8-16位，至少包含字母、数字、符号的其中两种）
*/
- (BOOL)isValidPassword;

/**
 检测15位有效身份证

 @return bool
 */
- (BOOL)isValidIdentifyFifteen;


/**
 检测18位有效身份证

 @return bool
 */
- (BOOL)isValidIdentifyEighteen;

/**
 是否是英文
*/
- (BOOL)isEnglish;

/**
 是否是中文
*/
- (BOOL)isChinses;

/**
 是否合格姓名（包含中文姓名和英文姓名）
*/
- (BOOL)isValidName;

/**
 MD5 加密

 @return 返回加密后的字符串
 */
- (NSString *)md5WithString;


/**
 通过时间戳和格式获取时间

 @param timestamp 时间戳
 @param formatter 格式
 @return time
 */
+ (NSString *)getStringWithTimestamp:(NSTimeInterval)timestamp formatter:(NSString*)formatter;


/**
 计算字体size
 */
- (CGSize)boundingSizeWithFont:(UIFont *)font size:(CGSize)size;

/**
 银行名称，卡号尾号4位格式化，eg：工商银行 尾号0888
 */
+ (NSString *)formatterTailBankName:(NSString *)bankName bankCardNo:(NSString *)bankCardNo;

/**
 银行名称，种类、卡号尾号4位格式化，eg：工商银行 储蓄卡（0888）
 */
+ (NSString *)formatterKindBankName:(NSString *)bankName bankCardNo:(NSString *)bankCardNo;

/**
 判断是否是空字符串
 */
+ (BOOL)isEmpty:(nullable NSString *)string;

/**
 编码字符串
 */
+ (NSString *)encodeString:(NSString *)string withCharacters:(NSString *)characters;

/**
 编码字符串
 */
+ (NSString *)encodedURL:(NSString *)string;

/**
 解码字符串
 */
+ (NSString *)decodedURL:(NSString *)string;

/**
 移除字符串
 */
+ (NSString *)removeCharactersForString:(NSString *)string;

/**
 移除字符串
 */
+ (NSString *)removeCharacters:(NSString *)character forString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
