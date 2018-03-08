## 1.Overview v2.0.2
### 1.1 Introduction
This guide is designed for developers who are going to integrate the ZPLAY Ads SDK into their iOS Apps via Xcode.  Please contact support@zplayads.com if you need any assistance in this work.
### 1.2 Develop Environment
- OS: Mac OS X10.8.5 and above
- Development environment: Xcode7 and above
- Deploy Target: iOS8 and above
### 1.3 ZPLAY Ads Account Requirements
An account is required on our platform before SDK integration can be completed.  The following App specific data items are the minimum needed to proceed.

**APPID**: An ID for your App, obtained when setting up the App for monetization within your account on the ZPLAY Ads platform website.

**adUnitID**: An ID for a specific ad placement within your App, as generated for your Apps within your account on the ZPLAY Ads platform website. 
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
pod 'PlayableAds', '~>2.0.2'
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
Note: You can use the following test id when you are testing. Test id won't generate revenue, please use official id when you release your App.

|OS|Ad_type|  App_ID  |  Ad_Unit_ID|
|--------|----------|--------|------------|
|iOS|Rewarded video|A650AB0D-7BFC-2A81-3066-D3170947C3DA|BAE5DAAC-04A2-2591-D5B0-38FA846E45E7|
|iOS|Intertitial|A650AB0D-7BFC-2A81-3066-D3170947C3DA|0868EBC0-7768-40CA-4226-F9924221C8EB|

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
### 3.3 Ad ready for display?
You can judge the availability of an ad by this callback.  Then you’ll be able to manage your game’s settings according to the ad being ready or not.
```objective-c
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"playable ads did load");
}
```
### 3.4 Obtain rewards
To use ZPLAY Ads as a rewarded ad, it's very important to give the reward properly. To do so, please use the following callback code. Only rewarded video will call this method.

```objective-c
#pragma mark - PlayableAdsDelegate
// Give reward, use this callback to judge if the reward is available.
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
    self.ad = [self createAndLoadPlayableAds];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAdvertising:(UIButton *)sender {
    NSLog(@"request advertising.");
    [self.ad loadAd];
}

- (IBAction)presentAdvertising:(UIButton *)sender {
    [self showAd];
}

// Create an ad and start preloading
- (PlayableAds *)createAndLoadPlayableAds {
    PlayableAds *ad = [[PlayableAds alloc] initWithAdUnitID:@"iOSDemoAdUnit" appID:@"iOSDemoApp" rootViewController:self];
    ad.delegate = self;
    return ad;
}

// Show the ad
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
    NSLog(@"Advertising successfully presented");
}

/// Tells the delegate that succeeded to load ad.
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"Advertising is ready to play.");
}

/// Tells the delegate that failed to load ad.
- (void)playableAds:(PlayableAds *)ads didFailToLoadWithError:(NSError *)error {
    NSLog(@"There was a problem loading advertising: %@", error);
}
@end
```
## 5 Notices
### 5.1 Receiving error 400

Check the project, has the project set a Display Name.
### 5.2 Black screen displayed when showing an ad
There may be a http link in the ad. To remedy, please add following codes in info.plist
```objective-c
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
	<true/>
</dict>
```
### 5.3 Request Ads ASAP
To ensure the ad resource can be successfully loaded, it’s encouraged to request ads as soon as possible.
### 5.4 Request Next Ad
* When an ad is completed or a request fails, the SDK will try to request the next ad automatically. If this request fails, it will retry in 5 seconds.

* If you want to request the next ad manually, you can set ```playableAd.autoload = NO``` to disable auto-request. And this is the default setting.
### 5.5 Interstitial and Rewarded Video
* From v2.0.1, you can choose to act as interstitial or rewarded videos when you apply the ad unit. If you act as interstitials, the ad can be terminated during playing and no rewards will be given. If you act as rewarded videos, the ad can't be terminated during playing, and a reward will be given after completed.
* For interstitials, all the methods are just the same with rewarded videos, except for ```(void)playableAdsDidRewardUser:(PlayableAds *)ads```, which won't be triggered.
