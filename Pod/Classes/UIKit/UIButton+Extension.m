//
//  UIButton+Extension.m
//
//  Created by 李志华 on 2020/4/10.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

- (void)setUserInfo:(NSDictionary *)userInfo {
    objc_setAssociatedObject(self, @selector(userInfo), userInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)userInfo {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets {
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIEdgeInsets)touchAreaInsets {
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchAreaInsets, UIEdgeInsetsZero)) {
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
        CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
        bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
        return CGRectContainsPoint(bounds, point);
        
    } else {
        UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
        bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                            bounds.origin.y - touchAreaInsets.top,
                            bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                            bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
        return CGRectContainsPoint(bounds, point);
    }
    
}

- (void)addTouchUpInsideEventUsingBlock:(void (^)(UIButton *))block {
    [self addControlEvent:UIControlEventTouchUpInside usingBlock:block];
}

- (void)addControlEvent:(UIControlEvents)controlEvent usingBlock:(void (^)(UIButton * _Nonnull))block {
    self.userInfo = @{@"action":block};
    [self addTarget:self action:@selector(actionHandler:) forControlEvents:controlEvent];
}

- (void)actionHandler:(UIButton *)sender {
    void(^buttonActionHandler)(UIButton *) = sender.userInfo[@"action"];
    buttonActionHandler(sender);
}

- (void)setImageTextAlignment:(UIButtonImageAlignment)style space:(CGFloat)space {
    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}].height;
    space = space / 2.0;
    
    /*
     top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
     
     left : 为正数的时候往右偏移,为负数的时候往左偏移;
     
     bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
     
     right :为正数的时候往左偏移,为负数的时候往右偏移;
     */
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    if (style == UIButtonImageAlignmentLeft) {
        //左图右文
        imageEdgeInsets = UIEdgeInsetsMake(0, -space, 0, space);
        titleEdgeInsets = UIEdgeInsetsMake(0, space, 0, -space);
    } else if (style == UIButtonImageAlignmentRight) {
        //左文右图
        titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth+space), 0, imageWidth+space);
        imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space, 0, -(labelWidth+space));
    } else if (style == UIButtonImageAlignmentTop) {
        //上图下文
        imageEdgeInsets = UIEdgeInsetsMake(-(labelHeight+space), 0, 0, -labelWidth);
        titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -(imageHeight+space), 0);
    } else {
        //上文下图
        titleEdgeInsets = UIEdgeInsetsMake(-(imageHeight+space), -imageWidth, 0, 0);
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, -(labelHeight+space), -labelWidth);
    }
    self.titleEdgeInsets = titleEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state {
    //[self sd_setImageWithURL:[self getImageWithURLString:urlString] forState:state];
}

- (void)setImageWithURLString:(NSString *)urlString forState:(UIControlState)state placehoderImageName:(NSString *)imageName {
    //[self sd_setImageWithURL:[self getImageWithURLString:urlString] forState:state placeholderImage:imageName.length?[UIImage imageNamed:imageName]:nil];
}

- (void)setBackgroundImageWithURL:(NSString *)urlString forState:(UIControlState)state {
    //[self sd_setBackgroundImageWithURL:[self getImageWithURLString:urlString] forState:state];
}

- (NSURL *)getImageWithURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    return url;
}

- (void)countdownWithDuration:(NSUInteger)dutation timeInterval:(NSUInteger)timeInterval remainingTime:(void(^)(NSUInteger time))remainingTime {
    __block NSUInteger timeOut = dutation;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),timeInterval*NSEC_PER_SEC, 0); //间隔执行
    dispatch_source_set_event_handler(timer, ^{
        if(timeOut <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(timer);
        }
        //剩余时间（秒）
        dispatch_async(dispatch_get_main_queue(), ^{
            //倒计时过程中的按钮显示
            if (remainingTime) {
                remainingTime(timeOut);
            }
            timeOut -= timeInterval;
        });
    });
    dispatch_resume(timer);
    self.userInfo = @{@"timer":timer};
}
- (void)countdownWithDuration:(NSUInteger)dutation remainingTime:(void(^)(NSUInteger time))remainingTime {
    [self countdownWithDuration:dutation timeInterval:1.0 remainingTime:remainingTime]; //每秒执行
}

- (void)cancelCountdown {
    dispatch_source_t timer = self.userInfo[@"timer"];
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

@end
