//
//  PANativeExpressAdCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/11.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PANativeExpressAdCell.h"
#import <PlayableAds/PANativeExpressAd.h>
#import <Masonry/Masonry.h>

@interface PANativeExpressAdCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;

@end

@implementation PANativeExpressAdCell

- (void)setCellData:(id)expressAdView {
    if ([expressAdView isKindOfClass:[PANativeExpressAdView class]]) {
        self.titleLab.text = nil;
        self.desLab.text = nil;
        
        [expressAdView reportImpressionNativeExpressAd];
        CGSize size = ((PANativeExpressAdView *)expressAdView).bounds.size;
        [self addSubview:expressAdView];
        [expressAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
        }];
        return;
    }

    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[PANativeExpressAdView class]]) {
            [subView removeFromSuperview];
        }
    }
    self.titleLab.text = [NSString stringWithFormat:@"I am news at %@ items", expressAdView];
}

@end
