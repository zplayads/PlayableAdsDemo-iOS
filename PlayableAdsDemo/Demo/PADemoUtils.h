//
//  PADemoUtils.h
//  PlayableAds_Example
//
//  Created by lgd on 2018/4/18.
//  Copyright © 2018年 on99. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kZplayAdsType_interstitial = 1 << 1,
    kZplayAdsType_native,
    kZplayAdsType_nativeExpress,
    kZplayAdsType_video,
} kZplayAdsType;

@interface PAAdConfigInfo : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *placementId;
@property (nonatomic) kZplayAdsType adType;

@end

@interface PADemoUtils : NSObject

+ (instancetype)shared;

- (BOOL)createTagFile;
- (BOOL)removeTagFile;
- (BOOL)tagFileExsit;
- (NSURL *)baseDirectoryURL;
- (NSString *)removeSpaceAndNewline:(NSString *)str;
// auto load ad
- (void)setAutoLoadAd:(BOOL)isAuto;
- (BOOL)autoLoadAd;

// channelID
- (void)setChannelID:(NSString *)channelID;
- (NSString *)channelID;

- (void)saveAdInfo:(PAAdConfigInfo *)adConfig;
- (PAAdConfigInfo *)getAdInfo:(kZplayAdsType)adType;

@end
