//
//  PAStatisticsCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/14.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAStatisticsCell.h"

@interface PAStatisticsCell ()

@property (weak, nonatomic) IBOutlet UILabel *trackNameLab;
@property (weak, nonatomic) IBOutlet UILabel *successLab;
@property (weak, nonatomic) IBOutlet UILabel *failLab;
@property (weak, nonatomic) IBOutlet UILabel *failReasonLab;

@end

@implementation PAStatisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellData:(id)statisticsData {

    NSString *trackingName = [statisticsData valueForKey:@"trackingType"];
    NSUInteger count = [[statisticsData valueForKey:@"count"] integerValue];
    NSUInteger errorCount = [[statisticsData valueForKey:@"errorCount"] integerValue];
    NSArray *codes = [statisticsData valueForKey:@"errorCode"];

    self.trackNameLab.text = trackingName;
    self.successLab.text = [NSString stringWithFormat:@"success times is %ld", count];
    self.failLab.text = [NSString stringWithFormat:@"fail times is %ld", errorCount];
    self.failReasonLab.text = [NSString stringWithFormat:@"error reason: %@", [codes componentsJoinedByString:@"、"]];
}

@end
