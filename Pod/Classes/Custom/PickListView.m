
//
//  PickListView.m
//  PPYLiFeng
//
//  Created by Steve on 2020/7/1.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "PickListView.h"
#import "ListCell.h"

@interface PickListView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *defaultValue;
@end

@implementation PickListView

- (instancetype)initWithList:(NSArray<NSString *> *)list defaultValue:(nullable NSString *)aValue {
    self = [super initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight-mBottomSafeH)];
    if (self) {
        _list = list;
        _defaultValue = aValue;
        [self layoutUI];
        [self layoutGesture];
    }
    return self;
}

- (void)layoutUI {
    CGFloat height = self.list.count * 50.f + 44.f;
    height = MIN(height, 400);
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-height, mScreenWidth, height)];
    self.contentView.backgroundColor = UIColor.whiteColor;
    [self.contentView setCornerRadius:8 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self addSubview:self.contentView];
    //
    [self addHeaderView];
    //
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 44, mScreenWidth, height-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = UIColor.lineColor;
    tableView.rowHeight = 50.f;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = height == 400;
    self.tableView = tableView;
    [tableView registerClass:ListCell.class forCellReuseIdentifier:@"ListCell"];
    [self.contentView addSubview:tableView];
}
- (void)addHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44)];
    headerView.backgroundColor = UIColor.whiteColor;
    [headerView addUnderLine];
    [self.contentView addSubview:headerView];
    
    UILabel *cancelLabel = [[UILabel alloc] init];
    cancelLabel.text = @"取消";
    cancelLabel.textColor = UIColor.regularGrayColor;
    cancelLabel.font = mFont(14);
    [headerView addSubview:cancelLabel];
    [cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(@20);
    }];
    [cancelLabel addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self dismiss];
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请选择";
    titleLabel.textColor = UIColor.deepBlackColor;
    titleLabel.font = mFontM(14);
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    UILabel *doneLabel = [[UILabel alloc] init];
    doneLabel.text = @"确定";
    doneLabel.textColor = UIColor.deepBlueColor;
    doneLabel.font = mFont(14);
    [headerView addSubview:doneLabel];
    [doneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.equalTo(@-20);
    }];
    [doneLabel addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (self.doneResult) {
            if (self.indexPath) {
                self.doneResult(self.list[self.indexPath.row], self.indexPath.row);
            } else {
                [self showFailureToast:@"请选择"];
            }
        }
        [self dismiss];
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell" forIndexPath:indexPath];
    [cell setContent:self.list[indexPath.row]];
    if (self.defaultValue && [self.list indexOfObject:self.defaultValue] == indexPath.row) {
        self.indexPath = indexPath;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
}

#pragma mark - Public Method
- (void)show {
    if (!self.list.count) {
        return;
    }
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window addSubview:self];
    //动画
    self.alpha = 0.0f;
    self.contentView.y = mScreenHeight;
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 1.f;
        self.contentView.y = self.height-self.contentView.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 0.0f;
        self.contentView.y = mScreenHeight;
    } completion:^(BOOL completed) {
        [self removeFromSuperview];
    }];
}

- (void)layoutGesture {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}


@end
