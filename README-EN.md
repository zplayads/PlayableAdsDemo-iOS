## 1. Overview
### 1.1 Introduction
This guide is designed for the developers who are going to integrate ZPLAY Ads SDK into their Xcode project.
### 1.2 Develop Environment
- OS: Mac OS X10.8.5 and above
- Development environment: Xcode7 and above
- Deployment Target: iOS8 and above

### 1.3 Terms

**APPID**: ID for your Application, obtained when setting up the app within your account on ZPLAY Ads platform.

**adUnitID**: ID for a specific ad placement within your App, as generated for your Apps within your account on ZPLAY Ads platform.  
## 2.SDK Integration
### 2.1 CocoaPods(recommended)
#### 2.1.1 Install CocoaPods 
```sh
sudo gem install cocoapods
```
#### 2.1.2 Switch terminal to root directory of iOS project, create podfile.
```sh
pod init
```
#### 2.1.3 Add ZPLAY Ads SDK into Podfile
```sh
pod 'PlayableAds'
```
#### 2.1.4 Install ZPLAY Ads SDK
```sh
pod install
```
### 2.2 Manual integration
#### 2.2.1 Download ZPLAY Ads SDK
Download ZPLAY Ads SDK [**HERE**](https://github.com/zplayads/PlayableAdsDemo-iOS/tree/master/sdk-framework). When completed, please unzip .zip file to obtain PlayableAds.framework.
#### 2.2.2 Add to project
Add the PlayableAds.framework you obtained in 2.2.1 to project.![图片](./tutorialImg/manual-add-files.png)
![图片](./tutorialImg/manual-add-files2.png)
#### 2.2.3 Add the dependencies of ZPLAY Ads
The dependency frameworks of ZPLAY Ads consist of UIKit, Foundation, WebKit, SystemConfiguration, MobileCoreServices, AdSupport, CoreLocation, CoreTelephony, StoreKit, Security.

The dependency libraries of ZPLAY Ads is xml2.

After importing: ![图片](./tutorialImg/manual-add-framework-libs.png)
#### 2.2.4 Others
Find Build Settings page in the project, add $(SDKROOT)/usr/include/libxml2 into Header Search Paths under Search Paths, and add -ObjC into Other Linker Flags under Linking.
![图片](./tutorialImg/manual-add-header-search-paths.png)
![图片](./tutorialImg/manual-add-other-linker-flags.png)

## 3. Access code

### 3.1 Rewarded Video/Intertitial Ad

#### 3.1.1 Initialize Video/Intertitial

Initialize ZPLAY Ads, show ad.
> To pre-load an ad may take several seconds, so it’s recommended to initialize the SDK and load ads as early as possible. Please fill in the APPID and adUnitID you obtained on ZPLAY Ads platform When initializing the SDK.


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
Note: You can use the following test ID when testing. Test ID won't generate any revenue, please use official ID when you release your App.

| OS   | Ad_type                     | App_ID                               | Ad_Unit_ID                           |
| ---- | --------------------------- | ------------------------------------ | ------------------------------------ |
| iOS  | Rewarded video              | A650AB0D-7BFC-2A81-3066-D3170947C3DA | BAE5DAAC-04A2-2591-D5B0-38FA846E45E7 |
| iOS  | Intertitial                 | A650AB0D-7BFC-2A81-3066-D3170947C3DA | 0868EBC0-7768-40CA-4226-F9924221C8EB |
| iOS  | Native Managed Rendering    | A650AB0D-7BFC-2A81-3066-D3170947C3DA | DC9E199C-7C0B-FBFC-7E5A-26E7B5EE6BB3 |
| iOS  | Native Self Rendering       | A650AB0D-7BFC-2A81-3066-D3170947C3DA | 25AED008-6B6F-BADB-F873-AE7CA61DFE98 |

#### 3.1.2 Show Ads

When an ad is ready to display, you can play it using following method:
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
#### 3.1.3 Determine Whether an Add Has Been Loaded

You can determine the availability of an ad via this callback. 
> You are available to determine in-game settings via the following method.
```objective-c
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"playable ads did load");
}
```
#### 3.1.4 Obtain Reward
You are available to realize this callback to reward users, only valid for rewarded video.
> When using ZPLAY Ads to show rewarded video, you should reward those who has completed watching the video already via this callback.


```objective-c
#pragma mark - PlayableAdsDelegate
// Give reward, use this callback to judge whether the reward is available.
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"playable ads did reward");
}
```

#### 3.1.5 Request Next Ad

- The SDK will request the next ad automatically when an ad has been completed or request failure. If auto-loading fails, it will retry in 30 seconds.

- If you want to request the next ad manually, please set ```playableAd.autoload = NO``` to disable auto-loading. Auto-loading is the default setting.


#### 3.1.6 Ad State Callback from PlayableAdsDelegate 

```objective-c
#pragma mark - PlayableAdsDelegate
/// video ad. Use this callback to judge whether the reward is available.   
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"Advertising successfully presented");
}
/// succeed to load ad, return object PlayableAds.
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"Advertising is ready to play.");
}
/// fail to load ad
- (void)playableAds:(PlayableAds *)ads didFailToLoadWithError:(NSError *)error {
    NSLog(@"There was a problem loading advertising: %@", error);
}
/// video started playing 
- (void)playableAdsDidStartPlaying:(PlayableAds *)ads{
   NSLog(@"Advertising start playing");
}
/// video ended playing 
- (void)playableAdsDidEndPlaying:(PlayableAds *)ads{
  NSLog(@"Advertising did end playing");
}
/// landingpage presented 
- (void)playableAdsDidPresentLandingPage:(PlayableAds *)ads{
  NSLog(@"Advertising start playing");
}
/// landingpage dismissed 
- (void)playableAdsDidDismissScreen:(PlayableAds *)ads{
  NSLog(@"Advertising did dismiss screen");
}
/// ad has been clicked
- (void)playableAdsDidClick:(PlayableAds *)ads{
  NSLog(@"Advertising did clicked");
}
```

### 3.2 Access Native Ad (Managed Rendering)

> Managed rendering is a rendering mode of native ad. In this mode, ad will be rendered automatically. This approach simplifies the process of accessing native ad, and you can access native ad more convient since you do not need to deal with ad rendering related issues.

#### 3.2.1 Initialize nativeExpressAd

a. Import header files in your own ViewController. For example:

```objective-c
@interface PANativeExpressAdViewController () <PANativeExpressAdDelegate>

@property (nonatomic) PANativeExpressAd *nativeExpressAd;

@end
```

b. Initialize nativeExpressAd, get ad, and set callback.

```objective-c
CGFloat width = [UIScreen mainScreen].bounds.size.width;
// adSize (size of adUnit) is set by you，SDK will return an adview which suits for the adSize
self.nativeExpressAd =
        [[PANativeExpressAd alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID" adSize:CGSizeMake(width, 300)];
self.nativeExpressAd.delegate = self;
```

#### 3.2.2 Load Native Ad

```objective-c
[self.nativeExpressAd loadAd];
```

#### 3.2.3 Render and Display

You need to check callback state in nativeExpressAd. If the state is successful, a PANativeExpressAdView type object will be returned. You can call ```addSubview：``` method to display ads in proper place. 

> When you display ads, you need to call ```reportImpressionNativeExpressAd``` method to notify ZPLAY Ads that ad has been displayed.

#### 3.2.4 Load State Callback and Click Callback

PANativeExpressAdDelegate provides load state callback and click callback. You can judge whether ad has been loaded and whether ad has been clicked. 

```objective-c
/// Native ad (managed rendering) loading succeeded. Return object PANtiveExpressAdView
- (void)playableNativeExpressAdDidLoad:(PANativeExpressAdView *)nativeExpressAd{
  
}
/// Native ad (managed rendering) loading failed. Return error messages
- (void)playableNativeExpressAdDidFailWithError:(NSError *)error{
  
}
/// Native ad (managed rendering) has been clicked
- (void)playableNativeExpressAdDidClick:(PANativeExpressAdView *)nativeExpressAd{
  
}
```

### 3.3 Access Native Ad (Self Rendering)

> Self rendering is another rendering mode, which has high flexibility, of native ad. You can splice ad style according to your needs to make ad more suitable for your app.  

#### 3.3.1 Initialize nativeAd

a. Import header files in your own ViewController. For example:

```objective-c
@interface PAShowNativeAdViewController () <PANativeAdDelegate>

@property (nonatomic) PANativeAd *nativeAd;

@end
```

b. Initialize nativeAd, get ad, and set callback.

```objective-c
self.nativeAd = [[PANativeAd alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID"];
self.nativeAd.delegate = self;
```

#### 3.3.2 Load Native Ad

```objective-c
[self.nativeAd loadAd];
```

#### 3.3.3 Render and Display

You need to check callback state in nativeAd. If the state is successful, a PANativeAdModel type object will be returned. Then, you need to render ad in proper time and display the ad.

> Attention:
- When the ad has been rendered and displayed, you need to notify ZPLAY Ads by calling ```reportImpression:view:``` method. 
- Call ```registerViewForInteraction: nativeAd:``` method to relate PANativeAd and UIView (view you used to display native ad). Please ensure related view ```view.userInteractionEnabled = YES;``` . 


#### 3.3.4 Load State Callback and Click Callback

PANativeAdDelegate provides load state callback and click callback. You can judge whether ad has been loaded and whether ad has been clicked. 

```objective-c
/// Native ad (self rendering) loading succeeded. Return object PANativeAdModel
- (void)playableNativeAdDidLoad:(PANativeAdModel *)nativeAd{
  
}
/// Native ad (self rendering) loading failed. Return error object
- (void)playableNativeAdDidFailWithError:(NSError *)error{
  
}
/// Click callback of native ad (self rendering)
- (void)playableNativeAdDidClick:(PANativeAdModel *)nativeAd{
  
}
```

## 4 Considerations
### 4.1 Error 400

Check whether the project has been set a Display Name.

### 4.2 Black screen when showing an ad
There may be a http link in the ad. You can add the following codes in info.plist:
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```
### 4.3 Request Ads ASAP
To ensure the ad can be loaded successfully, you are suggested to request ads ASAP.


### 4.4 Interstitial and Rewarded Video
* From v2.0.3, you can choose to act as interstitial or rewarded video when applying for ad unit. If interstitial, the ad can be terminated during playing and no rewards will be given. If rewarded video, the ad can't be terminated during playing, and a reward will be given after playing.
* Except```- (void)playableAdsDidRewardUser:(PlayableAds *)ads```, which will not be triggered, all call and callback methods of interstitial are the same as those of rewarded video. 
