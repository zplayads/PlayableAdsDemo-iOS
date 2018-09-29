//
//  PATestModelCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/19.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PATestModelCell.h"
#import "PADemoUtils.h"

@interface PATestModelCell ()

@property (nonatomic, strong) IBOutlet UISwitch *switcher;

@end
@implementation PATestModelCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.switcher.on = [[PADemoUtils shared] tagFileExsit];
}

- (IBAction)switchAction:(UISwitch *)sender {
    PADemoUtils *demoUtil = [PADemoUtils shared];
    if (sender.on) {
        [demoUtil createTagFile];
        return;
    }

    [demoUtil removeTagFile];
}

@end
