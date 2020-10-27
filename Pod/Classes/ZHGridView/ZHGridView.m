//
//  ZHGridView.m
//
//  Created by 李志华 on 16/8/4.
//  Copyright © 2016年 李志华. All rights reserved.
//

#import "ZHGridView.h"

@interface ZHGridView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation ZHGridView

static NSString *const cellIdentiffer = @"cellIdentiffer";
static NSString *const headerIdentiffer = @"headerIdentiffer";

#pragma mark - 2 life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.addImage = [UIImage imageNamed:@"zh_add"];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *v = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        v.backgroundColor = UIColor.whiteColor;
        v.showsHorizontalScrollIndicator = NO;
        v.showsVerticalScrollIndicator = NO;
        v.scrollEnabled = NO;
        v.dataSource = self;
        v.delegate = self;
        [v registerClass:[ZHGridCell class] forCellWithReuseIdentifier:cellIdentiffer];
        [v registerClass:[ZHGridHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentiffer];
        [self addSubview:v];
        self.collectionView = v;
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.kind == ZHGridKindShow) {
        return self.dataSource.count;
    } else {
        if (self.maxCount == 0) return self.dataSource.count + 1;
        return self.dataSource.count < self.maxCount ? (self.dataSource.count + 1) : self.dataSource.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.contentHeight = collectionView.contentSize.height;
    ZHGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentiffer forIndexPath:indexPath];
    ZHGridModel *model = nil;
    if (indexPath.item < self.dataSource.count) {
        model = self.dataSource[indexPath.item];
    }
    [cell configWithData:model placeHolderImage:self.placeHolderImage addImage:self.addImage canDelete:self.kind == ZHGridKindAdd canEdit:self.canEdit];
    //删除
    [cell.deleteButton addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        [self.dataSource removeObjectAtIndex:indexPath.item];
        [self reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:deleteDataAtIndex:)]) {
            [self.delegate gridView:self deleteDataAtIndex:indexPath.item];
        }
    }];
    //编辑
    [cell.editButton addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTriggerEditAction:)]) {
            [self.delegate gridViewTriggerEditAction:self];
        }
    }];
    //变动
    if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewDataSouceChanged:)]) {
        [self.delegate gridViewDataSouceChanged:self];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ZHGridHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentiffer forIndexPath:indexPath];
        if (self.title) {
            header.titleLabel.text = self.title;
            UIFont *font = self.titleAttrs[NSFontAttributeName];
            UIColor *color = self.titleAttrs[NSForegroundColorAttributeName];
            if (font) header.titleLabel.font = font;
            if (color) header.titleLabel.textColor = color;
        }
        if (self.subtitle) {
            header.subtitleLabel.text = self.subtitle;
            UIFont *font = self.subtitleAttrs[NSFontAttributeName];
            UIColor *color = self.subtitleAttrs[NSForegroundColorAttributeName];
            if (font) header.subtitleLabel.font = font;
            if (color) header.subtitleLabel.textColor = color;
        }
        return header;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.dataSource.count) {
        //浏览
        NSMutableArray *tmp = @[].mutableCopy;
        for (ZHGridModel *m in self.dataSource) {
            if (m.videoURL) {
                YBIBVideoData *videoData = [YBIBVideoData new];
                videoData.videoURL = m.videoURL;
                [tmp addObject:videoData];
            } else  {
                YBIBImageData *imageData = [YBIBImageData new];
                if (m.imageURLString) {
                    imageData.imageURL = [NSURL URLWithString:m.imageURLString];
                } else {
                    imageData.image = ^UIImage * _Nullable{
                        return m.image;
                    };
                }
                [tmp addObject:imageData];
            }
        }
        // 设置数据源数组并展示
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = tmp;
        browser.currentPage = indexPath.item;
        [browser show];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTriggerAddAction:)]) {
            [self.delegate gridViewTriggerAddAction:self];
        } else {
            ZHPhotoManager *manager = [ZHPhotoManager sharedManager];
            manager.multiPickMaxCount = self.maxCount-self.dataSource.count;
            [manager pickImageDidFinish:^(NSArray<UIImage *> * _Nonnull images) {
                NSMutableArray *data = [ZHGridModel modelWithDataArray:images];
                [self.dataSource addObjectsFromArray:data];
                [self reloadData];
            }];
        }
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(gridView:sizeForPhotoAtIndex:)]) {
        return [self.delegate gridView:self sizeForPhotoAtIndex:indexPath.item];
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(insetForGridView:)]) {
        return [self.delegate insetForGridView:self];
    }
    return UIEdgeInsetsZero;
}
//竖向(上下)间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(rowSpacingForGridView:)]) {
        return [self.delegate rowSpacingForGridView:self];
    }
    return 10;
}
//横向(左右)间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(columnSpacingForGridView:)]) {
        return [self.delegate columnSpacingForGridView:self];
    }
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(sizeOfHeaderForGridView:)]) {
        return [self.delegate sizeOfHeaderForGridView:self];
    }
    return CGSizeZero;
}

#pragma mark - Piblic Method
- (void)addHeaderTitle:(NSString *)title attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    self.title = title;
    self.titleAttrs = attrs;
}
- (void)addHeaderSubtitle:(NSString *)title attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    self.subtitle = title;
    self.subtitleAttrs = attrs;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - 7 getters and setters
- (void)setContentHeight:(CGFloat)contentHeight {
    if (fabs(_contentHeight-contentHeight) > 1) {
    }
    _contentHeight = contentHeight;
    CGRect rect  = self.frame;
    rect.size.height = _contentHeight;
    self.frame = rect;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(contentHeight);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    if ([self.delegate respondsToSelector:@selector(gridView:heightChanged:)]) {
        [self.delegate gridView:self heightChanged:contentHeight];
    }
}

- (CGFloat)heightForHeader {
    CGFloat titleH = 0;
    if (_title.length) {
        titleH = [_title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleAttrs[NSFontAttributeName]} context:nil].size.height;
    }
    CGFloat subH = 0;
    if (_subtitle.length) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        subH = [_subtitle boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.subtitleAttrs[NSFontAttributeName], NSParagraphStyleAttributeName:style} context:nil].size.height;
    }
    return titleH + subH + 30;
}

- (NSMutableArray<ZHGridModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

@end
