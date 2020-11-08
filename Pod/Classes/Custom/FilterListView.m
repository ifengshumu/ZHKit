//
//  FilterListView.m
//  PPYLiFeng
//
//  Created by Steve on 2020/6/16.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "FilterListView.h"
#import "ListCell.h"

@interface FilterListView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) UIView *triggerView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FilterListView

- (instancetype)initWithTrigger:(UIView *)trigger list:(NSArray<NSString *> *)list {
    self = [super init];
    if (self) {
        _triggerView = trigger;
        _list = list;
        [self layoutUI];
        [self layoutGesture];
    }
    return self;
}

- (void)layoutGesture {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)layoutUI {
    BaseTableView *tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, self.list.count * 44.f) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = UIColor.lineColor;
    tableView.tintColor = UIColor.deepBlueColor;
    tableView.rowHeight = 44;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [tableView registerClass:ListCell.class forCellReuseIdentifier:@"FilterListCell"];
    [self addSubview:tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterListCell" forIndexPath:indexPath];
    [cell setContent:self.list[indexPath.row]];
    if (self.defaultValue && [self.list indexOfObject:self.defaultValue] == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.filterSelectResult) {
        self.filterSelectResult(self.list[indexPath.row], indexPath.row);
    }
    [self dismiss];
}

#pragma mark - Public Method
- (void)show {
    if (!self.list.count) {
          return;
    }
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGRect convertRect = [self.triggerView convertRect:self.triggerView.bounds toView:window];
    CGFloat top = CGRectGetMaxY(convertRect);
    self.frame = CGRectMake(0, top, mScreenWidth, mScreenHeight-mBottomSafeH-top);
    [window addSubview:self];
    //动画
    self.alpha = 0.0f;
    self.tableView.height = 0;
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 1.f;
        self.tableView.height = self.list.count * 44.f;
    } completion:^(BOOL finished) {
        if (self.filterShowStatus) {
            self.filterShowStatus(YES);
        }
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 0.0f;
        self.tableView.height = 0;
    } completion:^(BOOL completed) {
        [self removeFromSuperview];
        if (self.filterShowStatus) {
            self.filterShowStatus(NO);
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

@end
