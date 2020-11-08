//
//  ARAudioRecorder.h
//  PPYLiFeng
//
//  Created by Steve on 2020/7/6.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARAudioRecorder : UIView

@property (nonatomic, copy) void(^recordResult)(NSInteger time, NSURL *file);

/// 开始录制
- (void)startRecorder;

/// 停止录制
- (void)stopRecorder;

/// 播放，url=nil，播放本地，!= nil播放在线
- (void)playRecordFile:(nullable NSString *)url;

/// 删除录音
- (void)deleteRecord;

/// 显示
- (void)show;

/// 消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
