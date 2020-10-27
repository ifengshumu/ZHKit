//
//  UIView+Loading.h
//  PPYLiFeng
//
//  Created by Murphy on 2020/7/10.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (Loading)

- (void)showSuccessfulToast:(NSString *)message;

- (void)showFailureToast:(NSString *)error;

- (void)showLoading:(NSString*)message;

- (void)showLoading;

- (void)dismissLoading;

@end

NS_ASSUME_NONNULL_END
