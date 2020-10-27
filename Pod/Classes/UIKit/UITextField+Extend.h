//
//  UITextField+Extend.h
//  CheryNewRetail
//
//  Created by 李志华 on 2019/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Extend)
/// set max text count of textField
@property (nonatomic, assign) NSUInteger maxLength;
/// set placeholder, defined color.
- (void)setPlaceholder:(NSString *)placeholder color:(UIColor *)color;
/// set placeholder, defined font.
- (void)setPlaceholder:(NSString *)placeholder font:(UIFont *)font;
/// set placeholder, defined attributes.
- (void)setPlaceholder:(NSString *)placeholder attributes:(NSDictionary<NSAttributedStringKey, id>*)attributes;

- (NSInteger)curOffset;
- (void)makeOffset:(NSInteger)offset;
- (void)makeOffsetFromBeginning:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
