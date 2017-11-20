## 1.概述
### 1.1.面向读者
本产品面向需要在Xcode工程中接入ZPLAYAds SDK的开发人员。
### 1.2.开发环境
- 操作系统：Mac OS X10.8.5版本及以上
- 开发环境：Xcode7及以上版本
- 部署目标：iOS8及以上
### 1.3.术语介绍
**APPID**：应用ID，是您在ZPLAYAds平台创建媒体时获取的ID;

**adUnitID**：广告位ID，是您在ZPLAYAds告平台为您的应用创建的广告位置的ID。
## 2.SDK接入
CocoaPod是Objective-C的依赖管理器，可以轻松添加和更新Playable Ads SDK。
##### 2.1. 安装CocoaPods/Install Cocoapods
```sh
sudo gem install cocoapods
```
##### 2.2. 从终端切换至iOS项目根目录下，创建Podfile文件
```sh
pod init
```
##### 2.3. 将Playable Ads SDK加入到Podfile文件
```sh
pod 'PlayableAds', '~>1.5.0'
```
##### 2.4. 安装Playable Ads SDK
```sh
pod install
```
## 3.接入代码
**初始化SDK**

初始化ZPLAYAds广告，并显示视频。
> 广告预加载需要几秒时间，建议您在应用启动后尽早初始化及加载ZPLAYAds广告。初始化SDK时需要将您在ZPLAYAds平台申请的APPID和adUnitID填入相应的位置，


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
**展示广告**

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
**判断广告是否加载完成**

您可以通过此回调判断是否有广告可以播放。
> 可通过此方法进行游戏内设置的判断。

```objective-c
- (void)playableAdsDidLoad:(PlayableAds *)ads {
NSLog(@"playable ads did load");
}
```
**获取奖励**

视频奖励，您可以实现此回调给用户下发奖励。
> 当您在激励视频广告位上使用ZPLAYAds时，最重要的是奖励看完广告的用户，要奖励用户请实现此回调。

```objective-c
#pragma mark - PlayableAdsDelegate
// 奖励用户，当您需要给用户激励时，可使用此回调判断是否有奖励下发。
- (void)playableAdsDidRewardUser:(PlayableAds *)ads {
NSLog(@"playable ads did reward");
}
```
## 4 注意事项

1. 请求广告返回400错误：检查工程是否设置了 **Display Name**

2. 请求成功后，展示广告时出现黑屏：广告中可能出现http链接，在info.plist中添加以下代码
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```
