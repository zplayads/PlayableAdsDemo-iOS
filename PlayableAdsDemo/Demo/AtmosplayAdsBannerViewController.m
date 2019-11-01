//
//  AtmosplayAdsBannerViewController.m
//  PlayableAds_Example
//
//  Created by 王泽永 on 2019/9/4.
//  Copyright © 2019 on99. All rights reserved.
//

#import "AtmosplayAdsBannerViewController.h"
#import <PlayableAds/AtmosplayAdsBanner.h>
#import <PlayableAds/PAUtils.h>

@interface AtmosplayAdsBannerViewController () <AtmosplayAdsBannerDelegate>
@property (nonatomic) AtmosplayAdsBanner *bannerView;
@property (nonatomic) UITextField *appID;
@property (nonatomic) UITextField *adUnitID;
@property (nonatomic) UIButton *bannerSize1;
@property (nonatomic) UIButton *bannerSize2;
@property (nonatomic) UIButton *bannerSize3;
@property (nonatomic) UIButton *bannerSize4;
@property (nonatomic) UIButton *bannerInitBtn;
@property (nonatomic) UIButton *bannerRequestBtn;
@property (nonatomic) UIButton *bannerDestroyBtn;
@property (nonatomic) UITextView *console;
@property (nonatomic, assign) AtmosplayAdsBannerSize bannerSize;

@end

@implementation AtmosplayAdsBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Banner";
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(orientationChanged:)
        name:@"UIDeviceOrientationDidChangeNotification"
      object:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Orientation delegate
- (void)orientationChanged:(NSNotification *)notification {
    if (!self.appID) {
        [self setUpUI];
    } else {
        [self.appID removeFromSuperview];
        [self.adUnitID removeFromSuperview];
        [self.bannerSize1 removeFromSuperview];
        [self.bannerSize2 removeFromSuperview];
        [self.bannerSize3 removeFromSuperview];
        [self.bannerSize4 removeFromSuperview];
        [self.bannerInitBtn removeFromSuperview];
        [self.bannerRequestBtn removeFromSuperview];
        [self.bannerDestroyBtn removeFromSuperview];
        [self.console removeFromSuperview];
        self.appID = nil;
        self.adUnitID = nil;
        self.bannerSize1 = nil;
        self.bannerSize2 = nil;
        self.bannerSize3 = nil;
        self.bannerSize4 = nil;
        self.bannerInitBtn = nil;
        self.bannerRequestBtn = nil;
        self.bannerDestroyBtn = nil;
        self.console = nil;
        
        [self setUpUI];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView) {
            CGFloat y = self.view.frame.size.height - (self.bannerView.frame.size.height / 2);
            if (@available(ios 11.0, *)) {
                y -= self.view.safeAreaInsets.bottom;
            }
            self.bannerView.center = CGPointMake(self.view.frame.size.width / 2, y);
        }
    });
}

- (void)setUpUI {
    PAUtils *tool = [PAUtils sharedUtils];
    CGFloat width = [tool adaptedValue6:260];
    CGFloat height = [tool adaptedValue6:40];
    CGFloat marginTop = (tool.iSiPhoneX || tool.iSiPhoneXR) ? 100.0 : 80.0;
    CGFloat margin = 10.0;

    self.appID = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, marginTop, width, height)];
    self.appID.borderStyle = UITextBorderStyleRoundedRect;
    self.appID.backgroundColor = [UIColor blackColor];
    self.appID.placeholder = @"Please Input Your App ID";
    self.appID.textColor = [UIColor whiteColor];
    [self.appID setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.appID.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.appID.autocapitalizationType = UITextAutocapitalizationTypeNone;

    self.adUnitID = [[UITextField alloc]
        initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, marginTop + height + margin, width, height)];
    self.adUnitID.borderStyle = UITextBorderStyleRoundedRect;
    self.adUnitID.backgroundColor = [UIColor blackColor];
    self.adUnitID.placeholder = @"Please Input Your Unit ID";
    self.adUnitID.textColor = [UIColor whiteColor];
    [self.adUnitID setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.adUnitID.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.adUnitID.autocapitalizationType = UITextAutocapitalizationTypeNone;

    CGFloat btnWidth = [tool adaptedValue6:125];
    CGFloat x = self.adUnitID.frame.origin.x;
    self.bannerSize1 =
        [[UIButton alloc] initWithFrame:CGRectMake(x, marginTop + height * 2 + margin * 2, btnWidth, height)];
    self.bannerSize1.backgroundColor = [UIColor blackColor];
    [self.bannerSize1 setTitle:@"320 * 50" forState:UIControlStateNormal];
    [self.bannerSize1 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    self.bannerSize1.layer.cornerRadius = 5;
    self.bannerSize1.layer.masksToBounds = YES;
    [self.bannerSize1 addTarget:self action:@selector(selectBannerSize1) forControlEvents:UIControlEventTouchUpInside];

    self.bannerSize2 = [[UIButton alloc]
        initWithFrame:CGRectMake(x + width - btnWidth, self.bannerSize1.frame.origin.y, btnWidth, height)];
    self.bannerSize2.backgroundColor = [UIColor blackColor];
    [self.bannerSize2 setTitle:@"728 * 90" forState:UIControlStateNormal];
    [self.bannerSize2 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    self.bannerSize2.layer.cornerRadius = 5;
    self.bannerSize2.layer.masksToBounds = YES;
    [self.bannerSize2 addTarget:self action:@selector(selectBannerSize2) forControlEvents:UIControlEventTouchUpInside];

    self.bannerSize3 =
        [[UIButton alloc] initWithFrame:CGRectMake(x, marginTop + height * 3 + margin * 3, width, height)];
    self.bannerSize3.backgroundColor = [UIColor blackColor];
    [self.bannerSize3 setTitle:@"smart banner portrait" forState:UIControlStateNormal];
    [self.bannerSize3 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    self.bannerSize3.layer.cornerRadius = 5;
    self.bannerSize3.layer.masksToBounds = YES;
    [self.bannerSize3 addTarget:self action:@selector(selectBannerSize3) forControlEvents:UIControlEventTouchUpInside];

    self.bannerSize4 =
        [[UIButton alloc] initWithFrame:CGRectMake(x, marginTop + height * 4 + margin * 4, width, height)];
    self.bannerSize4.backgroundColor = [UIColor blackColor];
    [self.bannerSize4 setTitle:@"smart banner landscape" forState:UIControlStateNormal];
    [self.bannerSize4 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    self.bannerSize4.layer.cornerRadius = 5;
    self.bannerSize4.layer.masksToBounds = YES;
    [self.bannerSize4 addTarget:self action:@selector(selectBannerSize4) forControlEvents:UIControlEventTouchUpInside];

    self.bannerInitBtn =
        [[UIButton alloc] initWithFrame:CGRectMake(x, marginTop + height * 5 + margin * 5, width*0.3, height)];
    self.bannerInitBtn.backgroundColor = [UIColor blackColor];
    [self.bannerInitBtn setTitle:@"init" forState:UIControlStateNormal];
    self.bannerInitBtn.layer.cornerRadius = 5;
    self.bannerInitBtn.layer.masksToBounds = YES;
    [self.bannerInitBtn addTarget:self action:@selector(initBanner) forControlEvents:UIControlEventTouchUpInside];

    self.bannerRequestBtn =
        [[UIButton alloc] initWithFrame:CGRectMake((x + width - width*0.6 - width*0.05),
                                                   self.bannerInitBtn.frame.origin.y, width*0.3, height)];
    self.bannerRequestBtn.backgroundColor = [UIColor blackColor];
    [self.bannerRequestBtn setTitle:@"request" forState:UIControlStateNormal];
    self.bannerRequestBtn.layer.cornerRadius = 5;
    self.bannerRequestBtn.layer.masksToBounds = YES;
    [self.bannerRequestBtn addTarget:self action:@selector(requestBanner) forControlEvents:UIControlEventTouchUpInside];
    
    self.bannerDestroyBtn =
    [[UIButton alloc] initWithFrame:CGRectMake((x + width - width*0.3),
                                               self.bannerInitBtn.frame.origin.y, width*0.3, height)];
    self.bannerDestroyBtn.backgroundColor = [UIColor blackColor];
    [self.bannerDestroyBtn setTitle:@"destroy" forState:UIControlStateNormal];
    self.bannerDestroyBtn.layer.cornerRadius = 5;
    self.bannerDestroyBtn.layer.masksToBounds = YES;
    [self.bannerDestroyBtn addTarget:self action:@selector(destroyBanner) forControlEvents:UIControlEventTouchUpInside];

    self.console = [[UITextView alloc]
        initWithFrame:CGRectMake(0, self.bannerInitBtn.frame.origin.y + height + margin, SCREEN_WIDTH,
                                 SCREEN_HEIGHT - (self.bannerInitBtn.frame.origin.y + height + margin) - 100)];
    self.console.backgroundColor = [UIColor grayColor];

    CGFloat landscapeSideMargin = [tool adaptedValue6:50];
    if (![[PAUtils sharedUtils] isInterfaceOrientationPortrait]) {
        self.appID.frame = CGRectMake(landscapeSideMargin, landscapeSideMargin, width, height);
        self.adUnitID.frame = CGRectMake(landscapeSideMargin, landscapeSideMargin + margin + height, width, height);
        self.bannerSize1.frame =
            CGRectMake(landscapeSideMargin, landscapeSideMargin + margin * 2 + height * 2, btnWidth, height);
        self.bannerSize2.frame = CGRectMake(landscapeSideMargin + width - btnWidth,
                                            landscapeSideMargin + margin * 2 + height * 2, btnWidth, height);
        self.bannerSize3.frame =
            CGRectMake(landscapeSideMargin, landscapeSideMargin + margin * 3 + height * 3, width, height);
        self.bannerSize4.frame =
            CGRectMake(landscapeSideMargin, landscapeSideMargin + margin * 4 + height * 4, width, height);
        self.bannerInitBtn.frame =
            CGRectMake(landscapeSideMargin + width + margin, landscapeSideMargin, width*0.3, height);
        self.bannerRequestBtn.frame =
            CGRectMake(landscapeSideMargin + width + margin + width*0.3 + width * 0.05, landscapeSideMargin, width*0.3, height);
        self.bannerDestroyBtn.frame = CGRectMake(landscapeSideMargin + width + margin + width*0.6 + width * 0.1, landscapeSideMargin, width*0.3, height);
        self.console.frame =
            CGRectMake(landscapeSideMargin + width + margin, landscapeSideMargin + height + margin,
                       btnWidth * 2 + margin, self.bannerSize4.frame.origin.y - self.adUnitID.frame.origin.y + height);
    }

    [self.view addSubview:self.appID];
    [self.view addSubview:self.adUnitID];
    [self.view addSubview:self.bannerSize1];
    [self.view addSubview:self.bannerSize2];
    [self.view addSubview:self.bannerSize3];
    [self.view addSubview:self.bannerSize4];
    [self.view addSubview:self.bannerInitBtn];
    [self.view addSubview:self.bannerRequestBtn];
    [self.view addSubview:self.bannerDestroyBtn];
    [self.view addSubview:self.console];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    return text;
}

- (void)initBanner {
    if (!self.appID.text.length) {
        self.appID.text = @"788C58DC-8290-F665-3C87-E7B1DBE8DFCE";
    } else {
        self.appID.text = [self removeSpaceAndNewline:self.appID.text];
    }
    if (!self.adUnitID.text.length) {
        self.adUnitID.text = @"51449B74-3F06-FE87-6313-2B4E1BB443E3";
    } else {
        self.adUnitID.text = [self removeSpaceAndNewline:self.adUnitID.text];
    }

    self.bannerView =
        [[AtmosplayAdsBanner alloc] initWithAdUnitID:self.adUnitID.text appID:self.appID.text rootViewController:self];
    self.bannerView.delegate = self;
    self.bannerView.bannerSize = self.bannerSize;
    [self addLog:@"init banner"];
}

- (void)requestBanner {
    if (!self.bannerView) {
        [self addLog:@"init first"];
        return;
    }
    [self.bannerView loadAd];
    [self addLog:@"request banner"];
}

- (void)destroyBanner {
    self.bannerView.delegate = nil;
    self.bannerView.bannerSize = 0;
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

- (void)addLog:(NSString *)newLog {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.console.layoutManager.allowsNonContiguousLayout = NO;
        NSString *oldLog = weakSelf.console.text;
        NSString *text = [NSString stringWithFormat:@"%@\n%@", oldLog, newLog];
        if (oldLog.length == 0) {
            text = [NSString stringWithFormat:@"%@", newLog];
        }
        [weakSelf.console scrollRangeToVisible:NSMakeRange(text.length, 1)];
        weakSelf.console.text = text;
    });
}

#pragma mark - banner view delegate
/// Tells the delegate that an ad has been successfully loaded.
- (void)atmosplayAdsBannerViewDidLoad:(AtmosplayAdsBanner *)bannerView {
    [self addLog:@"atmosplayAdsBannerViewDidLoad"];
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
    [self addLog:[NSString stringWithFormat:@"didFailWithError:%@", error.localizedDescription]];
}

/// Tells the delegate that the banner view has been clicked.
- (void)atmosplayAdsBannerViewDidClick:(AtmosplayAdsBanner *)bannerView {
    [self addLog:@"atmosplayAdsBannerViewDidClick"];
}

#pragma mark - banner size selecte
- (void)selectBannerSize1 {
    self.bannerSize = kAtmosplayAdsBanner320x50;
}

- (void)selectBannerSize2 {
    self.bannerSize = kAtmosplayAdsBanner728x90;
}

- (void)selectBannerSize3 {
    self.bannerSize = kAtmosplayAdsSmartBannerPortrait;
}

- (void)selectBannerSize4 {
    self.bannerSize = kAtmosplayAdsSmartBannerLandscape;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.console resignFirstResponder];
    [self.appID resignFirstResponder];
    [self.adUnitID resignFirstResponder];
}

@end
