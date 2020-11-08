//
//  SZSearchBar.m
//
//  Created by 李志华 on 2019/6/18.
//

#import "SZSearchBar.h"

@interface SZSearchBar ()<UITextFieldDelegate>

@end

@implementation SZSearchBar

+ (instancetype)searchBar {
    SZSearchBar *search = [[SZSearchBar alloc] initWithFrame:CGRectMake(0, mNavHeight + 15, mScreenWidth, H(35))];
    search.contentView.layer.cornerRadius = H(35) / 2.0;
    search.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    return search;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    UIView *contentView = [[UIView alloc] init];
    _contentView = contentView;
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.bottom.equalTo(@0);
    }];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]];
    [contentView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(contentView);
        make.width.height.equalTo(@14);
    }];
    UITextField *textField = [[UITextField alloc] init];
    _textField = textField;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;
    textField.placeholder = @"搜索";
    textField.font = [UIFont systemFontOfSize:14];
    textField.textColor = UIColor.deepBlackColor;
    [contentView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(15);
        make.top.bottom.right.equalTo(contentView);
    }];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton = cancel;
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:UIColor.deepBlueColor forState:UIControlStateNormal];
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(contentView.mas_right).offset(10);
        make.right.equalTo(@-5);
        make.width.equalTo(@0);
    }];
    [cancel addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        textField.text = nil;
        [textField resignFirstResponder];
        [self keyboardWillHideNotification];
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification) name:UIKeyboardDidHideNotification object:nil];
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
    }];
    if (self.textFieldhHandler) {
        self.textFieldhHandler(NO, textField);
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.textFieldhHandler) {
        self.textFieldhHandler(YES, textField);
    }
    return YES;
}

- (void)keyboardWillHideNotification {
    if (self.textField.text.length) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@0);
    }];
    if (self.cancelButtonHandler) {
        self.cancelButtonHandler();
    }
}

- (void)addTapHandler:(void(^)(void))handler {
    self.textField.enabled = NO;
    [self.contentView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (handler) {
            handler();
        }
    }];
}

@end
