//
//  PAAdAutoModelCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/19.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAAdAutoModelCell.h"
#import "PADemoUtils.h"

@interface PAAdAutoModelCell ()

@property (nonatomic, strong) IBOutlet UISwitch *switcher;

@end

@implementation PAAdAutoModelCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.switcher.on = [[PADemoUtils shared] autoLoadAd];
}

- (IBAction)switchAction:(UISwitch *)sender {
    [[PADemoUtils shared] setAutoLoadAd:sender.on];
}

@end
