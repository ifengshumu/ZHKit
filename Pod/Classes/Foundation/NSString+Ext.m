//
//  NSString+Ext.m
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "NSString+Ext.h"
#import <CoreText/CoreText.h>
#import "CCLocationManager.h"


@implementation NSString (Ext)

// 获取字符串宽度
+ (float)getStrwidth:(NSString *)aTip height:(CGFloat)aHeight font:(UIFont *)aFont
{
    return [aTip boundingRectWithSize:CGSizeMake(LONG_MAX, aHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:aFont forKey:NSFontAttributeName] context:nil].size.width;
}

// 获取字符串高度
+ (float)getStrHeight:(NSString *)aTip width:(CGFloat)aWidth font:(UIFont *)aFont
{
    return  [aTip boundingRectWithSize:CGSizeMake(aWidth, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:aFont forKey:NSFontAttributeName] context:nil].size.height;
}

// 得到带首行缩进字符串的高度
+ (float)getStrAttHeight:(NSString *)aTip width:(CGFloat)aWidth font:(UIFont *)aFont isHideRow:(BOOL)isHideRow indent:(CGFloat)indent lineSpace:(CGFloat)lineSpace
{
    if(!aTip)
    {
        return 0.0f;
    }
    if (isHideRow)
    {
        // 去掉空行
        aTip = [aTip stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    [paragraphStyle setHeadIndent:indent];
    NSDictionary *dic = @{NSFontAttributeName:aFont, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [aTip boundingRectWithSize:CGSizeMake(aWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}

// 设置行间距和首行缩进
+ (NSMutableAttributedString *)getAttrString:(NSString *)aTip font:(UIFont *)aFont isHideRow:(BOOL)isHideRow indent:(CGFloat)indent lineSpace:(CGFloat)lineSpace
{
    if(!aTip)
    {
        return nil;
    }
    if (isHideRow)
    {
        // 去掉空行
        aTip = [aTip stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    paragraphStyle.hyphenationFactor = 1.0;
    paragraphStyle.firstLineHeadIndent = 0.0;
    paragraphStyle.paragraphSpacingBefore = 0.0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    [paragraphStyle setHeadIndent:indent];
    NSDictionary *dic = @{NSFontAttributeName:aFont, NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:aTip attributes:dic];
    return attributeStr;
}



//  通过时间戳计算距离现在多久
+ (NSString *)nowTime:(NSString *)str
{
    NSInteger aaa = [str integerValue];
    NSDate *sss = [NSDate dateWithTimeIntervalSince1970:aaa];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeStr = [formatter1 stringFromDate:sss];
    
//    //    NSLog(@"123--%@",timeStr);
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy MM dd HH:mm:ss"];
//    [formatter setLocale:[NSLocale currentLocale]];
//    NSDate *date = [formatter dateFromString:timeStr];
//    NSString *dateStr = [date prettyDateWithReference:[NSDate date]];
    
    return timeStr;
}


//  得到当前时间戳
+ (NSString *)getNowTimeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f",a];
    
    return timeString;
}

//  得到当前日期
+ (NSString *)getNowTime
{
    NSDate *sss = [NSDate date];
    NSDateFormatter *formatter1=[[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [formatter1 stringFromDate:sss];
    
    return timeStr;
}



//  判断是否超过有效期
+ (BOOL)isoverWithDate:(NSString *)dateStr
{
    //  日期格式化器 指定日期的转化格式
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //  把字符串转化为日期
    NSDate *endDate = [formatter dateFromString:dateStr];
    NSDate *nowDate = [NSDate date];
    
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
    
    if (endTime > nowTime)
    {
        return NO;
    }
    return YES;
}


//  省份市区  去掉最后的省和市的字眼
- (NSString *)setProvinceAndCity
{
    NSString *subStr = [self substringToIndex:self.length-1];
    return subStr;
}


//  同时含有数字和字母的判断
- (int)checkIsHaveNumAndLetter
{
    // 数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, self.length)];
    // 英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // 符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    if (tNumMatchCount == self.length)
    {
        // 全部符合数字，表示沒有英文
        return 1;
    }else if (tLetterMatchCount == self.length)
    {
        // 全部符合英文，表示沒有数字
        return 2;
    }else if (tNumMatchCount + tLetterMatchCount == self.length)
    {
        // 符合英文和符合数字条件的相加等于密码长度
        return 3;
    }else
    {
        // 可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
        return 4;
    }
}


// 计算self这个文件夹\文件的大小
- (unsigned long long)lx_fileSize
{
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 文件类型
    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
    NSString *fileType = attrs.fileType;
    
    // 文件夹
    if ([fileType isEqualToString:NSFileTypeDirectory])
    {
        // 获得文件夹的遍历器
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        
        // 总大小
        unsigned long long fileSize = 0;
        
        // 遍历所有子路径
        for (NSString *subpath in enumerator)
        {
            // 获得子路径的全路径
            NSString *fullSubpath = [self stringByAppendingPathComponent:subpath];
            fileSize += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
        return fileSize;
    }
    // 文件
    return attrs.fileSize;
}

//  生成缓存目录全路径
- (instancetype)cacheDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}

//  生成文档目录全路径
- (instancetype)docDir
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}

//  生成临时目录全路径
- (instancetype)tmpDir
{
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:[self lastPathComponent]];
}


//  判断字符串中是否有中文
- (BOOL)isHaveChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

//  取本地json数据
+ (NSArray *)loadFileFromeBundle:(NSString *)documentTitle
{
    NSDictionary *dataResources = [NSDictionary dictionary];
    NSString *pathBundle = [[NSBundle mainBundle] pathForResource:documentTitle ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:pathBundle];
    dataResources = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [dataResources objectForKey:@"data"];
}

//  计算两个经纬度之间的距离
+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2
{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}

+ (NSArray *)checkAllTelArr:(NSString *)string
{
    // 获取字符串中的电话号码
    NSString *regulaStr = @"(\\d{3,4}[- ]?\\d{7,8})|(\\d{7,8})";
//    NSString *regulaStr = @"^(0\\d{2}-\\d{8}(-\\d{1,4})?)|(0\\d{3}-\\d{7,8}(-\\d{1,4})?)$";
    NSRange stringRange = NSMakeRange(0, string.length);
    // 正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    NSMutableArray *telArr = [NSMutableArray array];
    if (!error && regexps != nil)
    {
        [regexps enumerateMatchesInString:string options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            NSRange phoneRange = result.range;
            NSString *phoneNumber = [string substringWithRange:phoneRange];
            [telArr addObject:phoneNumber];
        }];
    }
    return telArr;
}

@end
