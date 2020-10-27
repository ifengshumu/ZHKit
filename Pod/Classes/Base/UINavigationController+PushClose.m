//
//  UINavigationController+PushClose.m
//  CheryNewRetail
//
//  Created by 李志华 on 2019/7/11.
//

#import "UINavigationController+PushClose.h"

@implementation UINavigationController (PushClose)

- (void)pushViewControllerAndFinishCurrent:(UIViewController *)viewController {
    [self pushViewController:viewController finishCurrentAnimated:NO];
}

- (void)pushViewController:(UIViewController *)viewController finishCurrentAnimated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    NSMutableArray *vcs = self.viewControllers.mutableCopy;
    [vcs removeLastObject];
    self.viewControllers = vcs.copy;
    [self pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController direction:(CATransitionSubtype)direction animation:(TransitionAnimation)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = [self nameForAnimation:animation]; //动画类型
    transition.subtype = direction; //动画方向
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.view.layer addAnimation:transition forKey:kCATransition]; //添加动画
    [self pushViewController:viewController animated:NO]; //这里的animated要设置为NO
}

- (void)pushViewControllerFromBottom:(UIViewController *)viewController {
    [self pushViewController:viewController direction:kCATransitionFromTop animation:TransitionAnimationMoveIn];
}

- (void)popViewControllerWithDirection:(CATransitionSubtype)direction animation:(TransitionAnimation)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6f;
    transition.type = [self nameForAnimation:animation];
    transition.subtype = direction;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.layer addAnimation:transition forKey:kCATransition];
    [self popViewControllerAnimated:NO];
}
- (void)popViewControllerFromTop {
    [self popViewControllerWithDirection:kCATransitionFromBottom animation:TransitionAnimationReveal];
}

- (NSString *)nameForAnimation:(TransitionAnimation)animation {
    switch (animation) {
        case TransitionAnimationFade:
            return kCATransitionFade;
            break;
        case TransitionAnimationMoveIn:
            return kCATransitionMoveIn;
            break;
        case TransitionAnimationPush:
            return kCATransitionPush;
            break;
        case TransitionAnimationReveal:
            return kCATransitionReveal;
            break;
        case TransitionAnimationCube:
            return @"cube";
            break;
        case TransitionAnimationSuckEffect:
            return @"suckEffect";
            break;
        case TransitionAnimationOglFlip:
            return @"oglFlip";
            break;
        case TransitionAnimationRippleEffect:
            return @"rippleEffect";
            break;
        case TransitionAnimationPageCurl:
            return @"pageCurl";
            break;
        case TransitionAnimationPageUnCurl:
            return @"pageUnCurl";
            break;
        case TransitionAnimationCameraIrisHollowOpen:
            return @"cameraIrisHollowOpen";
            break;
        case TransitionAnimationCameraIrisHollowClose:
            return @"cameraIrisHollowClose";
            break;
        default:
            return kCATransitionFade;
            break;
    }
}

@end
