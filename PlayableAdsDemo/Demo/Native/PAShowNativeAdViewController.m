//
//  PAShowNativeAdViewController.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/11.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAShowNativeAdViewController.h"
#import "PADemoUtils.h"
#import "PANativeAdTableViewCell.h"
#import <PlayableAds/PANativeAd.h>

static NSString *cellID = @"PANativeAdCellID";

@interface PAShowNativeAdViewController () <PANativeAdDelegate>

@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *adUnitTextField;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;
@property (weak, nonatomic) IBOutlet UITableView *nativeAdTableView;

@property (nonatomic) NSMutableArray *dataLists; // 偶数是广告
@property (nonatomic) PANativeAd *nativeAd;

@end

@implementation PAShowNativeAdViewController

- (void)dealloc {
    self.nativeAd = nil;
    [self handleVisibleCells:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.nativeAdTableView registerNib:[UINib nibWithNibName:@"PANativeAdTableViewCell" bundle:nil]
                 forCellReuseIdentifier:cellID];
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
        self.nativeAd = nil;
        return;
    }
    if (appUnit.length == 0) {
        [self addLog:@"appUnit is nil"];
        self.nativeAd = nil;
        return;
    }
    
    NSString *requestText = @"request playable ad ";
    if ([[PADemoUtils shared] channelID].length != 0) {
        requestText = [NSString stringWithFormat:@"%@ and channelID is %@",requestText,[[PADemoUtils shared] channelID]];
    }
    [self addLog:requestText];
    
    self.nativeAd = [[PANativeAd alloc] initWithAdUnitID:appUnit appID:appId];
    self.nativeAd.channelId = [[PADemoUtils shared] channelID];
    self.nativeAd.delegate = self;
}

- (IBAction)loadAd:(UIBarButtonItem *)sender {
    [self addLog:@"load ad ..."];
    [self.nativeAd loadAd];
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

    if ([model isKindOfClass:[PANativeAdModel class]]) {

        PANativeAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"PANativeAdCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }

        [cell setCellNativeData:model];
        [self.nativeAd registerViewForInteraction:cell nativeAd:model];
        [self.nativeAd reportImpression:model view:cell];

        return cell;
    }

    static NSString *cellNormalId = @"DefaultCellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNormalId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellNormalId];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"I am content is == %@", model];
    cell.detailTextLabel.text = @"news content";

    return cell;
}

#pragma mark : UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    id model = self.dataLists[indexPath.row];
    if ([model isKindOfClass:[PANativeAdModel class]]) {
        CGFloat height = screenWidth / ((PANativeAdModel *)model).ratios;

        return height + 60;
    }
    return 88;
}

- (void)handleVisibleCells:(BOOL)isPlay {

    NSArray<UITableViewCell *> *visibleCells = self.nativeAdTableView.visibleCells;

    for (UITableViewCell *cell in visibleCells) {
        if ([cell isKindOfClass:[PANativeAdTableViewCell class]]) {
            //
            if (isPlay) {
                [((PANativeAdTableViewCell *)cell)mediaPlay];
            } else {
                [((PANativeAdTableViewCell *)cell)mediaPause];
            }
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self handleVisibleCells:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self handleVisibleCells:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self handleVisibleCells:YES];
        }
    }
}

#pragma mark : PANativeAdDelegate

/// Tells the delegate that an ad has been successfully loaded.
- (void)playableNativeAdDidLoad:(PANativeAdModel *)nativeAd {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.dataLists addObject:nativeAd];
        //  测试元素
        [weakSelf.dataLists addObject:@(weakSelf.dataLists.count)];
        [weakSelf.dataLists addObject:@(weakSelf.dataLists.count)];
        [weakSelf.dataLists addObject:@(weakSelf.dataLists.count)];

        [weakSelf.nativeAdTableView reloadData];
        [weakSelf handleVisibleCells:YES];
    });

    [self addLog:@"native ad load successed"];
}

/// Tells the delegate that a request failed.
- (void)playableNativeAdDidFailWithError:(NSError *)error {
    [self addLog:@"native ad load fail"];
}

/// Tells the delegate that the Native view has been clicked.
- (void)playableNativeAdDidClick:(PANativeAdModel *)nativeAd {
    [self addLog:@"native ad did click"];
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
