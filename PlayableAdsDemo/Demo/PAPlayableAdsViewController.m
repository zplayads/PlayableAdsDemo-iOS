//
//  PAPlayableAdsViewController.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/20.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAPlayableAdsViewController.h"
#import "PADemoUtils.h"
#import <PlayableAds/PlayableAds.h>

@interface PAPlayableAdsViewController () <UITextFieldDelegate, PlayableAdsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *adUnitTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (nonatomic) PlayableAds *playableAd;

@end

@implementation PAPlayableAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.isVideo ? @"Video" : @"Interstitial";

    if (!self.isVideo) {
        self.adUnitTextField.text = @"0868EBC0-7768-40CA-4226-F9924221C8EB";
    }

    [self setDelegate];

    [self setVauleToTextField];
}

- (void)setVauleToTextField {

    kZplayAdsType adType = self.isVideo ? kZplayAdsType_video : kZplayAdsType_interstitial;
    PAAdConfigInfo *adConfig = [[PADemoUtils shared] getAdInfo:adType];
    if (!adConfig) {
        [self saveValueToConfig];
        return;
    }

    self.appIdTextField.text = adConfig.appId;
    self.adUnitTextField.text = adConfig.placementId;
}

- (void)saveValueToConfig {
    PAAdConfigInfo *adConfig = [[PAAdConfigInfo alloc] init];
    adConfig.adType = self.isVideo ? kZplayAdsType_video : kZplayAdsType_interstitial;
    ;
    adConfig.appId = self.appIdTextField.text;
    adConfig.placementId = self.adUnitTextField.text;

    [[PADemoUtils shared] saveAdInfo:adConfig];
}

#pragma mark : set delegate
- (void)setDelegate {
    self.appIdTextField.delegate = self;
    self.adUnitTextField.delegate = self;
}

- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.logTextView.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.logTextView.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.logTextView scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.logTextView.text = text;
    });
}

#pragma mark : IBAction
- (IBAction)initAdAction:(UIButton *)sender {
    NSString *appId = [[PADemoUtils shared] removeSpaceAndNewline:self.appIdTextField.text];
    NSString *adUnitId = [[PADemoUtils shared] removeSpaceAndNewline:self.adUnitTextField.text];

    if (appId.length == 0) {
        [self addLog:@"app id  is nil"];
        return;
    }
    if (adUnitId.length == 0) {
        [self addLog:@"ad unit id  is nil"];
        return;
    }
    PADemoUtils *util = [PADemoUtils shared];

    [self saveValueToConfig];

    self.playableAd = [[PlayableAds alloc] initWithAdUnitID:adUnitId appID:appId];
    self.playableAd.delegate = self;
    self.playableAd.autoLoad = [util autoLoadAd];
    self.playableAd.channelId = [util channelID];

    NSString *requestText = @"init playable ad ";
    if ([util autoLoadAd]) {
        requestText = @"auto init  playable ad ";
    }
    if ([util channelID].length != 0) {
        requestText = [NSString stringWithFormat:@"%@ and channelID is %@", requestText, [util channelID]];
    }
    [self addLog:requestText];
}

- (IBAction)requestAdAction:(UIButton *)sender {

    if (!self.playableAd) {
        [self addLog:@"please init playable ad "];
        return;
    }
    [self addLog:@"load playable ad "];
    [self.playableAd loadAd];
}
- (IBAction)presentAdAction:(UIButton *)sender {
    if (!self.playableAd) {
        [self addLog:@"playableAd is nil"];
        return;
    }

    if (!self.playableAd.isReady) {
        [self addLog:@"playableAd is not ready"];
        return;
    }
    [self.playableAd present];
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark : PlayableAdsDelegate
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    [self addLog:@"playableAds did reward user"];
}
/// Tells the delegate that succeeded to load ad.
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    [self addLog:@"playableAds did load"];
}
/// Tells the delegate that failed to load ad.
- (void)playableAds:(PlayableAds *)ads didFailToLoadWithError:(NSError *)error {
    NSString *logText = [NSString stringWithFormat:@"playableAds did  load fail,error is==> %@", [error description]];
    [self addLog:logText];
}
/// Tells the delegate that user starts playing the ad.
- (void)playableAdsDidStartPlaying:(PlayableAds *)ads {
    [self addLog:@"playableAds did  start playing"];
}
/// Tells the delegate that the ad is being fully played.
- (void)playableAdsDidEndPlaying:(PlayableAds *)ads {
    [self addLog:@"playableAds did end playing"];
}
/// Tells the delegate that the landing page did present on the screen.
- (void)playableAdsDidPresentLandingPage:(PlayableAds *)ads {
    [self addLog:@"playableAds did present landing page"];
}
/// Tells the delegate that the ad did animate off the screen.
- (void)playableAdsDidDismissScreen:(PlayableAds *)ads {
    [self addLog:@"playableAds did dismiss screen"];
}
/// Tells the delegate that the ad is clicked
- (void)playableAdsDidClick:(PlayableAds *)ads {
    [self addLog:@"playableAds did click"];
}

@end
