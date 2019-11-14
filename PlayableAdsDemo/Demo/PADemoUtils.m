//
//  PADemoUtils.m
//  PlayableAds_Example
//
//  Created by lgd on 2018/4/18.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PADemoUtils.h"
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_LESS_THAN(v)                                                                                    \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation PAAdConfigInfo

@end

@interface PADemoUtils () {
    NSString *_channelID;
}
@property (nonatomic) NSFileManager *fm;
@property (nonatomic, assign) BOOL autoAd;
@property (nonatomic) NSString *channelID;

@property (nonatomic) NSMutableDictionary<NSString *, PAAdConfigInfo *> *allAdInfo;

@end

@implementation PADemoUtils

+ (instancetype)shared {
    static PADemoUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        self.fm = [NSFileManager defaultManager];
    }
    return self;
}

- (NSURL *)baseDirectoryURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cacheDirectoryURL = [fileManager URLForDirectory:NSCachesDirectory
                                                   inDomain:NSUserDomainMask
                                          appropriateForURL:nil
                                                     create:NO
                                                      error:nil];
    // 10.0以下使用tmp的目录做缓存，因为WKWebview在10.0以下只能加载tmp的资源
    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        cacheDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    }

    return [cacheDirectoryURL URLByAppendingPathComponent:@"PlayableAdsCache" isDirectory:YES];
}

- (BOOL)createTagFile {
    NSURL *baseDir = [self baseDirectoryURL];
    BOOL dirExist = [self.fm fileExistsAtPath:[baseDir absoluteString]];
    if (!dirExist) {
        NSError *error;
        BOOL successful =
            [self.fm createDirectoryAtURL:baseDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (successful) {
            return
                [self.fm createFileAtPath:[baseDir.path stringByAppendingString:@"/zpta"] contents:nil attributes:nil];
        }
    }
    return NO;
}

- (BOOL)removeTagFile {
    return [self.fm removeItemAtPath:[[[self baseDirectoryURL] path] stringByAppendingString:@"/zpta"] error:NULL];
}

- (BOOL)tagFileExsit {
    BOOL exist = [self.fm fileExistsAtPath:[[[self baseDirectoryURL] path] stringByAppendingString:@"/zpta"]];
    return exist;
}

- (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return text;
}

- (void)setAutoLoadAd:(BOOL)isAuto {
    self.autoAd = isAuto;
}

- (BOOL)autoLoadAd {
    return self.autoAd;
}

- (void)setChannelID:(NSString *)channelID {
    _channelID = channelID;
}

- (NSString *)channelID {
    return _channelID;
}

#pragma mark : - ad config

- (void)saveAdInfo:(PAAdConfigInfo *)adConfig {
    if (!adConfig) {
        return;
    }
    NSString *key = [self generateAdkey:adConfig.adType];
    [self.allAdInfo setValue:adConfig forKey:key];
}
- (PAAdConfigInfo *)getAdInfo:(kZplayAdsType)adType {
    NSString *key = [self generateAdkey:adType];

    return self.allAdInfo[key];
}

- (NSString *)generateAdkey:(kZplayAdsType)adType {

    return [NSString stringWithFormat:@"adType_%lu", (unsigned long)adType];
}

- (NSMutableDictionary<NSString *, PAAdConfigInfo *> *)allAdInfo {
    if (!_allAdInfo) {
        _allAdInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return _allAdInfo;
}

@end
