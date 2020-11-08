//
//  SPTextView.m
//  SPTextView
//
//

#import "SPTextView.h"

@interface SPTextView()<UITextViewDelegate>
// 文字统计的label
@property(nonatomic , strong) UILabel *textCountlabel;
 //占位文字的label
@property(nonatomic , strong) UILabel *placeHolderlabel;
@end

@implementation SPTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotify:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)layoutUI {
    //[self initWithLayer];
    //创建字数统计label
    UILabel *textCountlabel = [[UILabel alloc] init];
    textCountlabel.text = @"已输入288/可输入300";
    textCountlabel.textAlignment = NSTextAlignmentRight;
    textCountlabel.font = [UIFont systemFontOfSize:15];
    textCountlabel.textColor = [UIColor lightGrayColor];
    self.textCountlabel = textCountlabel;
    [self addSubview:textCountlabel];
    [textCountlabel sizeToFit];
    [self.textCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@-15);
    }];
    //输入框
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = UIColor.clearColor;
    _textView.delegate = self;
    self.maxTextCount = 300;
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@2);
        make.right.equalTo(@-2);
        make.bottom.equalTo(textCountlabel.mas_top).offset(-5);
    }];
    //占位符
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderlabel = placeHolderLabel;
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [self.textView addSubview:placeHolderLabel];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}

-(void)initWithLayer{
    CAShapeLayer* dashLineShapeLayer = [CAShapeLayer layer];
    UIBezierPath* dashLinePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:2];
    
    dashLineShapeLayer.path = dashLinePath.CGPath;
    dashLineShapeLayer.fillColor = [UIColor clearColor].CGColor;
    dashLineShapeLayer.strokeColor = [UIColor colorWithRed:153/255.f green:166/255.f blue:170/255.f alpha:1].CGColor;
    dashLineShapeLayer.lineWidth = 1;
    dashLineShapeLayer.lineDashPattern = @[@(6),@(6)];
    
    dashLineShapeLayer.strokeStart = 0;
    dashLineShapeLayer.strokeEnd = 1;
    dashLineShapeLayer.zPosition = 999;
    [self.layer addSublayer:dashLineShapeLayer];
}

#pragma mark - 设置最大文字输入数量
-(void)setMaxTextCount:(NSInteger)maxTextCount{
    _maxTextCount = maxTextCount;
    _textCountlabel.text = [NSString stringWithFormat:@"0/%zd",self.maxTextCount];
    
}

- (void)textViewDidChangeNotify:(NSNotification *)notify {
    [self handleDidChangedTextView];
}

- (void)handleDidChangedTextView {
    if (self.textView.text.length >= self.maxTextCount) {
        self.textView.text = [self.textView.text substringToIndex:self.maxTextCount];
    }
    self.placeHolderlabel.hidden = self.textView.text.length;
    self.textCountlabel.text = [NSString stringWithFormat:@"%d/%d",(int)self.textView.text.length, (int)(self.maxTextCount- self.textView.text.length)];
    self.textCountlabel.textColor = self.textView.text.length < self.maxTextCount? [UIColor lightGrayColor]:[UIColor redColor];
}

#pragma mark - 代理方法,textView里面的内容发生改变的时候
- (void)textViewDidChange:(UITextView *)textView {
    [self handleDidChangedTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.textView resignFirstResponder];
        if (self.textViewChangeTextBlock) {
            self.textViewChangeTextBlock(textView.text);
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)setTextViewInsets:(UIEdgeInsets)textViewInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_textViewInsets, textViewInsets)) {
        [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(textViewInsets.top));
            make.left.equalTo(@(textViewInsets.left));
            make.right.equalTo(@(-textViewInsets.right));
            make.bottom.equalTo(@(-textViewInsets.bottom));
        }];
    }
}

-(void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    self.placeHolderlabel.text = placeHolder;
}

- (void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor {
    _placeHolderTextColor = placeHolderTextColor;
    self.placeHolderlabel.textColor = placeHolderTextColor;
}

-(void)setShowTextCount:(BOOL)showTextCount{
    _showTextCount = !showTextCount;
    self.textCountlabel.hidden = _showTextCount;
    if (_showTextCount) {
        self.maxTextCount = INT64_MAX;
    }
}

@end
