/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSListViewController.h"
#import "MMSCrashUtils.h"
#import "MMSReportingUtils.h"
#import "MMSListItem.h"

static CGFloat const kMMSRowHeight = 60.f;

@implementation MMSListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = kMMSRowHeight;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.availableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMSListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.numberOfLines = 2;
    }
    MMSListItem *currentItem = self.availableItems[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%lld. %@", (long long int)(indexPath.row + 1), currentItem.title];
    if (currentItem.disclosing) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMSListItem *currentItem = self.availableItems[indexPath.row];
    if (currentItem.block != nil) {
        currentItem.block(self);
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
