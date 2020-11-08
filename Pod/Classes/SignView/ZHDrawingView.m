//
//  ZHDrawingView.m
//

#import "ZHDrawingView.h"

@interface ZHDrawingView()

// 声明一条贝塞尔曲线
@property(nonatomic, strong) UIBezierPath *bezier;
// 创建一个存储后退操作记录的数组
@property(nonatomic, strong) NSMutableArray *cancleArr;

@end

@implementation ZHDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.color = [UIColor blackColor];
        self.lineWidth = 1;
        self.allLines = [NSMutableArray new];
        self.cancleArr = [NSMutableArray new];
        
    }
    return self;
}

- (void)doBack {
    
    if (self.allLines.count > 0) {
        NSInteger index = self.allLines.count - 1;
        [self.cancleArr addObject:self.allLines[index]];
        [self.allLines removeObjectAtIndex:index];
        [self setNeedsDisplay];
    }
    
}

- (void)clearAll {
    if (self.allLines.count > 0) {
        [self.allLines removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)doForward {
    if (self.cancleArr.count > 0) {
        NSInteger index = self.cancleArr.count - 1;
        [self.allLines addObject:self.cancleArr[index]];
        [self.cancleArr removeObjectAtIndex:index];
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (self.drawBeforeBegin) {
//        BOOL can = self.drawBeforeBegin();
//        if (!can) return;
//    }
    
    // 贝塞尔曲线
    self.bezier = [UIBezierPath bezierPath];
    
    // 获取触摸的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 设置贝塞尔起点
    [self.bezier moveToPoint:point];
    
    // 在字典保存每条线的数据
    NSMutableDictionary *tempDic = [NSMutableDictionary new];
    [tempDic setObject:self.color forKey:@"color"];
    [tempDic setObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [tempDic setObject:self.bezier forKey:@"line"];
    
    // 存入线
    [self.allLines addObject:tempDic];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.bezier addLineToPoint:point];
    //重绘界面
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    for (int i = 0; i < self.allLines.count; i++) {
        
        NSDictionary *temDic = self.allLines[i];
        UIColor *color = temDic[@"color"];
        CGFloat width = [temDic[@"lineWidth"] floatValue];
        UIBezierPath *path = temDic[@"line"];
        
        [color setStroke];
        [path setLineWidth:width];
        [path stroke];
    }
}


- (UIImage *)getSignImage {
    // 截屏
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 截取画板尺寸
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
