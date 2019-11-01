//
//  PARootViewController.m
//  PlayableAds_Example
//
//  Created by 王泽永 on 2019/9/11.
//  Copyright © 2019 on99. All rights reserved.
//

#import "PARootViewController.h"

@interface PARootViewController ()

@end

@implementation PARootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - orientation logic
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
