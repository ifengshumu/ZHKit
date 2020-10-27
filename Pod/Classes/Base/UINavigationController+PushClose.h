//
//  UINavigationController+PushClose.h
//  CheryNewRetail
//
//  Created by 李志华 on 2019/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TransitionAnimation) {
    TransitionAnimationFade,
    TransitionAnimationMoveIn,
    TransitionAnimationPush,
    TransitionAnimationReveal,
    TransitionAnimationCube,
    TransitionAnimationSuckEffect,
    TransitionAnimationOglFlip,
    TransitionAnimationRippleEffect, //水波纹
    TransitionAnimationPageCurl,
    TransitionAnimationPageUnCurl,
    TransitionAnimationCameraIrisHollowOpen,
    TransitionAnimationCameraIrisHollowClose
};

@interface UINavigationController (PushClose)

/**
 跳转并关闭当前页，无动画
 */
- (void)pushViewControllerAndFinishCurrent:(UIViewController *)viewController;

/**
 跳转并关闭当前页，
 */
- (void)pushViewController:(UIViewController *)viewController finishCurrentAnimated:(BOOL)animated;

/**
 Push转场动画

 @param viewController 控制器
 @param direction 方向
 @param animation 动画
 */
- (void)pushViewController:(UIViewController *)viewController direction:(CATransitionSubtype)direction animation:(TransitionAnimation)animation;


/**
 Push转场，从底部
 */
- (void)pushViewControllerFromBottom:(UIViewController *)viewController;

/**
 Pop转场动画
 
 @param direction 方向
 @param animation 动画
 */
- (void)popViewControllerWithDirection:(CATransitionSubtype)direction animation:(TransitionAnimation)animation;
/**
 Push转场，从顶部
 */
- (void)popViewControllerFromTop;

@end

NS_ASSUME_NONNULL_END
