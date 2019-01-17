# ZHKit
开发常用工具和系统类扩展

## cocoapods support
```
pod 'ZHKit'
```

## 部分示例

## UIButton
```
/**
设置按钮图片文字排列位置，务必在按钮图片文字和frame设置完毕后调用

@param style see UIButtonImageTextAlignmentStyle
@param space 图片文字间距
*/
- (void)setImageTextAlignmentStyle:(UIButtonImageTextAlignmentStyle)style  space:(CGFloat)space;
```
```
/**
添加Block事件
*/
- (void)addActionHandler:(void(^)(UIButton *sedner))action;
```
```
/**
倒计时

@param dutation 时间
@param title 倒计时结束时按钮显示标题
@param remainingTime 剩余时间
*/
- (void)countdownWithDuration:(NSUInteger)dutation endButtonTitle:(NSString *)title remainingTime:(void(^)(NSUInteger time))remainingTime;
```

## UIColor
```
/**
十六进制颜色值转UIColor，
hexString除去开头的0X或#为6位或8位，
hexStringt如果是6位则alpha=1，如果为8位则使用颜色值中的透明度

*/
+ (UIColor *)colorWithHexString:(NSString *)hexString;
```
```
/**
UIColor转十六进制颜色值
*/
- (NSString *)hexString;
```
```
/**
渐变颜色

@param aSize 渐变尺寸
@param direction 渐变方向
*/
+ (UIColor *)gradientColorFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)aSize direction:(UIGradientColorDirection)direction;
```

## UIImage
```
/**
根据颜色、尺寸生产图片

@param color 颜色
@param size 尺寸
@return 图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
```
```
/**
缩放图片

@param image 图片
@param size 缩放尺寸
@return 图片
*/
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;
```

## UILabel
```
/**
计算label内容size，根据固定的宽、字体
*/
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font;
```
```
/**
计算label内容size，根据固定的宽、字体、行间距
*/
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font lineSpace:(CGFloat)lineSpace;
```
```
/**
计算label内容size，根据固定的宽、字体、段落格式
*/
+ (CGSize)sizeForContent:(NSString *)content settledWidth:(CGFloat)width font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle;
```

## UITextField
```
UITextField *textField = [[UITextField alloc] init];
textField.maxLength = 5;//输入字数限制
```

### 判空
```
BOOL isblank = [NSString isBlankString:@""];
NSLog(@"空字符-%d", isblank);
```
### 取数字
```
NSString *price = [NSString getNumberFromString:@"价格100元"];
NSLog(@"数字-%@", price);
```
### 金额大写
```
NSString *hanzi = [NSString chineseCapitalNumber:1234];
NSLog(@"大写数字-%@", hanzi);
```
### 拼音
```
NSString *pinyin = [NSString pinYin:@"我是谁"];
NSLog(@"拼音-%@", pinyin);
```
### 时间戳
```
long long timestamp = [NSDate timestampFromString:@"2222年02月02日" withStyle:DateConvertStyleChinese];
NSLog(@"时间戳-%lld", timestamp);
NSString *time = [NSDate stringFromTimestamp:timestamp withStyle:DateConvertStyleChinese];
NSLog(@"时间-%@", time);
NSDate *date = [NSDate dateFromTimestamp:timestamp withStyle:DateConvertStyleChinese];
NSLog(@"时间-%@", date);
```
# 其他一些扩展可祥见Demo
