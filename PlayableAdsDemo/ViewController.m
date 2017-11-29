//
//  ViewController.m
//  PlayableAdsDemo
//
//  Created by lgd on 2017/11/6.
//  Copyright © 2017年 lgd. All rights reserved.
//

#import "ViewController.h"

@import PlayableAds;

@interface ViewController () <PlayableAdsDelegate>

@property (nonatomic) PlayableAds *ad;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.ad = [self createAndLoadPlayableAds];
    [_logLabel sizeToFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAdvertising:(UIButton *)sender {
    [self addLog:@"request advertising."];
    [self.ad loadAd];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (IBAction)presentAdvertising:(UIButton *)sender {
    [self showAd];
}

- (void) addLog: (NSString*) log {
    NSString *newLineLog = [log stringByAppendingString:@"\n"];
    _logLabel.text = [newLineLog stringByAppendingString: _logLabel.text];
}

// 创建广告并加载
- (PlayableAds *)createAndLoadPlayableAds {
    PlayableAds *ad = [[PlayableAds alloc] initWithAdUnitID:@"iOSDemoAdUnit" appID:@"iOSDemoApp"];
    ad.delegate = self;
    return ad;
}

// 展示广告
- (void)showAd {
    // ad is not ready, do nothing
    if (!self.ad.ready) {
        [self addLog:@"advertising has not ready."];
        return;
    }
    
    [self addLog:@"show advertising"];
    // show the ad
    [self.ad present];
}

#pragma mark - PlayableAdsDelegate
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    [self addLog:@"Advertising successfully presented"];
}

/// Tells the delegate that succeeded to load ad.
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self addLog:@"Advertising is ready to play."];
}

/// Tells the delegate that failed to load ad.
- (void)playableAds:(PlayableAds *)ads didFailToLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self addLog: [@"\nThere was a problem loading advertising:" stringByAppendingString:[error localizedDescription] ]];
    NSLog(@"playableAds error:\n%@", error);
}

@end
