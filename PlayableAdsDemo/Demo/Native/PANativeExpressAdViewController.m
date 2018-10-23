//
//  PANativeExpressAdViewController.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/11.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PANativeExpressAdViewController.h"
#import "PADemoUtils.h"
#import "PANativeExpressAdCell.h"
#import <PlayableAds/PANativeExpressAd.h>

static NSString *expressId = @"ExpressViewCellID";

@interface PANativeExpressAdViewController () <PANativeExpressAdDelegate>

@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *adUnitTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UITableView *nativeExpressAdTableView;

@property (nonatomic) NSMutableArray *dataLists; // 偶数是广告
@property (nonatomic) PANativeExpressAd *nativeExpressAd;

@end

@implementation PANativeExpressAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.nativeExpressAdTableView registerNib:[UINib nibWithNibName:@"PANativeExpressAdCell" bundle:nil]
                        forCellReuseIdentifier:expressId];
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

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)requestAd:(UIBarButtonItem *)sender {
    NSString *appId = [self removeSpaceAndNewline:self.appIdTextField.text];
    NSString *appUnit = [self removeSpaceAndNewline:self.adUnitTextField.text];
    if (appId.length == 0) {
        [self addLog:@"appId is nil"];
        self.nativeExpressAd = nil;
        return;
    }
    if (appUnit.length == 0) {
        [self addLog:@"appUnit is nil"];
        self.nativeExpressAd = nil;
        return;
    }

    NSString *requestText = @"request playable ad ";
    if ([[PADemoUtils shared] channelID].length != 0) {
        requestText = [NSString stringWithFormat:@"%@ and channelID is %@",requestText,[[PADemoUtils shared] channelID]];
    }
    [self addLog:requestText];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.nativeExpressAd =
        [[PANativeExpressAd alloc] initWithAdUnitID:appUnit appID:appId adSize:CGSizeMake(width, 300)];
    self.nativeExpressAd.channelId = [[PADemoUtils shared] channelID];
    self.nativeExpressAd.delegate = self;
}

- (IBAction)loadAd:(UIBarButtonItem *)sender {
    [self addLog:@"load ad ..."];
    [self.nativeExpressAd loadAd];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text;
}

#pragma mark : UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id model = self.dataLists[indexPath.row];

    PANativeExpressAdCell *cell = [tableView dequeueReusableCellWithIdentifier:expressId];

    [cell setCellData:model];

    return cell;
}

#pragma mark : UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataLists[indexPath.row];
    if ([model isKindOfClass:[PANativeExpressAdView class]]) {
        return 300;
    }

    return 100;
}

/// Tells the delegate that an ad has been successfully loaded.
- (void)playableNativeExpressAdDidLoad:(PANativeExpressAdView *)nativeExpressAd {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.dataLists addObject:nativeExpressAd];
        //  测试元素
        [weakSelf.dataLists addObject:@(weakSelf.dataLists.count)];
        [weakSelf.nativeExpressAdTableView reloadData];
    });

    [self addLog:@"native ad load successed"];
}

/// Tells the delegate that a request failed.
- (void)playableNativeExpressAdDidFailWithError:(NSError *)error {
    [self addLog:@"native ad load fail"];
}

/// Tells the delegate that the Native view has been clicked.
- (void)playableNativeExpressAdDidClick:(PANativeExpressAdView *)nativeExpressAd {
    [self addLog:@"native ad load click"];
}
#pragma mark : UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (NSMutableArray *)dataLists {
    if (!_dataLists) {
        _dataLists = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataLists;
}
@end
