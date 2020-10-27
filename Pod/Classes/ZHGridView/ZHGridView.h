//
//  ZHGridView.h
//
//  Created by 李志华 on 16/8/4.
//  Copyright © 2016年 李志华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHGridModel.h"
#import "ZHGridCell.h"
#import "ZHGridHeaderView.h"

@class ZHGridView;

NS_ASSUME_NONNULL_BEGIN

@protocol ZHGridViewDelegate <NSObject>
///图片尺寸，默认CGSizeZero
- (CGSize)gridView:(ZHGridView *)gridView sizeForPhotoAtIndex:(NSInteger)index;
@optional
///四周区域，默认UIEdgeInsetsZero
- (UIEdgeInsets)insetForGridView:(ZHGridView *)gridView;
///列间距，默认10
- (CGFloat)columnSpacingForGridView:(ZHGridView *)gridView;
///行间距，默认10
- (CGFloat)rowSpacingForGridView:(ZHGridView *)gridView;
///头部视图尺寸，默认CGSizeZero
- (CGSize)sizeOfHeaderForGridView:(ZHGridView *)gridView;
///高度更新
- (void)gridView:(ZHGridView *)gridView heightChanged:(CGFloat)height;

///编辑图片
- (void)gridViewTriggerEditAction:(ZHGridView *)gridView;

///删除图片
- (void)gridView:(ZHGridView *)gridView deleteDataAtIndex:(NSInteger)index;
///点击添加
- (void)gridViewTriggerAddAction:(ZHGridView *)gridView;
///数据变动
- (void)gridViewDataSouceChanged:(ZHGridView *)gridView;

@end


typedef NS_ENUM(NSUInteger, ZHGridKind) {
    ZHGridKindShow  = 0, //只展示
    ZHGridKindAdd   = 1, //可添加删除
};


@interface ZHGridView : UIView
/// 代理
@property (nonatomic, weak) id<ZHGridViewDelegate> delegate;
/// 布局模式
@property (nonatomic, assign) ZHGridKind kind;
/// 最大显示数量
@property (nonatomic, assign) NSInteger maxCount;
/// 数据源
@property (nonatomic, strong) NSMutableArray<ZHGridModel *> *dataSource;


/// 占位图片，用于加载网络图片
@property (nonatomic, strong) UIImage *placeHolderImage;
/// 添加图片，不设置使用默认图片
@property (nonatomic, strong) UIImage *addImage;
/// 是否可编辑
@property (nonatomic, assign) BOOL canEdit;


/// 头部标题
@property (nonatomic, copy) NSString *title;
/// 头部标题属性
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *titleAttrs;
/// 头部副标题
@property (nonatomic, copy) NSString *subtitle;
/// 头部副标题属性
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *subtitleAttrs;


/// 设置标题
- (void)addHeaderTitle:(NSString *)title attributes:(NSDictionary<NSAttributedStringKey, id> *)attrs;
/// 设置副标题
- (void)addHeaderSubtitle:(NSString *)title attributes:(NSDictionary<NSAttributedStringKey, id> *)attrs;
- (CGFloat)heightForHeader;

/// 刷新
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
