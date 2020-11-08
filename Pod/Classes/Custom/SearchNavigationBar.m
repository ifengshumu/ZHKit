//
//  SearchNavigationBar.m
//
//  Created by 李志华 on 2019/6/20.
//

#import "SearchNavigationBar.h"

@implementation SearchNavigationBar

+ (instancetype)navigationBar {
    return [[SearchNavigationBar alloc] initWithFrame:CGRectMake(0, mStatusH, mScreenWidth, mNavBarH)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:UIImageNamed(@"nav_back") forState:UIControlStateNormal];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@0);
        make.width.height.equalTo(@25);
    }];
    @weakify(self);
    [_backButton addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        @strongify(self);
        if (self.backButtonHandler) {
            self.backButtonHandler();
        }
    }];
    _searchBar = [[SZSearchBar alloc] init];
    _searchBar.contentView.layer.cornerRadius = 17;
    _searchBar.contentView.layer.borderColor = UIColor.deepBlueColor.CGColor;
    _searchBar.contentView.layer.borderWidth = 1;
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(@5);
        make.left.equalTo(self.backButton.mas_right);
        make.bottom.equalTo(@-5);
        make.right.equalTo(@-5);
    }];
}

- (void)setBackButtonImage:(UIImage *)image {
    [self.backButton setImage:image forState:UIControlStateNormal];
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}


@end
