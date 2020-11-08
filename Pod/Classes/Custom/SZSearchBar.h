//
//  SZSearchBar.h
//
//  Created by 李志华 on 2019/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SZSearchBar : UIView
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) UIButton *cancelButton;
@property (nonatomic, copy) void(^textFieldhHandler)(BOOL isSearch, UITextField *textField);
@property (nonatomic, copy) void(^cancelButtonHandler)(void);
///搜索框
+ (instancetype)searchBar;
///一般用于跳转单独的搜索页面，此时textField的enabled为NO
- (void)addTapHandler:(void(^)(void))handler;
@end

NS_ASSUME_NONNULL_END
