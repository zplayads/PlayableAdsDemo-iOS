- [1.概述](#1%e6%a6%82%e8%bf%b0)
  - [1.1 面向读者](#11-%e9%9d%a2%e5%90%91%e8%af%bb%e8%80%85)
  - [1.2 开发环境](#12-%e5%bc%80%e5%8f%91%e7%8e%af%e5%a2%83)
  - [1.3 术语介绍](#13-%e6%9c%af%e8%af%ad%e4%bb%8b%e7%bb%8d)
- [2.SDK接入](#2sdk%e6%8e%a5%e5%85%a5)
  - [2.1 CocoaPods(推荐)](#21-cocoapods%e6%8e%a8%e8%8d%90)
    - [2.1.1 安装CocoaPods/Install Cocoapods](#211-%e5%ae%89%e8%a3%85cocoapodsinstall-cocoapods)
    - [2.1.2 从终端切换至iOS项目根目录下，创建Podfile文件](#212-%e4%bb%8e%e7%bb%88%e7%ab%af%e5%88%87%e6%8d%a2%e8%87%b3ios%e9%a1%b9%e7%9b%ae%e6%a0%b9%e7%9b%ae%e5%bd%95%e4%b8%8b%e5%88%9b%e5%bb%bapodfile%e6%96%87%e4%bb%b6)
    - [2.1.3 将ZPLAY Ads SDK加入到Podfile文件](#213-%e5%b0%86zplay-ads-sdk%e5%8a%a0%e5%85%a5%e5%88%b0podfile%e6%96%87%e4%bb%b6)
    - [2.1.4 安装ZPLAY Ads SDK](#214-%e5%ae%89%e8%a3%85zplay-ads-sdk)
  - [2.2 手动集成ZPLAY Ads SDK](#22-%e6%89%8b%e5%8a%a8%e9%9b%86%e6%88%90zplay-ads-sdk)
    - [2.2.1 下载ZPLAY Ads sdk](#221-%e4%b8%8b%e8%bd%bdzplay-ads-sdk)
    - [2.2.2 添加到工程](#222-%e6%b7%bb%e5%8a%a0%e5%88%b0%e5%b7%a5%e7%a8%8b)
    - [2.2.3 添加ZPLAY Ads的依赖文件](#223-%e6%b7%bb%e5%8a%a0zplay-ads%e7%9a%84%e4%be%9d%e8%b5%96%e6%96%87%e4%bb%b6)
    - [2.2.4 其它设置](#224-%e5%85%b6%e5%ae%83%e8%ae%be%e7%bd%ae)
- [3.接入代码](#3%e6%8e%a5%e5%85%a5%e4%bb%a3%e7%a0%81)
  - [3.1 激励视频/插屏广告](#31-%e6%bf%80%e5%8a%b1%e8%a7%86%e9%a2%91%e6%8f%92%e5%b1%8f%e5%b9%bf%e5%91%8a)
    - [3.1.1 初始化视频/插屏](#311-%e5%88%9d%e5%a7%8b%e5%8c%96%e8%a7%86%e9%a2%91%e6%8f%92%e5%b1%8f)
    - [3.1.2 展示广告](#312-%e5%b1%95%e7%a4%ba%e5%b9%bf%e5%91%8a)
    - [3.1.3 判断广告是否加载完成](#313-%e5%88%a4%e6%96%ad%e5%b9%bf%e5%91%8a%e6%98%af%e5%90%a6%e5%8a%a0%e8%bd%bd%e5%ae%8c%e6%88%90)
    - [3.1.4 获取奖励](#314-%e8%8e%b7%e5%8f%96%e5%a5%96%e5%8a%b1)
    - [3.1.5 请求下一条广告](#315-%e8%af%b7%e6%b1%82%e4%b8%8b%e4%b8%80%e6%9d%a1%e5%b9%bf%e5%91%8a)
    - [3.1.6 PlayableAdsDelegate返回广告状态的回调](#316-playableadsdelegate%e8%bf%94%e5%9b%9e%e5%b9%bf%e5%91%8a%e7%8a%b6%e6%80%81%e7%9a%84%e5%9b%9e%e8%b0%83)
  - [3.2 原生广告(托管渲染)接入代码](#32-%e5%8e%9f%e7%94%9f%e5%b9%bf%e5%91%8a%e6%89%98%e7%ae%a1%e6%b8%b2%e6%9f%93%e6%8e%a5%e5%85%a5%e4%bb%a3%e7%a0%81)
    - [3.2.1 初始化nativeExpressAd](#321-%e5%88%9d%e5%a7%8b%e5%8c%96nativeexpressad)
    - [3.2.2 加载原生广告](#322-%e5%8a%a0%e8%bd%bd%e5%8e%9f%e7%94%9f%e5%b9%bf%e5%91%8a)
    - [3.2.3 渲染曝光](#323-%e6%b8%b2%e6%9f%93%e6%9b%9d%e5%85%89)
    - [3.2.4 广告拉取状态及点击回调](#324-%e5%b9%bf%e5%91%8a%e6%8b%89%e5%8f%96%e7%8a%b6%e6%80%81%e5%8f%8a%e7%82%b9%e5%87%bb%e5%9b%9e%e8%b0%83)
  - [3.3 原生广告(自渲染)接入代码](#33-%e5%8e%9f%e7%94%9f%e5%b9%bf%e5%91%8a%e8%87%aa%e6%b8%b2%e6%9f%93%e6%8e%a5%e5%85%a5%e4%bb%a3%e7%a0%81)
    - [3.3.1 初始化nativeAd](#331-%e5%88%9d%e5%a7%8b%e5%8c%96nativead)
    - [3.3.2 加载原生广告](#332-%e5%8a%a0%e8%bd%bd%e5%8e%9f%e7%94%9f%e5%b9%bf%e5%91%8a)
    - [3.3.3 渲染曝光](#333-%e6%b8%b2%e6%9f%93%e6%9b%9d%e5%85%89)
    - [3.3.4 广告拉取状态及点击回调](#334-%e5%b9%bf%e5%91%8a%e6%8b%89%e5%8f%96%e7%8a%b6%e6%80%81%e5%8f%8a%e7%82%b9%e5%87%bb%e5%9b%9e%e8%b0%83)
  - [3.4 Banner 接入代码](#34-banner-%e6%8e%a5%e5%85%a5%e4%bb%a3%e7%a0%81)
    - [3.4.1 初始化 Banner](#341-%e5%88%9d%e5%a7%8b%e5%8c%96-banner)
    - [3.4.2 请求 Banner](#342-%e8%af%b7%e6%b1%82-banner)
    - [3.4.3 实现代理方法及展示](#343-%e5%ae%9e%e7%8e%b0%e4%bb%a3%e7%90%86%e6%96%b9%e6%b3%95%e5%8f%8a%e5%b1%95%e7%a4%ba)
    - [3.4.4 销毁 Banner](#344-%e9%94%80%e6%af%81-banner)
- [4 注意事项](#4-%e6%b3%a8%e6%84%8f%e4%ba%8b%e9%a1%b9)
  - [4.1 请求广告返回400错误](#41-%e8%af%b7%e6%b1%82%e5%b9%bf%e5%91%8a%e8%bf%94%e5%9b%9e400%e9%94%99%e8%af%af)
  - [4.2 展示广告时出现黑屏](#42-%e5%b1%95%e7%a4%ba%e5%b9%bf%e5%91%8a%e6%97%b6%e5%87%ba%e7%8e%b0%e9%bb%91%e5%b1%8f)
  - [4.3 尽早请求广告](#43-%e5%b0%bd%e6%97%a9%e8%af%b7%e6%b1%82%e5%b9%bf%e5%91%8a)
  - [4.4 插屏广告与激励视频广告](#44-%e6%8f%92%e5%b1%8f%e5%b9%bf%e5%91%8a%e4%b8%8e%e6%bf%80%e5%8a%b1%e8%a7%86%e9%a2%91%e5%b9%bf%e5%91%8a)
  - [4.5 GDPR](#45-gdpr)
    - [设置GDPR](#%e8%ae%be%e7%bd%aegdpr)
- [5 测试](#5-%e6%b5%8b%e8%af%95)


## 1.概述

### 1.1 面向读者
本产品面向需要在Xcode工程中接入ZPLAY Ads SDK的开发人员。
### 1.2 开发环境
- 操作系统：Mac OS X10.8.5版本及以上
- 开发环境：Xcode7及以上版本
- 部署目标：iOS8及以上

### 1.3 术语介绍
**APPID**：应用ID，是您在ZPLAY Ads平台创建媒体时获取的ID;

**adUnitID**：广告位ID，是您在ZPLAY Ads告平台为您的应用创建的广告位置的ID。
## 2.SDK接入

ZPLAY Ads提供两种接入方式，您可以在2.1与2.2中选择一种接入方式。

### 2.1 [CocoaPods](https://guides.cocoapods.org/using/getting-started)(推荐)
#### 2.1.1 安装CocoaPods/Install Cocoapods

```sh
sudo gem install cocoapods
```
#### 2.1.2 从终端切换至iOS项目根目录下，创建Podfile文件

```sh
pod init
```
#### 2.1.3 将ZPLAY Ads SDK加入到Podfile文件

```sh
pod 'PlayableAds'
```
#### 2.1.4 安装ZPLAY Ads SDK

```sh
pod install
```

如果您第一次使用Cocoapods，请参考他们的[官方文档](https://guides.cocoapods.org/using/using-cocoapods)，了解如何创建和使用Podfiles.

### 2.2 手动集成ZPLAY Ads SDK

#### 2.2.1 下载ZPLAY Ads sdk 
在[**此处**](https://github.com/zplayads/PlayableAdsDemo-iOS/tree/master/sdk-framework)可以下载到ZPLAY Ads SDK，下载完成后解压.zip文件可得到 PlayableAds 文件
#### 2.2.2 添加到工程
将上一步得到的 PlayableAds 文件添加到项目中 ![图片](./tutorialImg/manual-add-files.png)
![图片](./tutorialImg/manual-add-files2.png)

#### 2.2.3 添加ZPLAY Ads的依赖文件
ZPLAY Ads依赖的framework有：UIKit, Foundation, WebKit, SystemConfiguration, MobileCoreServices, AdSupport, CoreTelephony, StoreKit, Security。

ZPLAY Ads依赖的libraries有：xml2.

导入后如图所示：![图片](./tutorialImg/manual-add-framework-libs.png)
#### 2.2.4 其它设置
在项目中找到Build Settings页面，在Search Paths下的Header Search Paths下添加 $(SDKROOT)/usr/include/libxml2 ， 在Linking下的Other Linker Flags中添加 -ObjC 
![图片](./tutorialImg/manual-add-header-search-paths.png)
![图片](./tutorialImg/manual-add-other-linker-flags.png)
## 3.接入代码

### 3.1 激励视频/插屏广告

#### 3.1.1 初始化视频/插屏

初始化ZPLAY Ads广告，获取广告，设置回调
> 广告预加载需要几秒时间，建议您在应用启动后尽早初始化及加载ZPLAY Ads广告。初始化SDK时需要将您在ZPLAY Ads平台申请的AppID和AdUnitID填入相应的位置


```objective-c

@import PlayableAds;

@interface ViewController () <PlayableAdsDelegate>

// 创建广告并加载
- (PlayableAds *)createAndLoadPlayableAds {
PlayableAds *ad = [[PlayableAds alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID"];
ad.delegate = self;
[ad loadAd];

return ad;
}
```

#### 3.1.2 展示广告

当广告已经准备就绪后，您可以使用以下方法播放广告：
```objective-c
// 展示广告
- (void)showAd {
    // ad is not ready, do nothing
    if (!self.ad.ready) {
        return;
    }

    // show the ad
    [self.ad present];
}
```
#### 3.1.3 判断广告是否加载完成

您可以通过此回调判断是否有广告可以播放。
> 可通过此方法进行游戏内设置的判断。

```objective-c
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"playable ads did load");
}
```
#### 3.1.4 获取奖励

视频奖励，您可以实现此回调给用户下发奖励，仅激励视频会有此回调。
> 当您在激励视频广告位上使用ZPLAY Ads时，最重要的是奖励看完广告的用户，要奖励用户请实现此回调。

```objective-c
#pragma mark - PlayableAdsDelegate
// 奖励用户，当您需要给用户激励时，可使用此回调判断是否有奖励下发。
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"playable ads did reward");
}
```
#### 3.1.5 请求下一条广告

- 广告展示完成或请求失败时会自动加载下一条广告，如果自动加载失败会在30s后重试。
- 若您需要手动加载下一条广告，可将通过```playableAd.autoload = NO```来设置SDK不自动加载下一条广告。默认为自动加载。

#### 3.1.6 PlayableAdsDelegate返回广告状态的回调

```objective-c
#pragma mark - PlayableAdsDelegate
/// 视频广告，当您需要给用户激励时，可使用此回调判断是否有奖励下发。
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
    NSLog(@"Advertising successfully presented");
}
/// 广告加载完成，返回PlayableAds对象
- (void)playableAdsDidLoad:(PlayableAds *)ads {
    NSLog(@"Advertising is ready to play.");
}
/// 广告加载失败
- (void)playableAds:(PlayableAds *)ads didFailToLoadWithError:(NSError *)error {
    NSLog(@"There was a problem loading advertising: %@", error);
}
/// 广告开始播放
- (void)playableAdsDidStartPlaying:(PlayableAds *)ads{
   NSLog(@"Advertising start playing");
}
/// 广告播放完成
- (void)playableAdsDidEndPlaying:(PlayableAds *)ads{
  NSLog(@"Advertising did end playing");
}
///展示广告落地页
- (void)playableAdsDidPresentLandingPage:(PlayableAds *)ads{
  NSLog(@"Advertising start playing");
}
/// 关闭广告
- (void)playableAdsDidDismissScreen:(PlayableAds *)ads{
  NSLog(@"Advertising did dismiss screen");
}
/// 广告被点击
- (void)playableAdsDidClick:(PlayableAds *)ads{
  NSLog(@"Advertising did clicked");
}
```



### 3.2 原生广告(托管渲染)接入代码

>托管渲染是ZPLAY Ads推出的一种自动渲染广告样式的原生广告。此种方式接入简化了原生广告的接入流程，您只需将广告展示出来，无需处理广告渲染相关事情，使得接入原生广告更加便捷。

#### 3.2.1 初始化nativeExpressAd

a. 在开发者自己ViewController 中,导入头文件，例如：

```objective-c
@interface PANativeExpressAdViewController () <PANativeExpressAdDelegate>

@property (nonatomic) PANativeExpressAd *nativeExpressAd;

@end
```

b. 初始化nativeExpressAd，获取广告，并设置回调

```objective-c
CGFloat width = [UIScreen mainScreen].bounds.size.width;
// adSize(即广告位尺寸)由您自行设置，SDK会返回一个适配过 adSize 的广告view
self.nativeExpressAd =
        [[PANativeExpressAd alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID" adSize:CGSizeMake(width, 300)];
self.nativeExpressAd.delegate = self;
```

#### 3.2.2 加载原生广告

```objective-c
[self.nativeExpressAd loadAd];
```

#### 3.2.3 渲染曝光

您需要在nativeExpressAd的回调中检测回调状态，若状态为成功，会返回一个 PANativeExpressAdView 类型的view对象，您可以调用```addSubview：```方法，将广告展示到需要的位置。

> 当您展示广告时，需调用```reportImpressionNativeExpressAd```方法来通知ZPLAY Ads广告被展示。

#### 3.2.4 广告拉取状态及点击回调

PANativeExpressAdDelegate提供广告拉取状态和点击的回调，您可通过此回调判断广告是否拉取成功及广告是否被点击。

```objective-c
/// 原生托管渲染广告加载成功，返回PANativeExpressAdView对象
- (void)playableNativeExpressAdDidLoad:(PANativeExpressAdView *)nativeExpressAd{
  
}
/// 原生托管渲染广告加载失败，返回错误提示
- (void)playableNativeExpressAdDidFailWithError:(NSError *)error{
  
}
/// 原生托管渲染广告被点击
- (void)playableNativeExpressAdDidClick:(PANativeExpressAdView *)nativeExpressAd{
  
}
```

### 3.3 原生广告(自渲染)接入代码

>原生自渲染广告是ZPLAY Ads推出的一种高度灵活的原生广告。您可根据自己的需求自行拼接广告样式，使广告展示更契合您的应用。

#### 3.3.1 初始化nativeAd

a. 在开发者自己ViewController中，导入头文件，例如：

```objective-c
@interface PAShowNativeAdViewController () <PANativeAdDelegate>

@property (nonatomic) PANativeAd *nativeAd;

@end
```

b. 初始化nativeAd，获取广告，并设置回调

```objective-c
self.nativeAd = [[PANativeAd alloc] initWithAdUnitID:@"Your Ad-Unit-ID" appID:@"Your App-ID"];
self.nativeAd.delegate = self;
```

#### 3.3.2 加载原生广告

```objective-c
[self.nativeAd loadAd];
```

#### 3.3.3 渲染曝光

在nativeAd的回调中，检测广告回调状态，成功之后，会返回一个PANativeAdModel的广告对象，开发者在合适的时机渲染广告界面并进行展示。

> 注意：
- 渲染完毕曝光给最终用户时需调用```reportImpression:view:```方法告知ZPLAY Ads已经渲染完毕并曝光。
- 将PANativeAd与您将用于显示原生广告的UIView相关联，调用方法```registerViewForInteraction: nativeAd:``` 。请确保关联view的    ```view.userInteractionEnabled = YES;```

#### 3.3.4 广告拉取状态及点击回调

PANativeAdDelegate提供广告拉取状态和点击的回调，您可通过此回调判断广告是否拉取成功及广告是否被点击。

```objective-c
/// 原生自渲染广告加载成功，返回PANativeAdModel对象
- (void)playableNativeAdDidLoad:(PANativeAdModel *)nativeAd{
  
}
/// 原生自渲染广告加载失败，返回error对象
- (void)playableNativeAdDidFailWithError:(NSError *)error{
  
}
/// 原生自渲染广告被点击的回调
- (void)playableNativeAdDidClick:(PANativeAdModel *)nativeAd{
  
}
```
### 3.4 Banner 接入代码
#### 3.4.1 初始化 Banner
```objective-c
#import <PlayableAds/AtmosplayAdsBanner.h>
@interface AtmosplayAdsBannerViewController () <AtmosplayAdsBannerDelegate>
@property (nonatomic) AtmosplayAdsBanner *bannerView;
@end

@implementation AtmosplayAdsBannerViewController
- (void)initBanner {
    self.bannerView =
        [[AtmosplayAdsBanner alloc] initWithAdUnitID:@"YOUR_ADUNIT_ID" appID:@"YOUR_APP_ID" rootViewController:self];
    self.bannerView.delegate = self;
    self.bannerView.bannerSize = kAtmosplayAdsBanner320x50;
}
@end
```
#### 3.4.2 请求 Banner
```objective-c
- (void)requestBanner {
    if (!self.bannerView) {
        return;
    }
    [self.bannerView loadAd];
}
```
#### 3.4.3 实现代理方法及展示
```objective-c
#pragma mark - banner view delegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)atmosplayAdsBannerViewDidLoad:(AtmosplayAdsBanner *)bannerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat y = self.view.frame.size.height - (bannerView.frame.size.height / 2);
        if (@available(iOS 11, *)) {
            y -= self.view.safeAreaInsets.bottom;
        }
        bannerView.center = CGPointMake(self.view.frame.size.width / 2, y);
        [self.view addSubview:bannerView];
    });
}

/// Tells the delegate that a request failed.
- (void)atmosplayAdsBannerView:(AtmosplayAdsBanner *)bannerView didFailWithError:(NSError *)error {
}

/// Tells the delegate that the banner view has been clicked.
- (void)atmosplayAdsBannerViewDidClick:(AtmosplayAdsBanner *)bannerView {
}
```
#### 3.4.4 销毁 Banner
```objective-c
- (void)destroyBanner {
    self.bannerView.delegate = nil;
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}
```

## 4 注意事项

### 4.1 请求广告返回400错误
检查工程是否设置了 **Display Name**

### 4.2 展示广告时出现黑屏
广告中可能出现http链接，在info.plist中添加以下代码
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```
### 4.3 尽早请求广告
广告请求需要时间，为确保广告资源能够成功加载，建议尽快请求广告。

### 4.4 插屏广告与激励视频广告

* 从2.0.3版本开始，您在申请广告位时可选择插屏广告还是激励视频广告，若广告位是插屏，广告开始后可中途关闭，且不会下发奖励。若广告位是激励视频，广告不可中途关闭，播放完成会给用户下发奖励。
* 当您的广告位是插屏广告形式时，不会触发`- (void)playableAdsDidRewardUser:(PlayableAds *)ads`方法，其余方法均与激励视频广告位一致。

### 4.5 GDPR
本文件是为遵守欧洲联盟的一般数据保护条例(GDPR)而提供的。 自 YumiMediationSDK 4.1.0 起，如果您正在收集用户的信息，您可以使用下面提供的api将此信息通知给 YumiMediationSDK 和部分三方平台。 更多信息请查看我们的官网。

#### 设置GDPR
```objective-c
typedef enum : NSUInteger {
    /// The user has granted consent for personalized ads.
    PlayableAdsConsentStatusPersonalized,
    /// The user has granted consent for non-personalized ads.
    PlayableAdsConsentStatusNonPersonalized,
    /// The user has neither granted nor declined consent for personalized or non-personalized ads.
    PlayableAdsConsentStatusUnknown,
} PlayableAdsConsentStatus;

[[PlayableAdsGDPR sharedGDPRManager] updatePlayableAdsConsentStatus:PlayableAdsConsentStatusPersonalized];
```

## 5 测试

您在测试中可使用如下ID进行测试，测试ID不会产生收益，应用上线时请使用您申请的正式ID。

| 操作系统 | 广告形式 | App_ID                               | Ad_Unit_ID                           |
| --------| ---- | ------------------------------------ | ------------------------------------ |
| iOS     | 激励视频 | A650AB0D-7BFC-2A81-3066-D3170947C3DA | BAE5DAAC-04A2-2591-D5B0-38FA846E45E7 |
| iOS     | 插屏          | A650AB0D-7BFC-2A81-3066-D3170947C3DA | 0868EBC0-7768-40CA-4226-F9924221C8EB |
| iOS     | 原生托管渲染   | A650AB0D-7BFC-2A81-3066-D3170947C3DA | DC9E199C-7C0B-FBFC-7E5A-26E7B5EE6BB3 |
| iOS     | 原生自渲染     | A650AB0D-7BFC-2A81-3066-D3170947C3DA | 25AED008-6B6F-BADB-F873-AE7CA61DFE98 |
| iOS     | Banner     | A650AB0D-7BFC-2A81-3066-D3170947C3DA |  |
