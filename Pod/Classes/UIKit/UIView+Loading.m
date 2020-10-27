//
//  UIView+Loading.m
//  PPYLiFeng
//
//  Created by Murphy on 2020/7/10.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "UIView+Loading.h"


@implementation UIView (Loading)

- (void)showSuccessfulToast:(NSString *)message
{
    [ZHAlertView showSuccessfulToast:message view:[self getSuperView]];
}

- (void)showFailureToast:(NSString *)error
{
    [ZHAlertView showFailureToast:error view:[self getSuperView]];
}

- (void)showLoading:(NSString*)message
{
    [ZHAlertView showLoading:message view:[self getSuperView]];
}

- (void)showLoading
{
    [ZHAlertView showLoadingWithView:[self getSuperView]];
}

- (void)dismissLoading
{
    [ZHAlertView dismissLoadingWithView:[self getSuperView]];
}

- (UIView *)getSuperView
{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]])
        {
            UIViewController *vc = (UIViewController *)responder;
            return vc.view;
        }
        responder = responder.nextResponder;
    } while (responder);
    return self;
}

@end
