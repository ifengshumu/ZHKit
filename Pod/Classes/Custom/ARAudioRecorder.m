//
//  ARAudioRecorder.m
//  PPYLiFeng
//
//  Created by Steve on 2020/7/6.
//  Copyright © 2020 Murphy. All rights reserved.
//

#import "ARAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface ARAudioRecorder ()
{
    NSURL *recordedFile;//存放路径
    AVPlayer *player;//播放
    AVAudioRecorder *recorder;//录制
    NSTimer *recoderTimer;
    NSInteger time;
    
    BOOL isPlaying; //是否正在播放
}

@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIImageView *recoderIv;

@end

@implementation ARAudioRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = mSuitableFrame;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-60, mScreenWidth, 60)];
    self.bottomV = bottom;
    bottom.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self addSubview:bottom];
    UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [key setImage:mImage(@"voice_key") forState:UIControlStateNormal];
    [bottom addSubview:key];
    [key addTouchUpInsideEventUsingBlock:^(UIButton * _Nonnull sender) {
        [self dismiss];
    }];
    
    UILabel *voice = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, mScreenWidth-80, 40)];
    voice.backgroundColor = UIColor.whiteColor;
    voice.font = mFont(14);
    voice.text = @"按住 说话";
    voice.textAlignment = NSTextAlignmentCenter;
    [voice setCornerRidus:4];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    voice.userInteractionEnabled = YES;
    [voice addGestureRecognizer:longPress];
    [bottom addSubview:voice];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)sender {
    UILabel *voice = (UILabel *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan) {
        voice.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        voice.text = @"松开 结束";
        
        [self startRecorder];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        voice.backgroundColor = UIColor.whiteColor;
        voice.text = @"按住 说话";
        [self stopRecorder];
    }
}

- (void)settingAudioRecorder {
    NSString *date = [NSDate stringFromDate:[NSDate date] withStyle:DateConvertStyleDefaultHMS];
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",date]];
    recordedFile = [NSURL fileURLWithPath:path];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatLinearPCM),
                               AVSampleRateKey:@(11025.0),
                               AVEncoderAudioQualityKey:@(AVAudioQualityHigh),
                               AVLinearPCMBitDepthKey:@(16),
                               AVNumberOfChannelsKey:@(2)};
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:settings error:nil];
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)startRecorder {
    [self settingAudioRecorder];
    [recorder peakPowerForChannel:0];
    [recorder record];
    self.recoderIv.hidden = NO;
    //计时
    time = 0;
    recoderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recoderTimerCount) userInfo:nil repeats:YES];
}

- (void)recoderTimerCount {
    time += 1;
    if (time == 30) {
        [self stopRecorder];
        
    }
}

- (void)stopRecorder {
    self.recoderIv.hidden = YES;
    [recorder stop];
    [self stop];
    [self dismiss];
    if (self.recordResult) {
        self.recordResult(time, recordedFile);
    }
}

- (void)stop {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if (recoderTimer) {
        [recoderTimer invalidate];
        recoderTimer = nil;
    }
    if (isPlaying) {
        [player removeObserver:self forKeyPath:@"status"];
        [player pause];
    }
    isPlaying = NO;
}

- (void)playRecordFile:(NSString *)url {
    NSURL *asset = nil;
    if (url) {
        asset = [NSURL URLWithString:url];
    } else {
        asset = recordedFile;
    }
    if (isPlaying) {
        [self stop];
        return;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //开启红外感应
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:asset];
    player = [[AVPlayer alloc] initWithPlayerItem:item];
    player.volume = 1.f;
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceProximityStateDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if ([[UIDevice currentDevice] proximityState]) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        } else {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self stop];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        if (player.status == AVPlayerStatusReadyToPlay) {
            [player play];
            isPlaying = YES;
        }
    }
}

- (void)deleteRecord {
    [self stop];
    [recorder deleteRecording];
}

- (UIImageView *)recoderIv {
    if (!_recoderIv) {
        _recoderIv = [[UIImageView alloc] initWithImage:mImage(@"audio_record")];
        _recoderIv.hidden = YES;
        [self addSubview:_recoderIv];
        [_recoderIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _recoderIv;
}

#pragma mark - Public Method
- (void)show {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    [window endEditing:YES];
    [window addSubview:self];
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 1.f;
        self.bottomV.y = self.height-self.bottomV.height;
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        [UIView setAnimationCurve:7];
        self.alpha = 0.0f;
        self.bottomV.y = mScreenHeight;
    } completion:^(BOOL completed) {
        [self removeFromSuperview];
    }];
}


@end
