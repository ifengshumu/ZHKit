//
//  UIColor+Extension.m
//  ZHKit
//
//  Created by Lee on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIColor+Extension.h"

UIColorRGBValue const UIColorRedValue = @"ColorRedValue";
UIColorRGBValue const UIColorGreenValue = @"ColorGreenValue";
UIColorRGBValue const UIColorBlueValue = @"ColorBlueValue";
UIColorRGBValue const UIColorAlphaValue = @"ColorAlphaValue";


@implementation UIColor (Extension)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    //去除空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //6位或8位(带透明度)
    if (cString.length != 6 || cString.length != 8) {
        return UIColor.clearColor;
    }
    //取出透明度、红、绿、蓝
    unsigned int a, r, g, b;
    NSRange range;
    range.location = 0;
    range.length = 2;
    if (cString.length == 8) {
        //a
        NSString *aString = [cString substringWithRange:range];
        //r
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        alpha = a / 255.0f;
    } else {
        //r
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
    }
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

//  默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)gradientColor:(NSArray<UIColor *> *)colors gradientSize:(CGSize)aSize gradientDirection:(UIGradientColorDirection)direction {
    UIGraphicsBeginImageContextWithOptions(aSize, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *refColors = [NSMutableArray arrayWithCapacity:0];
    for (UIColor *color in colors) {
        [refColors addObject:(__bridge id)color.CGColor];
    }
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)refColors, NULL);
    CGPoint endPoint = CGPointZero;
    if (direction == UIGradientColorDirectionHorizontal) {
        endPoint = CGPointMake(aSize.width, 0);
    } else {
        endPoint = CGPointMake(0, aSize.height);
    }
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), endPoint, kCGGradientDrawsBeforeStartLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

//  随机颜色
+ (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
}

//  颜色转化为照片
- (UIImage *)toImg {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// 颜色转化为十六进制字符串
+ (NSString *)hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4)
    {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB)
    {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}


+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

- (NSDictionary<UIColorRGBValue,NSNumber *> *)rgbValue {
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&red green:&green blue:&blue alpha:&alpha];
    } else {
        const CGFloat *compoments = CGColorGetComponents(self.CGColor);
        red = compoments[0];
        green = compoments[1];
        blue = compoments[2];
        alpha = compoments[3];
    }
    return @{UIColorRedValue:@(red), UIColorGreenValue:@(green), UIColorBlueValue:@(blue), UIColorAlphaValue:@(alpha)};
}

- (UIColor * _Nonnull (^)(CGFloat))setAlpha {
    return ^(CGFloat a) {
        return [self colorWithAlphaComponent:a];
    };
}



+ (UIColor *)deepBlueColor {
    return [UIColor colorWithHexString:@"#7657A4"];
}
+ (UIColor *)lightBlueColor {
    return [UIColor colorWithHexString:@"#F3F2FD"];
}
+ (UIColor *)deepBlackColor {
    return [UIColor colorWithHexString:@"#333333"];
}
+ (UIColor *)lightBlackColor {
    return [UIColor colorWithHexString:@"#606266"];
}
+ (UIColor *)regularGrayColor {
    return [UIColor colorWithHexString:@"#909399"];
}
+ (UIColor *)lineColor {
    return [UIColor colorWithHexString:@"#EBEEF5"];
}
+ (UIColor *)backgroundColor {
    return [UIColor colorWithHexString:@"#F8F8F8"];
}
+ (UIColor *)placeholderColor {
    return [UIColor colorWithHexString:@"#AAAAAA"];
}
+ (UIColor *)deepRedColor {
    return [UIColor colorWithHexString:@"#D23139"];
}

@end


