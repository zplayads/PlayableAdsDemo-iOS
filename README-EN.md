## 1.Overview
### 1.1 Introduction
This guide is designed for developers who are going to integrate the ZPLAY Ads SDK into their iOS Apps via Xcode.  Please contact support@zplayads.com if you need any assistance in this work.
### 1.2 Develop Environment
- OS: Mac OS X10.8.5 and above
- Development environment: Xcode7 and above
- Deploy Target: iOS8 and above
### 1.3 ZPLAY Ads Account Requirements
An account is required on our platform before SDK integration can be completed.  The following App specific data items are the minimum needed to proceed.

**APPID**: An ID for your App, obtained when setting up the App for monetization within your account on the ZPLAY Ads website.

**adUnitID**: An ID for a specific ad placement within your App, as generated for your Apps within your account on the ZPLAY Ads website. 
## 2.SDK integration

ZPLAY Ads leverages CocoaPods, as a dependency manager for Objective-C projects, by which you can easily add or update your Playable Ads SDK.  Please follow the steps below to add the SDK.
### 2.1 Install CocoaPods
```sh
sudo gem install cocoapods
```
### 2.2 Create Podfile
In Terminal, switch to the root folder of your iOS project, and create a Podfile there.
```sh
pod init
```
### 2.3 Add Playable Ads SDK into Podfile
```sh
pod 'PlayableAds', '~>1.5.6'
```
### 2.4 Install Playable Ads SDK
```sh
pod install
```
## 3. Access code
### 3.1 Initialize SDK

To pre-load an ad may take several seconds, so it’s recommended to initialize the SDK and load ads as early as possible. When you initialize the SDK, you need to provide your APPID and adUnitID (as previously registered on https://www.zplayads.com/en/index.html) into the relevant places.

```objective-c
@import PlayableAds;

@interface ViewController () <PlayableAdsDelegate>

// Create an ad and start preloading
- (PlayableAds *)createAndLoadPlayableAds {
    PlayableAds *ad = [[PlayableAds alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID" rootViewController:self];
    ad.delegate = self;
    [ad loadAd];
    
    return ad;
}
```

### 3.2 Show Ads

When an ad is ready to display, you can show it using following method.
```objective-c
// show an ad
- (void)showAd {
    // ad is not ready, do nothing
    if (!self.ad.ready) {
        return;
    }
    
    // show the ad
    [self.ad present];
}
```
### 3.3 Ad ready foe display?
You can judge the availability of an ad by this callback.  Then you’ll be able to manage your game’s settings according to the ad being ready or not.
```objective-c
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"playable ads did load");
}
```
### 3.4 Obtain rewards
To use ZPLAY Ads as a rewarded ad, it’s very important to give the reward properly. To do so, please use the following callback code. 

```objective-c
#pragma mark - PlayableAdsDelegate
// Reward users, when you want to reward users, you are available to determine whether the bonus has been realized via this callback.
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"playable ads did reward");
}
```
## 4 Code Sample

```objective-c
#import "ViewController.h"

@import PlayableAds;

@interface ViewController () <PlayableAdsDelegate>

@property (nonatomic) PlayableAds *ad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // preload ad
    self.ad = [self createAndLoadPlayableAds];
}

- (PlayableAds *)createAndLoadPlayableAds {
    PlayableAds *ad = [[PlayableAds alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID" rootViewController:self];
    ad.delegate = self;
    [ad loadAd];
    
    return ad;
}

- (void)showAd {
    // ad is not ready, do nothing
    if (!self.ad.ready) {
        return;
    }
    
    // show the ad
    [self.ad present];
}

#pragma mark - PlayableAdsDelegate
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"playable ads did reward");
}

- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"playable ads did load");
}

- (void)playableAdsDidFailToLoadWithError:(NSError *)error {
    NSLog(@"playable ads did fail to load: %@", error);
    
    // preload ad after previous ad request failed for 5 seconds
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.ad = [weakSelf createAndLoadPlayableAds];
    });
}

- (void)playableAdsWillPresentScreen:(PlayableAds *)ads {
    NSLog(@"playable ads will present screen");
}

- (void)playableAdsDidPresentScreen:(PlayableAds *)ads {
    NSLog(@"playable ads did present screen");
}

- (void)playableAdsDidStartPlaying:(PlayableAds *)ads {
    NSLog(@"playable ads did start playing");
}

- (void)playableAdsDidEndPlaying:(PlayableAds *)ads {
    NSLog(@"playable ads did end playing");
}

- (void)playableAdsDidPresentLandingPage:(PlayableAds *)ads {
    NSLog(@"playable ads did present landing page");
}

- (void)playableAdsWillDismissScreen:(PlayableAds *)ads {
    NSLog(@"playable ads will dismiss screen");
}

- (void)playableAdsDidDismissScreen:(PlayableAds *)ads {
    NSLog(@"playable ads did dismiss screen");
    
    // preload ad right after previous ad is dismissed
    self.ad = [self createAndLoadPlayableAds];
}

- (void)playableAdsLandingPageDidClick:(PlayableAds *)ads {
    NSLog(@"playable ads landing page did click");
}

- (void)playableAdsWillLeaveApplication:(PlayableAds *)ads {
    NSLog(@"playable ads will leave application");
}

@end
```
## 5 Notices
### 5.1 Receiving error 400
Check if the Display Name of your project is set properly.
### 5.2 Black screen displayed when showing an ad
There may be a http link in the ad. To remedy, please add following codes in info.plist
```objective-c
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```
