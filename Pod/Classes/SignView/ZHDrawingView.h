//
//  ZHDrawingView.h
//  

#import <UIKit/UIKit.h>

@interface ZHDrawingView : UIView

// 用来设置线条的颜色
@property (nonatomic, strong) UIColor *color;
// 用来设置线条的宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 用来记录已有线条
@property (nonatomic, strong) NSMutableArray *allLines;
/// 开始绘制前，NO-不会绘制
@property (nonatomic, copy) BOOL(^drawBeforeBegin)(void);

/// 后退操作
- (void)doBack;
/// 清除全部
- (void)clearAll;
// Forward操作
- (void)doForward;
// 获取签名图片
- (UIImage *)getSignImage;


@end
