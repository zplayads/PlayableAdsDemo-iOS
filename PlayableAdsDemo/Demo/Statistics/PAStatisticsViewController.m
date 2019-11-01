//
//  PAStatisticsViewController.m
//  PlayableAds_Example
//
//  Created by Michael Tang on 2018/9/13.
//  Copyright © 2018年 on99. All rights reserved.
//

#import "PAStatisticsViewController.h"
#import "PAStatisticsCell.h"

static NSString *playableAdsStatisticsKey = @"playableAds_Statistics_key";
static NSString *reuseIdentifier = @"PAStatisticsCellID";

@interface PAStatisticsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSArray *statisticsItems;

@end

@implementation PAStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.listTableView registerNib:[UINib nibWithNibName:@"PAStatisticsCell" bundle:nil]
             forCellReuseIdentifier:reuseIdentifier];
    self.statisticsItems = [self getStatisticsItems];
}

- (NSArray *)getStatisticsItems {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [standardUserDefaults objectForKey:playableAdsStatisticsKey];
    if (!data) {
        return nil;
    }
    NSArray *statisticsItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return statisticsItems;
}

- (IBAction)onBack:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark : UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statisticsItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id item = [[NSClassFromString(@"PAStatisticsItem") alloc] init];
    item = self.statisticsItems[indexPath.row];

    PAStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    [cell setCellData:item];

    return cell;
}

#pragma mark : UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 130;
}

@end
