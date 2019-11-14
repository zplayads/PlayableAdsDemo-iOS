//
//  PAGDPRSwitchCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2019/8/8.
//  Copyright © 2019 on99. All rights reserved.
//

#import "PAGDPRSwitchCell.h"
#import <PlayableAds/PlayableAdsGDPR.h>

@interface PAGDPRSwitchCell ()

@property (nonatomic, weak) IBOutlet UISwitch *switcher;

@end

@implementation PAGDPRSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.switcher.on = [[PlayableAdsGDPR sharedGDPRManager] getConsentStatus] == PlayableAdsConsentStatusPersonalized;
}

- (IBAction)handleGdprSwitch:(UISwitch *)sender {

    if (sender.on) {
        [[PlayableAdsGDPR sharedGDPRManager] updatePlayableAdsConsentStatus:PlayableAdsConsentStatusPersonalized];
        return;
    }
    [[PlayableAdsGDPR sharedGDPRManager] updatePlayableAdsConsentStatus:PlayableAdsConsentStatusNonPersonalized];
}

@end
