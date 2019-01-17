//
//  NSString+GetObj.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "NSString+GetObj.h"

#import "NSString+Judge.h"
#import "NSNumber+Format.h"

#import "PinYin4Objc.h"

@implementation NSString (GetObj)

+ (NSString *)getNumberFromString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    NSCharacterSet *nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [string stringByTrimmingCharactersInSet:nonDigits];
}

+ (NSString *)removeSubString:(NSString *)subString fromString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    if ([string containsString:subString]) {
        NSRange range = [string rangeOfString:subString];
        return  [string stringByReplacingCharactersInRange:range withString:@""];
    }
    return string;
}

+ (NSString *)removeInclusiveSpaceString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)removeExtraSpaceString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}

+ (NSString *)chineseLowercaseNumber:(long long)number {
    return [NSNumber stringFromNumber:@(number) withStyle:NSNumberFormatterSpellOutStyle];
}

+ (NSString *)chineseCapitalNumber:(long long)string {
    NSString *smallStr = [NSString chineseLowercaseNumber:string];
    NSMutableString *upStr = @"".mutableCopy;
    NSDictionary *dic = @{@"负":@"负",@"〇":@"零", @"一":@"壹", @"二":@"贰", @"三":@"叁", @"四":@"肆", @"五":@"伍", @"六":@"陆", @"七":@"柒", @"八":@"捌", @"九":@"玖", @"十":@"拾", @"百":@"佰", @"千":@"仟", @"万":@"万", @"亿":@"亿"};
    for (NSInteger i = 0; i < smallStr.length; i++) {
        NSString *s = [smallStr substringWithRange:NSMakeRange(i, 1)];
        NSString *S = dic[s];
        if (S == nil) {
            S = s;
        }
        [upStr appendString:S];
    }
    if ([upStr rangeOfString:@"点"].location != NSNotFound) {
        [upStr insertString:@"角" atIndex:[upStr rangeOfString:@"点"].location + 2];
        NSArray *arr = [upStr componentsSeparatedByString:@"点"];
        if (arr.lastObject != nil && ((NSString *)arr.lastObject).length > 2) {
            [upStr appendString:@"分"];
        }
    } else {
        [upStr appendString:@"元"];
    }
    upStr = [[upStr stringByReplacingOccurrencesOfString:@"点" withString:@"元"] mutableCopy];
    upStr = [[upStr stringByReplacingOccurrencesOfString:@"零角" withString:@""] mutableCopy];
    return upStr;
}

/*
 URLUserAllowedCharacterSet      "#%/:<>?@[\]^
 URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
 URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
 URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
 URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
 URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
 */
+ (NSString *)encodeString:(NSString *)string withCharacters:(NSString *)characters {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:characters] invertedSet]];
}

+ (NSString *)encodedURL:(NSString *)string {
    return [NSString encodeString:string withCharacters:@"<>^`!*'();:@&=+$,/?%#[\\]{|}"];
}

+ (NSString *)decodedURL:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    return [string stringByRemovingPercentEncoding];
}

+ (NSString *)removeCharactersForString:(NSString *)string {
    NSString *character = @"@／/:：;；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"<>《》¥“”";
    return [NSString removeCharacters:character forString:string];
}

+ (NSString *)removeCharacters:(NSString *)character forString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    if ([NSString isBlankString:character]) {
        return string;
    }
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:character] invertedSet];
    return [string stringByTrimmingCharactersInSet:set];
}

+ (NSString *)pinYin:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:string withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
    return outputPinyin;
}

+ (NSString *)firstWordUpperCaseChinese:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    NSString *pinyin = [[NSString pinYin:string] uppercaseString];
    return [pinyin substringToIndex:1];
}

+ (NSString *)allFirstWordUpperCaseChinese:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    NSMutableString *capStr = [NSMutableString string];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *chinese = [string substringWithRange:[string rangeOfComposedCharacterSequencesForRange:range]];
        NSString *firstElement = [NSString firstWordUpperCaseChinese:chinese];
        [capStr appendString:firstElement];
    }
    return capStr;
}

+ (NSString *)birthdayFromIDCard:(NSString *)idCard {
    if ([NSString isBlankString:idCard]) {
        return nil;
    }
    //年、月、日
    NSString *year = nil;
    NSString *month = nil;
    NSString *day = nil;
    //判断位数
    NSString *birthdayNumber = nil;
    if(idCard.length == 18) {
        //**从第6位开始 截取8个数,即出生年月日
        birthdayNumber = [idCard substringWithRange:NSMakeRange(6, 8)];
        year = [birthdayNumber substringWithRange:NSMakeRange(0, 4)];
        month = [birthdayNumber substringWithRange:NSMakeRange(4, 2)];;
        day = [birthdayNumber substringWithRange:NSMakeRange(6,2)];
    } else {
        /*
         130503 670401 001的含义; 前6位为省市县，出生日期为1967年4月1日，顺序号为001,最后一位数男为奇数，女为偶数。
         */
        //**从第6位开始 截取6个数,即出生年月日
        birthdayNumber = [idCard substringWithRange:NSMakeRange(6, 6)];
        year = [NSString stringWithFormat:@"19%@",[birthdayNumber substringWithRange:NSMakeRange(0, 2)]];
        month = [birthdayNumber substringWithRange:NSMakeRange(2, 2)];;
        day = [birthdayNumber substringWithRange:NSMakeRange(4,2)];
    }
    //拼接生日
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    return result;
}

+ (NSString *)genderFromIDCard:(NSString *)idCard {
    if ([NSString isBlankString:idCard]) {
        return nil;
    }
    //判断位数
    NSInteger sexLocation = 0;
    if (idCard.length == 18) {
        sexLocation = 16;
    } else {
        sexLocation = 14;
    }
    NSInteger sexInteger = [[idCard substringWithRange:NSMakeRange(sexLocation,1)] integerValue];
    if(sexInteger % 2 != 0) {
        return @"男";
    } else {
        return @"女";
    }
}

+ (NSString *)reverseString:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return nil;
    }
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [string length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[string substringWithRange:subStrRange]];
    }
    return reverseString;
}

+ (NSString *)MIMEType:(NSString *)string {
    if ([NSString isBlankString:string]) {
        return @"application/octet-stream";
    }
    return [NSString MIMETypeForExtension:[string pathExtension]];
}

+ (NSString *)MIMETypeForExtension:(NSString *)extension {
    if ([NSString isBlankString:extension]) {
        return @"application/octet-stream";
    }
    return [[self MIMEDictionary] valueForKey:[extension lowercaseString]];
}

+ (NSDictionary *)MIMEDictionary {
    NSDictionary * MIMEDict;
    // Lazy loads the MIME type dictionary.
    if (!MIMEDict) {
        
        MIMEDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    // Key      // Value
                    @"",        @"application/octet-stream",
                    @"323",     @"text/h323",
                    @"acx",     @"application/internet-property-stream",
                    @"ai",      @"application/postscript",
                    @"aif",     @"audio/x-aiff",
                    @"aifc",    @"audio/x-aiff",
                    @"aiff",    @"audio/x-aiff",
                    @"asf",     @"video/x-ms-asf",
                    @"asr",     @"video/x-ms-asf",
                    @"asx",     @"video/x-ms-asf",
                    @"au",      @"audio/basic",
                    @"avi",     @"video/x-msvideo",
                    @"axs",     @"application/olescript",
                    @"bas",     @"text/plain",
                    @"bcpio",   @"application/x-bcpio",
                    @"bin",     @"application/octet-stream",
                    @"bmp",     @"image/bmp",
                    @"c",       @"text/plain",
                    @"cat",     @"application/vnd.ms-pkiseccat",
                    @"cdf",     @"application/x-cdf",
                    @"cer",     @"application/x-x509-ca-cert",
                    @"class",   @"application/octet-stream",
                    @"clp",     @"application/x-msclip",
                    @"cmx",     @"image/x-cmx",
                    @"cod",     @"image/cis-cod",
                    @"cpio",    @"application/x-cpio",
                    @"crd",     @"application/x-mscardfile",
                    @"crl",     @"application/pkix-crl",
                    @"crt",     @"application/x-x509-ca-cert",
                    @"csh",     @"application/x-csh",
                    @"css",     @"text/css",
                    @"dcr",     @"application/x-director",
                    @"der",     @"application/x-x509-ca-cert",
                    @"dir",     @"application/x-director",
                    @"dll",     @"application/x-msdownload",
                    @"dms",     @"application/octet-stream",
                    @"doc",     @"application/msword",
                    @"docx",    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    @"dot",     @"application/msword",
                    @"dvi",     @"application/x-dvi",
                    @"dxr",     @"application/x-director",
                    @"eps",     @"application/postscript",
                    @"etx",     @"text/x-setext",
                    @"evy",     @"application/envoy",
                    @"exe",     @"application/octet-stream",
                    @"fif",     @"application/fractals",
                    @"flr",     @"x-world/x-vrml",
                    @"gif",     @"image/gif",
                    @"gtar",    @"application/x-gtar",
                    @"gz",      @"application/x-gzip",
                    @"h",       @"text/plain",
                    @"hdf",     @"application/x-hdf",
                    @"hlp",     @"application/winhlp",
                    @"hqx",     @"application/mac-binhex40",
                    @"hta",     @"application/hta",
                    @"htc",     @"text/x-component",
                    @"htm",     @"text/html",
                    @"html",    @"text/html",
                    @"htt",     @"text/webviewhtml",
                    @"ico",     @"image/x-icon",
                    @"ief",     @"image/ief",
                    @"iii",     @"application/x-iphone",
                    @"ins",     @"application/x-internet-signup",
                    @"isp",     @"application/x-internet-signup",
                    @"jfif",    @"image/pipeg",
                    @"jpe",     @"image/jpeg",
                    @"jpeg",    @"image/jpeg",
                    @"jpg",     @"image/jpeg",
                    @"js",      @"application/x-javascript",
                    @"json",    @"application/json",   // According to RFC 4627  // Also application/x-javascript text/javascript text/x-javascript text/x-json
                    @"latex",   @"application/x-latex",
                    @"lha",     @"application/octet-stream",
                    @"lsf",     @"video/x-la-asf",
                    @"lsx",     @"video/x-la-asf",
                    @"lzh",     @"application/octet-stream",
                    @"m",       @"text/plain",
                    @"m13",     @"application/x-msmediaview",
                    @"m14",     @"application/x-msmediaview",
                    @"m3u",     @"audio/x-mpegurl",
                    @"man",     @"application/x-troff-man",
                    @"mdb",     @"application/x-msaccess",
                    @"me",      @"application/x-troff-me",
                    @"mht",     @"message/rfc822",
                    @"mhtml",   @"message/rfc822",
                    @"mid",     @"audio/mid",
                    @"mny",     @"application/x-msmoney",
                    @"mov",     @"video/quicktime",
                    @"movie",   @"video/x-sgi-movie",
                    @"mp2",     @"video/mpeg",
                    @"mp3",     @"audio/mpeg",
                    @"mpa",     @"video/mpeg",
                    @"mpe",     @"video/mpeg",
                    @"mpeg",    @"video/mpeg",
                    @"mpg",     @"video/mpeg",
                    @"mpp",     @"application/vnd.ms-project",
                    @"mpv2",    @"video/mpeg",
                    @"ms",      @"application/x-troff-ms",
                    @"mvb",     @"    application/x-msmediaview",
                    @"nws",     @"message/rfc822",
                    @"oda",     @"application/oda",
                    @"p10",     @"application/pkcs10",
                    @"p12",     @"application/x-pkcs12",
                    @"p7b",     @"application/x-pkcs7-certificates",
                    @"p7c",     @"application/x-pkcs7-mime",
                    @"p7m",     @"application/x-pkcs7-mime",
                    @"p7r",     @"application/x-pkcs7-certreqresp",
                    @"p7s",     @"    application/x-pkcs7-signature",
                    @"pbm",     @"image/x-portable-bitmap",
                    @"pdf",     @"application/pdf",
                    @"pfx",     @"application/x-pkcs12",
                    @"pgm",     @"image/x-portable-graymap",
                    @"pko",     @"application/ynd.ms-pkipko",
                    @"pma",     @"application/x-perfmon",
                    @"pmc",     @"application/x-perfmon",
                    @"pml",     @"application/x-perfmon",
                    @"pmr",     @"application/x-perfmon",
                    @"pmw",     @"application/x-perfmon",
                    @"png",     @"image/png",
                    @"pnm",     @"image/x-portable-anymap",
                    @"pot",     @"application/vnd.ms-powerpoint",
                    @"vppm",    @"image/x-portable-pixmap",
                    @"pps",     @"application/vnd.ms-powerpoint",
                    @"ppt",     @"application/vnd.ms-powerpoint",
                    @"pptx",    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                    @"prf",     @"application/pics-rules",
                    @"ps",      @"application/postscript",
                    @"pub",     @"application/x-mspublisher",
                    @"qt",      @"video/quicktime",
                    @"ra",      @"audio/x-pn-realaudio",
                    @"ram",     @"audio/x-pn-realaudio",
                    @"ras",     @"image/x-cmu-raster",
                    @"rgb",     @"image/x-rgb",
                    @"rmi",     @"audio/mid",
                    @"roff",    @"application/x-troff",
                    @"rtf",     @"application/rtf",
                    @"rtx",     @"text/richtext",
                    @"scd",     @"application/x-msschedule",
                    @"sct",     @"text/scriptlet",
                    @"setpay",  @"application/set-payment-initiation",
                    @"setreg",  @"application/set-registration-initiation",
                    @"sh",      @"application/x-sh",
                    @"shar",    @"application/x-shar",
                    @"sit",     @"application/x-stuffit",
                    @"snd",     @"audio/basic",
                    @"spc",     @"application/x-pkcs7-certificates",
                    @"spl",     @"application/futuresplash",
                    @"src",     @"application/x-wais-source",
                    @"sst",     @"application/vnd.ms-pkicertstore",
                    @"stl",     @"application/vnd.ms-pkistl",
                    @"stm",     @"text/html",
                    @"svg",     @"image/svg+xml",
                    @"sv4cpio", @"application/x-sv4cpio",
                    @"sv4crc",  @"application/x-sv4crc",
                    @"swf",     @"application/x-shockwave-flash",
                    @"t",       @"application/x-troff",
                    @"tar",     @"application/x-tar",
                    @"tcl",     @"application/x-tcl",
                    @"tex",     @"application/x-tex",
                    @"texi",    @"application/x-texinfo",
                    @"texinfo", @"application/x-texinfo",
                    @"tgz",     @"application/x-compressed",
                    @"tif",     @"image/tiff",
                    @"tiff",    @"image/tiff",
                    @"tr",      @"application/x-troff",
                    @"trm",     @"application/x-msterminal",
                    @"tsv",     @"text/tab-separated-values",
                    @"txt",     @"text/plain",
                    @"uls",     @"text/iuls",
                    @"ustar",   @"application/x-ustar",
                    @"vcf",     @"text/x-vcard",
                    @"vrml",    @"x-world/x-vrml",
                    @"wav",     @"audio/x-wav",
                    @"wcm",     @"application/vnd.ms-works",
                    @"wdb",     @"application/vnd.ms-works",
                    @"wks",     @"application/vnd.ms-works",
                    @"wmf",     @"application/x-msmetafile",
                    @"wps",     @"application/vnd.ms-works",
                    @"wri",     @"application/x-mswrite",
                    @"wrl",     @"x-world/x-vrml",
                    @"wrz",     @"x-world/x-vrml",
                    @"xaf",     @"x-world/x-vrml",
                    @"xbm",     @"image/x-xbitmap",
                    @"xla",     @"application/vnd.ms-excel",
                    @"xlc",     @"application/vnd.ms-excel",
                    @"xlm",     @"application/vnd.ms-excel",
                    @"xls",     @"application/vnd.ms-excel",
                    @"xlsx",    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    @"xlt",     @"application/vnd.ms-excel",
                    @"xlw",     @"application/vnd.ms-excel",
                    @"xml",     @"text/xml",   // According to RFC 3023   // Also application/xml
                    @"xof",     @"x-world/x-vrml",
                    @"xpm",     @"image/x-xpixmap",
                    @"xwd",     @"image/x-xwindowdump",
                    @"z",       @"application/x-compress",
                    @"zip",     @"application/zip",
                    nil];
    }
    
    return MIMEDict;
}
@end
