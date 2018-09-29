//
//  PANativeAdTableViewCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/17.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PANativeAdTableViewCell.h"
#import <Masonry/Masonry.h>

@interface PANativeAdTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *freeView;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;

@property (nonatomic) PANativeAdModel *nativeAd;

@end

@implementation PANativeAdTableViewCell

- (void)dealloc {
    self.nativeAd = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.desLab.adjustsFontSizeToFitWidth = YES;
    self.titleLab.adjustsFontSizeToFitWidth = YES;
}

- (void)setCellNativeData:(PANativeAdModel *)nativeAd {

    self.coverImgView.image = nil;
    if (self.nativeAd.mediaView) {
        [self.nativeAd.mediaView removeFromSuperview];
    }
    if (self.nativeAd.callToAction) {
        [self.nativeAd.callToAction removeFromSuperview];
    }

    self.nativeAd = nil;

    self.nativeAd = nativeAd;
    if (self.nativeAd.mediaView) {
        [self.nativeAd.mediaView pauseVideo];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.iconImgView.image = nativeAd.icon.image;
        weakSelf.titleLab.text = nativeAd.title;
        weakSelf.desLab.text = nativeAd.desc;
        if (nativeAd.mediaView == nil) {
            weakSelf.coverImgView.image = nativeAd.coverImage.image;
        } else {
            [weakSelf.coverImgView addSubview:nativeAd.mediaView];
            nativeAd.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
            
            CGFloat coverImgHeight = weakSelf.coverImgView.bounds.size.height;
            CGFloat coverImgWidth = weakSelf.coverImgView.bounds.size.width;
            
            [nativeAd.mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(weakSelf.coverImgView);
                make.height.mas_equalTo(coverImgHeight);
                make.width.mas_equalTo(coverImgWidth);
            }];
            
        }
        
        [weakSelf.freeView addSubview:nativeAd.callToAction];

    });
}
- (void)mediaPlay {
    if (self.nativeAd.mediaView) {
        [self.nativeAd.mediaView playVideo];
    }
}
- (void)mediaPause {
    if (self.nativeAd.mediaView) {
        [self.nativeAd.mediaView pauseVideo];
    }
}
@end
