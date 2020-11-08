//
//  ListCell.m
//  PPYLiFeng
//
//  Created by Steve on 2020/7/1.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "ListCell.h"

@interface ListCell ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *icon;
@end

@implementation ListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = mFont(14);
        label.textColor = UIColor.regularGrayColor;
        self.label = label;
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_choice"]];
        icon.hidden = YES;
        self.icon = icon;
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(@-26);
            make.width.height.equalTo(@16);
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    self.label.text = content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.icon.hidden = !selected;
    self.label.textColor = selected ? UIColor.deepBlueColor : UIColor.deepBlackColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
