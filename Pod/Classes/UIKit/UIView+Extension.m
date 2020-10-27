//
//  UIView+Extension.m
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "UIView+Extension.h"

void didAutoLayout(void(^layout)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (layout) layout();
    });
}


CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}


@implementation UIView (Extension)

// Retrieve and set the origin
- (CGPoint) origin
{
    return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
    return self.frame.size;
}

- (void)setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

// Query other frame locations
- (CGPoint) bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
    return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width
{
    return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) top
{
    return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) left
{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}

-(void)setCornerRidus:(CGFloat)cornerRidus{
    self.layer.cornerRadius = cornerRidus;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.clipsToBounds = YES;
}

-(CGFloat)cornerRidus{
    return self.layer.cornerRadius;
}



static NSString *const LineColor = @"#EBEEF5";
static CGFloat const LineHeight = 1.f;
static NSInteger const TopLineTag = 998;
static NSInteger const UnderLineTag = 999;

- (void)addLine:(BOOL)isTop edge:(UIEdgeInsets)inset color:(id)aColor tag:(NSInteger)tag {
    UIView *line = [self viewWithTag:tag];
    if (line) return;
    line = [[UIView alloc] init];
    line.tag = tag;
    line.backgroundColor = [aColor isKindOfClass:[UIColor class]] ? aColor : [UIColor colorWithHexString:aColor];
    [self addSubview:line];
    CGFloat left = inset.left;
    CGFloat right = fabs(inset.right);
    CGFloat top = inset.top;
    CGFloat bottom = inset.bottom;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isTop) {
            make.top.equalTo(@(top));
        } else {
            make.bottom.equalTo(@(bottom));
        }
        make.left.equalTo(@(left));
        make.right.equalTo(@(-right));
        make.height.equalTo(@(LineHeight));
    }];
}

- (void)addTopLineWithColor:(id)aColor edge:(UIEdgeInsets)edge {
    [self addLine:YES edge:edge color:aColor tag:TopLineTag];
}

- (void)addTopLineWithColor:(id)aColor {
    [self addTopLineWithColor:aColor edge:UIEdgeInsetsZero];
}

- (void)addTopLineWithEdge:(UIEdgeInsets)edge {
    [self addTopLineWithColor:LineColor edge:edge];
}

- (void)addTopLine {
    [self addTopLineWithColor:LineColor];
}

- (void)removeTopLine {
    [[self viewWithTag:TopLineTag] removeFromSuperview];
}

- (void)addUnderLineWithColor:(id)aColor edge:(UIEdgeInsets)edge {
    [self addLine:NO edge:edge color:aColor tag:UnderLineTag];
}

- (void)addUnderLineWithColor:(id)aColor {
    [self addUnderLineWithColor:aColor edge:UIEdgeInsetsZero];
}

- (void)addUnderLineWithEdge:(UIEdgeInsets)edge {
    [self addUnderLineWithColor:LineColor edge:edge];
}

- (void)addUnderLine {
    [self addUnderLineWithColor:LineColor];
}

- (void)removeUnderLine {
    [[self viewWithTag:UnderLineTag] removeFromSuperview];
}

- (void)addLineWithEdgeInset:(UIEdgeInsets)inset {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:LineColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(inset);
    }];
}

- (void)setCornerRadius:(CGFloat)radius
                corners:(UIRectCorner)corners {
    didAutoLayout(^{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, self.frame.size.height)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        //设置大小
        maskLayer.frame = self.bounds;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    });
}

- (void)setCornerRadius:(CGFloat)cornerRadius
                corners:(UIRectCorner)cornecrs
            shadowColor:(UIColor *)color
                 offset:(CGSize)offset
                 radius:(CGFloat)radius
                opacity:(CGFloat)opacity {
    if (@available(iOS 11.0, *)) {
        //设置阴影
        self.layer.shadowColor = color.CGColor;
        self.layer.shadowOffset = offset;
        self.layer.shadowRadius = radius;
        self.layer.shadowOpacity = opacity;
        self.layer.masksToBounds = NO;
        //设置圆角
        self.layer.cornerRadius = cornerRadius;
        self.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    } else {
        didAutoLayout(^{
            //设置圆角
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:cornecrs cornerRadii:CGSizeMake(cornerRadius, CGRectGetHeight(self.frame))];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
            maskLayer.frame = self.bounds;
            maskLayer.path = path.CGPath;
            self.layer.mask = maskLayer;
            //设置阴影
            CAShapeLayer *shadowLayer = [[CAShapeLayer alloc]init];
            shadowLayer.frame = self.bounds;
            shadowLayer.path = path.CGPath;
            shadowLayer.shadowOpacity = opacity;
            shadowLayer.shadowRadius = radius;
            shadowLayer.shadowColor = color.CGColor;
            shadowLayer.shadowOffset = offset;
            [self.superview.layer insertSublayer:shadowLayer below:self.layer];
        });
    }
}


- (void)setShadowColor:(UIColor *)color
               offset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.masksToBounds = NO; //YES会导致阴影失效
}

- (UIView *)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = color.CGColor;
    return self;
}

- (UIView *)setBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth borderSide:(UIBorderSide)borderSide {
    if (borderSide == UIBorderSideAll) {
        return [self setBorderColor:color borderWidth:borderWidth];
    }
    /// 左侧
    if (borderSide & UIBorderSideLeft) {
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.f, 0.f) toPoint:CGPointMake(0.0f, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    /// 右侧
    if (borderSide & UIBorderSideRight) {
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(self.frame.size.width, 0.0f) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    /// top
    if (borderSide & UIBorderSideTop) {
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(self.frame.size.width, 0.0f) color:color borderWidth:borderWidth]];
    }
    /// bottom
    if (borderSide & UIBorderSideBottom) {
        [self.layer addSublayer:[self addLineOriginPoint:CGPointMake(0.0f, self.frame.size.height) toPoint:CGPointMake( self.frame.size.width, self.frame.size.height) color:color borderWidth:borderWidth]];
    }
    return self;
}

- (CAShapeLayer *)addLineOriginPoint:(CGPoint)p0 toPoint:(CGPoint)p1 color:(UIColor *)color borderWidth:(CGFloat)borderWidth {
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p0];
    [bezierPath addLineToPoint:p1];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = UIColor.clearColor.CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;
    return shapeLayer;
}


/// 创建UILabel
- (UILabel *)labelTextColor:(UIColor *)textColor font:(UIFont *)font {
    return [self labelText:nil textColor:textColor font:font];
}
/// 创建UILabel，设置文本
- (UILabel *)labelText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    return label;
}

/// 创建UIImageView
- (UIImageView *)imageView {
    return [self imageViewWithImage:nil];
}
/// 创建UIImageView，设置图片
- (UIImageView *)imageViewWithImage:(UIImage *)image {
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    return iv;
}

/// 创建UIButton，填充文本
- (UIButton *)buttonTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font {
    return [self buttonTitle:title titleColor:titleColor font:font image:nil];
}
/// 创建UIButton，填充图片
- (UIButton *)buttonImage:(UIImage *)img {
    return [self buttonTitle:nil titleColor:nil font:nil image:img];
}
/// 创建UIButton，填充文本+图片
- (UIButton *)buttonTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font image:(UIImage *)img {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (img) {
        [button setImage:img forState:UIControlStateNormal];
    }
    return button;
}

@end
