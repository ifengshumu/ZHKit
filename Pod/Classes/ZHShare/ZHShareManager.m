//
//  ZHShareManager.m
//  ZHShareManager
//
//  Created by 李志华 on 2018/11/5.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "ZHShareManager.h"
#import "ZHShareMenu.h"
#import "ZHShareObject.h"
#import "ZHShareMenuView.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface ZHShareManager ()
@property (nonatomic, copy) NSArray<ZHShareMenu *> *targetShareMenus;
@end

@implementation ZHShareManager

+ (instancetype)sharedManager {
    static ZHShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZHShareManager alloc] init];
    });
    return manager;
}

+ (void)setSocialShareAppkey:(NSString *)appkey {
    [UMConfigure initWithAppkey:appkey channel:nil];
}

+ (BOOL)isInstallPlatform:(SharePlatformType)platform {
    return [[UMSocialManager defaultManager] isInstall:platform];
}

+ (BOOL)isSupportPlatform:(SharePlatformType)platform {
    return [[UMSocialManager defaultManager] isSupport:platform];
}

+ (BOOL)setPlaform:(SharePlatformType)platform appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL {
    return  [[UMSocialManager defaultManager] setPlaform:platform appKey:appKey appSecret:appSecret redirectURL:redirectURL];
}

+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary*)options {
    if (options) {
        return  [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    } else {
        return [[UMSocialManager defaultManager] handleOpenURL:url];
    }
}

- (void)showDefaultShareMenus:(NSArray<ZHShareMenu *> *)menus selectPlatform:(void (^)(SharePlatformType, NSDictionary *))didSelectPlatform completion:(void (^)(id, NSError *))completion {
    //隐藏标题
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    //隐藏取消
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    //分享平台图标样式
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    //去掉毛玻璃效果
    [UMSocialShareUIConfig shareInstance].shareContainerConfig.isShareContainerHaveGradient = NO;
    
    self.targetShareMenus = menus;
    NSArray *platArray = [self getSupportPlatforms];
    if (!platArray.count) {
        NSAssert(platArray.count, @"设置的分享平台未在手机未安装");
    } else {
        [UMSocialUIManager setPreDefinePlatforms:platArray];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if (didSelectPlatform) {
                didSelectPlatform((SharePlatformType)platformType, userInfo);
            }
            __block ZHShareObject *object = nil;
            [self.targetShareMenus enumerateObjectsUsingBlock:^(ZHShareMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.shareObject.platformType == (SharePlatformType)platformType) {
                    object = obj.shareObject;
                    *stop = YES;
                }
            }];
            [self shareObject:object completion:completion];
        }];
    }
}

- (void)showActionSheetShareMenus:(NSArray<ZHShareMenu *> *)menus selectPlatform:(void (^)(SharePlatformType, NSDictionary *))didSelectPlatform completion:(void (^)(id, NSError *))completion {
    self.targetShareMenus = menus;
    ZHShareMenuView *menuView = [[ZHShareMenuView alloc] initWithMenus:[self getSupportMenus]];
    menuView.showType = ShareCustomShowTypeActionSheet;
    menuView.showCancle = YES;
    menuView.containViewBackgroundColor = UIColor.whiteColor;
    menuView.selectSharePlatform = ^(SharePlatformType platformType, ZHShareObject *shareObject) {
        if (didSelectPlatform) {
            didSelectPlatform((SharePlatformType)platformType, nil);
        }
        [self shareObject:shareObject completion:completion];
    };
    [menuView show];
}
- (void)showAnchorShareMenus:(NSArray<ZHShareMenu *> *)menus anchorView:(UIView *)anchorView selectPlatform:(void (^)(SharePlatformType, NSDictionary *))didSelectPlatform completion:(void (^)(id, NSError *))completion {
    self.targetShareMenus = menus;
    ZHShareMenuView *menuView = [[ZHShareMenuView alloc] initWithMenus:[self getSupportMenus]];
    menuView.showType = ShareCustomShowTypeAnchor;
    menuView.anchorView = anchorView;
    menuView.selectSharePlatform = ^(SharePlatformType platformType, ZHShareObject *shareObject) {
        if (didSelectPlatform) {
            didSelectPlatform((SharePlatformType)platformType, nil);
        }
        [self shareObject:shareObject completion:completion];
    };
    [menuView show];
}
- (void)showAnchorShareMenu:(NSArray<ZHShareMenu *> *)menus anchor:(CGPoint)anchor onSelectPlatform:(void (^)(SharePlatformType, NSDictionary *))didSelectPlatform completion:(void (^)(id, NSError *))completion {
    self.targetShareMenus = menus;
    ZHShareMenuView *menuView = [[ZHShareMenuView alloc] initWithMenus:[self getSupportMenus]];
    menuView.showType = ShareCustomShowTypeAnchor;
    menuView.anchor = anchor;
    menuView.selectSharePlatform = ^(SharePlatformType platformType, ZHShareObject *shareObject) {
        if (didSelectPlatform) {
            didSelectPlatform((SharePlatformType)platformType, nil);
        }
        [self shareObject:shareObject completion:completion];
    };
    [menuView show];
}

- (void)shareObject:(ZHShareObject *)object completion:(void(^)(id result, NSError *error))completion {
    [[UMSocialManager defaultManager] shareToPlatform:object.platformType messageObject:[self messageObject:object] currentViewController:object.currentViewController completion:^(id result, NSError *error) {
        UMSocialShareResponse *res = result;
        if (completion) {
            completion(res, error);
        }
    }];
}
//获取安装可用的分享菜单
- (NSArray *)getSupportMenus {
    if (!self.targetShareMenus.count) {
        NSAssert(self.targetShareMenus.count, @"必须配置分享菜单");
    }
    if (self.isFilterNotExistPlatform) {
        NSArray *platArray = [UMSocialManager defaultManager].platformTypeArray;
        if (!platArray.count) return nil;
        NSMutableArray *array = self.targetShareMenus.mutableCopy;
        [self.targetShareMenus enumerateObjectsUsingBlock:^(ZHShareMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //移除不需要展示和未安装的分享平台
            if (![platArray containsObject:@(obj.shareObject.platformType)] || ![ZHShareManager isInstallPlatform:obj.shareObject.platformType]) {
                [array removeObject:obj];
            }
        }];
        return array.copy;
    } else {
        self.filterNotExistPlatform = YES;
        return self.targetShareMenus;
    }
}
//获取安装可用的分享平台
- (NSArray *)getSupportPlatforms {
    NSMutableArray *array = [self getSupportMenus].mutableCopy;
    NSMutableArray *plat = [NSMutableArray arrayWithCapacity:0];
    [array enumerateObjectsUsingBlock:^(ZHShareMenu * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [plat addObject:@(obj.shareObject.platformType)];
    }];
    return plat.copy;
}
//转换成友盟分享内容对象
- (UMSocialMessageObject *)messageObject:(ZHShareObject *)shareObj {
    UMSocialMessageObject *object = [UMSocialMessageObject messageObject];
    if (shareObj.objectType == ShareObjectTypeUnKnown) {
        NSAssert(shareObj.objectType, @"分享内容对象类型，必传");
    }
    switch (shareObj.objectType) {
        case ShareObjectTypeText:
        {
            object.title = shareObj.title;
            object.text = shareObj.content;
        }
            break;
        case ShareObjectTypeImage:
        {
            //只有新浪支持图文分享
            if (shareObj.platformType == SharePlatformTypeSina) {
                object.title = shareObj.title;
                object.text = shareObj.content;
            }
            UMShareImageObject *imageObj = [[UMShareImageObject alloc] init];
            imageObj.thumbImage = shareObj.thumImage;
            imageObj.shareImage = shareObj.image;
            object.shareObject = imageObj;
        }
            break;
        case ShareObjectTypeURL:
        {
            UMShareWebpageObject *webObj = [UMShareWebpageObject shareObjectWithTitle:shareObj.title descr:shareObj.content thumImage:shareObj.thumImage];
            webObj.webpageUrl = shareObj.url;
            object.shareObject = webObj;
        }
            break;
        case ShareObjectTypeMusic:
        {
            UMShareMusicObject *musicObj = [UMShareMusicObject shareObjectWithTitle:shareObj.title descr:shareObj.content thumImage:shareObj.thumImage];
            musicObj.musicUrl = shareObj.url;
            musicObj.musicLowBandUrl = shareObj.lowBandUrl;
            musicObj.musicDataUrl = shareObj.streamDataUrl;
            musicObj.musicLowBandDataUrl = shareObj.lowBandStreamDataUrl;
            object.shareObject = musicObj;
        }
            break;
        case ShareObjectTypeVideo:
        {
            UMShareVideoObject *musicObj = [UMShareVideoObject shareObjectWithTitle:shareObj.title descr:shareObj.content thumImage:shareObj.thumImage];
            musicObj.videoUrl = shareObj.url;
            musicObj.videoLowBandUrl = shareObj.lowBandUrl;
            musicObj.videoStreamUrl = shareObj.streamDataUrl;
            musicObj.videoLowBandStreamUrl = shareObj.lowBandStreamDataUrl;
            object.shareObject = musicObj;
        }
            break;
        default:
            break;
    }
    return object;
}

@end
