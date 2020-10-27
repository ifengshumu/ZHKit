//
//  UIButton+CountDown.m
//  MFShowcaseImage
//
//  Created by Mengfei on 16/5/13.
//  Copyright © 2016年 XinMiao. All rights reserved.
//

#import "UIButton+CountDown.h"

@implementation UIButton (CountDown)

-(void)startTime:(NSInteger)timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle downColor:(UIColor *)downColor normalColor:(UIColor *)normalColor
{
    //  倒计时时间
    __block NSInteger timeOut = timeout;
    //  创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //  创建Dispatch Source
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //  设置定时器信息（定时器源），每秒执行
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    //  编写和安装一个事件处理器
    dispatch_source_set_event_handler(_timer, ^{
        if(timeOut <= 0)
        {
            //  倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //  设置界面的按钮显示 根据自己需求设置
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                self.backgroundColor = normalColor;
            });
        }else
        {
//          int seconds = timeout;
            timeOut--;
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //  设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                self.backgroundColor = downColor;
            });
//            timeOut--;
        }
    });
    dispatch_resume(_timer);
    
//    //  取消处理器关闭
//    dispatch_source_set_cancel_handler(_timer, ^{
//        dispatch_source_cancel(_timer);
//    });
}

-(void)startTime:(NSInteger)timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle downColor:(UIColor *)downColor normalColor:(UIColor *)normalColor titleDisableColor:(UIColor *)titleDisableColor titleNormalColor:(UIColor *)titleNormalColor
{
    //  倒计时时间
        __block NSInteger timeOut = timeout;
        //  创建全局队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //  创建Dispatch Source
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //  设置定时器信息（定时器源），每秒执行
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
        //  编写和安装一个事件处理器
        dispatch_source_set_event_handler(_timer, ^{
            if(timeOut <= 0)
            {
                //  倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  设置界面的按钮显示 根据自己需求设置
                    [self setTitle:tittle forState:UIControlStateNormal];
                    [self setTitleColor:titleNormalColor forState:(UIControlStateNormal)];
                    self.userInteractionEnabled = YES;
                    self.backgroundColor = normalColor;
                });
            }else
            {
    //          int seconds = timeout;
                timeOut--;
                int seconds = timeOut % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //  设置界面的按钮显示 根据自己需求设置
    //                NSLog(@"____%@",strTime);
                    [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                    [self setTitleColor:titleDisableColor forState:(UIControlStateNormal)];
                    self.userInteractionEnabled = NO;
                    self.backgroundColor = downColor;
                });
    //            timeOut--;
            }
        });
        dispatch_resume(_timer);
        
    //    //  取消处理器关闭
    //    dispatch_source_set_cancel_handler(_timer, ^{
    //        dispatch_source_cancel(_timer);
    //    });
}

@end
