//
//  ZHShareMenuView.m
//  ZHShareManager
//
//  Created by 李志华 on 2018/12/24.
//

#import "ZHShareMenuView.h"
#import "ZHShareMenu.h"
#import "ZHShareObject.h"

@interface ZHShareMenuView ()<UIGestureRecognizerDelegate>
@property (nonatomic, copy) NSArray<ZHShareMenu *> *menus;
@property (nonatomic, strong) UIView *containView;
@end

@implementation ZHShareMenuView

- (instancetype)initWithMenus:(NSArray<ZHShareMenu *> *)menus {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        self.menus = menus;
        [self addDismissTap];
    }
    return self;
}

- (UIView *)containView {
    if (!_containView) {
        UIView *containView = [[UIView alloc] init];
        containView.backgroundColor = self.containViewBackgroundColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self addSubview:containView];
        _containView = containView;
        UIColor *color = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0];
        NSInteger cnt = 4;
        CGFloat space = 15.0;
        CGFloat iconNameSpace = 5.0;
        CGFloat leftRight = self.showType == ShareCustomShowTypeActionSheet?0:15.0;
        CGFloat w = (self.frame.size.width-leftRight-space*(cnt+1))/cnt;
        __block CGFloat containViewH = 0.0;
        [self.menus enumerateObjectsUsingBlock:^(ZHShareMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //配置分享平台图标和名称
            UIImage *image = [UIImage imageNamed:obj.imageName];
            CGSize imageSize = image.size;
            CGSize textSize = [obj.title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGFloat h = imageSize.height+textSize.height;
            CGFloat x = (idx % cnt)*(w+space)+space;
            CGFloat y = (idx / cnt)*(h+space+iconNameSpace)+space;
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:image];
            icon.frame = CGRectMake((w-imageSize.width)/2.0, 0, imageSize.width, imageSize.height);
            UILabel *name = [[UILabel alloc] init];
            name.text = obj.title;
            name.textColor = color;
            name.font = [UIFont systemFontOfSize:12];
            name.frame = CGRectMake((w-textSize.width)/2.0, imageSize.height+iconNameSpace, textSize.width, textSize.height);
            name.textAlignment = NSTextAlignmentCenter;
            UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h+iconNameSpace)];
            shareView.tag = obj.shareObject.platformType+10000;
            [shareView addSubview:icon];
            [shareView addSubview:name];
            [containView addSubview:shareView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectPlatform:)];
            [shareView addGestureRecognizer:tap];
            //承载视图的高度
            if (idx == self.menus.count-1) {
                containViewH = CGRectGetMaxY(shareView.frame)+space;
            }
        }];
        
        if (self.showType == ShareCustomShowTypeActionSheet) {
            //取消
            if (self.showCancle) {
                UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancel setTitle:@"取消" forState:UIControlStateNormal];
                [cancel setTitleColor:color forState:UIControlStateNormal];
                [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
                [containView addSubview:cancel];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
                line.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
                [cancel addSubview:line];
                
                containViewH += 50;
                cancel.frame = CGRectMake(0, containViewH-50, self.frame.size.width, 50);
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIScreen.mainScreen.bounds.size.height > 800) {
                    containViewH += 34.f;
                }
            }
            //设置承载视图frame
            containView.frame = CGRectMake(0, self.frame.size.height-containViewH, self.frame.size.width, containViewH);
            [self setCornerRadiusView:containView radius:10 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
        } else {
            //如果锚点视图在下半屏，则展示在锚点视图的上面
            BOOL isHalf = NO;
            //箭头起始点
            CGFloat startX = 0.0;
            CGFloat startY = 0.0;
            if (self.anchorView) {
                CGRect rect = [self.anchorView.superview convertRect:self.anchorView.frame toView:self];
                isHalf = rect.origin.y > UIScreen.mainScreen.bounds.size.height/2.0;
                startX = CGRectGetMaxX(rect)-rect.size.width/2.0;
                startY = isHalf?rect.origin.y:CGRectGetMaxY(rect);
            } else {
                isHalf = self.anchor.y > UIScreen.mainScreen.bounds.size.height/2.0;
                startX = self.anchor.x;
                startY = self.anchor.y;
            }
            //设置承载视图frame
            CGFloat anchorH = 15.0;
            if (isHalf) {
                containView.frame = CGRectMake(leftRight/2.0, (startY-containViewH-anchorH), self.frame.size.width-leftRight, containViewH);
            } else {
                containView.frame = CGRectMake(leftRight/2.0, (startY+anchorH), self.frame.size.width-leftRight, containViewH);
            }
            containView.layer.cornerRadius = leftRight/2.0;
            //画箭头
            UIImageView *iv = [[UIImageView alloc] init];
            [self addSubview:iv];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(startX, startY)];
            if (isHalf) {
                [path addLineToPoint:CGPointMake(startX+10, startY-anchorH)];
                [path addLineToPoint:CGPointMake(startX-10, startY-anchorH)];
            } else {
                [path addLineToPoint:CGPointMake(startX-10, startY+anchorH)];
                [path addLineToPoint:CGPointMake(startX+10, startY+anchorH)];
            }
            [path closePath];
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = path.CGPath;
            layer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
            [iv.layer addSublayer:layer];
        }
    }
    return _containView;
}

- (void)show {
    if (!self.menus.count) {
        NSAssert(self.menus.count, @"必须传入分享菜单");
    }
    //显示
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.alpha = 0.0;
    if (self.showType == ShareCustomShowTypeActionSheet) {
        __block CGRect rect = self.containView.frame;
        rect.origin.y = UIScreen.mainScreen.bounds.size.height;
        self.containView.frame = rect;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
            rect.origin.y -= CGRectGetHeight(rect);
            self.containView.frame = rect;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)dismiss {
    if (self.showType == ShareCustomShowTypeActionSheet) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.containView.frame;
            rect.origin.y = UIScreen.mainScreen.bounds.size.height;
            self.containView.frame = rect;
            self.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)didSelectPlatform:(UITapGestureRecognizer *)sender {
    if (self.selectSharePlatform) {
        NSInteger platformType = sender.view.tag-10000;
        __block ZHShareObject *object = nil;
        [self.menus enumerateObjectsUsingBlock:^(ZHShareMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.shareObject.platformType == (SharePlatformType)platformType) {
                object = obj.shareObject;
                *stop = YES;
            }
        }];
        self.selectSharePlatform(platformType, object);
        [self dismiss];
    }
}

- (void)addDismissTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.containView]) {
        return NO;
    }
    return YES;
}

- (void)setCornerRadiusView:(UIView *)radiusView radius:(CGFloat)radius corners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:radiusView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, CGRectGetHeight(radiusView.frame))];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = radiusView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    radiusView.layer.mask = maskLayer;
}

@end
