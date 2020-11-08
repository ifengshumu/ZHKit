//
//  BorderLineTextField.h
//  MFLingLingQi
//
//  Created by Murphy on 16/11/25.
//  Copyright © 2016年 Murphy. All rights reserved.
//

#import "BaseTextField.h"
#import "UIView+Animation.h"


@interface BorderLineTextField : BaseTextField

// 控制当在编辑时，是否高亮文本框的Border,默认是YES
@property (assign, nonatomic) BOOL isChangeBorder;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
