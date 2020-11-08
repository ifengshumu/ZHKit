//
//  SearchTextField.h
//  PPYLiFeng
//
//  Created by Murphy on 2020/6/21.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "BaseTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchTextField : BaseTextField

@property (nonatomic, copy) void(^searchWithBlock)(BaseTextField *textField);
@property (nonatomic, copy) void(^tapWithBlock)(BOOL isTap);

@end

NS_ASSUME_NONNULL_END
