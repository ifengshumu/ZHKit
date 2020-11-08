//
//  SPTextView.h
//  SPTextView
//
//

#import <UIKit/UIKit.h>

@interface SPTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong, readonly) UITextView *textView;
/// textView边距
@property (nonatomic, assign) UIEdgeInsets textViewInsets;
 /// 占位文字
@property (nonatomic, copy) NSString *placeHolder;
 /// 占位文字TextColor
@property (nonatomic, copy) UIColor *placeHolderTextColor;
/// 最大文字输入量
@property (nonatomic, assign) NSInteger  maxTextCount;
 /// 是否显示文字统计，默认YES
@property (nonatomic, assign) BOOL  showTextCount;

@property (nonatomic, copy) void (^textViewChangeTextBlock)(NSString *text);

@end
