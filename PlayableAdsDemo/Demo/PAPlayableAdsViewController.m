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
#import <PlayableAdsPreviewer/PlayableAdsPreviewer.h>
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>

@interface PAPlayableAdsViewController () <UITextFieldDelegate, PlayableAdsDelegate, QRCodeReaderDelegate>

@property (weak, nonatomic) IBOutlet UITextField *previewTextField;
@property (weak, nonatomic) IBOutlet UITextField *landingPageField;
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *adUnitTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *landingPageBtn;

@property (nonatomic) PlayableAdsPreviewer *previewPlayableAds;
@property (nonatomic) PlayableAds *playableAd;

@end

@implementation PAPlayableAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.isVideo ? @"Video" : @"Interstitial";

    if (!self.isVideo) {
        self.adUnitTextField.text = @"iOSDemoAdUnitInterstitial";
    }

    [self setDelegate];
}

#pragma mark : set delegate
- (void)setDelegate {
    self.previewTextField.delegate = self;
    self.landingPageField.delegate = self;
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

- (void)previewAdWith:(NSString *)adItem {

    NSString *previewContent = [[PADemoUtils shared] removeSpaceAndNewline:adItem];
    if (previewContent.length == 0) {
        [self addLog:@"preview html url or ad_id is nil"];
        return;
    }

    self.previewBtn.enabled = NO;
    self.landingPageBtn.enabled = NO;

    NSURL *validateUrl = [NSURL URLWithString:previewContent];
    __weak typeof(self) weakSelf = self;
    if (validateUrl.host || validateUrl.scheme) { // is html
        [self addLog:@"preview html url ..."];
        [self.previewPlayableAds presentFromRootViewController:self
            withURL:previewContent
            isInterstitial:YES
            isLandingPage:NO
            itunesID:@(1167885749)
            success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.previewBtn.enabled = YES;
                    weakSelf.landingPageBtn.enabled = YES;
                    [weakSelf addLog:@"present html url"];
                });

            }
            dismiss:^{
                [weakSelf addLog:@"dismiss preview ad"];
            }
            failure:^(NSError *_Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.landingPageBtn.enabled = YES;
                    [weakSelf addLog:@"present html url"];
                });
                [weakSelf addLog:@"preview html url failed"];
            }];
        return;
    }

    // is ad id
    [self addLog:@"preview ad id ..."];
    [self.previewPlayableAds presentFromRootViewController:self
        withAdID:previewContent
        success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.previewBtn.enabled = YES;
                weakSelf.landingPageBtn.enabled = YES;
            });
            [weakSelf addLog:@"present ad id"];
        }
        dismiss:^{
            [weakSelf addLog:@"dismiss preview ad"];
        }
        failure:^(NSError *_Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.previewBtn.enabled = YES;
                weakSelf.landingPageBtn.enabled = YES;
            });
            [weakSelf addLog:@"preview ad id failed"];
        }];
}

#pragma mark : IBAction

- (IBAction)previewAction:(UIButton *)sender {

    [self previewAdWith:self.previewTextField.text];
}

- (IBAction)landingPageAction:(UIButton *)sender {

    NSString *landingPageText = [[PADemoUtils shared] removeSpaceAndNewline:self.landingPageField.text];
    if (landingPageText.length == 0) {
        [self addLog:@"preview landing page url is nil"];
        return;
    }

    self.landingPageBtn.enabled = NO;

    NSURL *validateUrl = [NSURL URLWithString:landingPageText];
    __weak typeof(self) weakSelf = self;
    if (validateUrl.host || validateUrl.scheme) { // is html
        [self addLog:@"preview landingPage url ..."];
        [self.previewPlayableAds presentFromRootViewController:self
            withURL:landingPageText
            isInterstitial:YES
            isLandingPage:YES
            itunesID:@(1167885749)
            success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.landingPageBtn.enabled = YES;
                });
                [weakSelf addLog:@"present landingPage "];
            }
            dismiss:^{
                [weakSelf addLog:@"dismiss landingPage"];
            }
            failure:^(NSError *_Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.landingPageBtn.enabled = YES;
                });
                [weakSelf addLog:@"preview landingPage url failed"];
            }];

        return;
    }
    [self addLog:@"landing page url is invalid"];
}
- (IBAction)scanAction:(UIButton *)sender {
    [self addLog:@"scan ad ..."];

    QRCodeReader *reader = [[QRCodeReader alloc] initWithMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]];
    QRCodeReaderViewController *codeVc = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:@"Cancel"
                                                                                            codeReader:reader
                                                                                   startScanningAtLoad:YES
                                                                                showSwitchCameraButton:YES
                                                                                       showTorchButton:YES];
    codeVc.modalPresentationStyle = UIModalPresentationFormSheet;
    codeVc.delegate = self;

    [self presentViewController:codeVc animated:YES completion:nil];
}
- (IBAction)requestAdAction:(UIButton *)sender {
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

    self.playableAd = [[PlayableAds alloc] initWithAdUnitID:adUnitId appID:appId];
    self.playableAd.delegate = self;
    self.playableAd.autoLoad = [util autoLoadAd];
    self.playableAd.channelId = [util channelID];
    
    NSString *requestText = @"request playable ad ";
    if ([util autoLoadAd]) {
        requestText = @"auto request  playable ad ";
    }
    if ([util channelID].length != 0) {
        requestText = [NSString stringWithFormat:@"%@ and channelID is %@",requestText,[util channelID]];
    }
    [self addLog:requestText];

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

#pragma mark : QRCodeReaderDelegate
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    __weak typeof(self) weakSelf = self;
    [reader dismissViewControllerAnimated:YES
                               completion:^{
                                   [weakSelf previewAdWith:result];
                               }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark : getter method
- (PlayableAdsPreviewer *)previewPlayableAds {
    if (!_previewPlayableAds) {
        _previewPlayableAds = [[PlayableAdsPreviewer alloc] init];
    }
    return _previewPlayableAds;
}

@end
