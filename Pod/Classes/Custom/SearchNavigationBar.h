//
//  SearchNavigationBar.h
//
//  Created by 李志华 on 2019/6/20.
//

#import <UIKit/UIKit.h>
#import "SZSearchBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchNavigationBar : UIView
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) SZSearchBar *searchBar;
@property (nonatomic, copy) void(^backButtonHandler)(void);

+ (instancetype)navigationBar;
- (void)setBackButtonImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
