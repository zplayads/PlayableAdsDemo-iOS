//
//  PAMenuViewController.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/19.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAMenuViewController.h"
#import "PAPlayableAdsViewController.h"

@interface PAMenuViewController ()

@end

@implementation PAMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Select one of the options below".uppercaseString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"VideoId"]) {
        PAPlayableAdsViewController *playableVc = segue.destinationViewController;
        playableVc.isVideo = YES;

    } else if ([segue.identifier isEqualToString:@"InterstitialId"]) {
        PAPlayableAdsViewController *playableVc = segue.destinationViewController;
        playableVc.isVideo = NO;
    }
}

@end
