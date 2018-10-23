//
//  PAChannelIDCell.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/19.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAChannelIDCell.h"
#import "PADemoUtils.h"

@interface PAChannelIDCell () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *channelTextField;

@end

@implementation PAChannelIDCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.channelTextField.delegate = self;
    self.channelTextField.text = [[PADemoUtils shared] channelID];
}
#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {

    NSString *channelId = [[PADemoUtils shared] removeSpaceAndNewline:textField.text];

    [[PADemoUtils shared] setChannelID:channelId];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
