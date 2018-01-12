/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSTodayViewController.h"
#import "MMSListViewController.h"
#import "MMSListItem.h"
#import "MMSCrashUtils.h"
#import "MMSReportingUtils.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import <NotificationCenter/NotificationCenter.h>

@interface MMSTodayViewController () <NCWidgetProviding>
@end

@implementation MMSTodayViewController

+ (void)initialize
{
    if ([self class] == [MMSTodayViewController class]) {
        /* Replace API_KEY with your unique API key. Please, read official documentation how to obtain one:
         https://tech.yandex.com/metrica-mobile-sdk/doc/mobile-sdk-dg/tasks/ios-quickstart-docpage/
         */
        [YMMYandexMetrica activateWithApiKey:@"API_KEY"];
        //manual log setting for whole library
        //[YMMYandexMetrica setLoggingEnabled:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *actionsList = @[
            [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                        [MMSReportingUtils reportEventA];
                    }
                                     title:@"Report event A"],

            [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                        [MMSReportingUtils reportEventB];
                    }
                                     title:@"Report event B"],
            [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                        [MMSCrashUtils raiseException];
                    }
                                     title:@"Raise NSException"]
    ];

    MMSListViewController *controller = [[MMSListViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.availableItems = actionsList;

    [controller willMoveToParentViewController:self];
    [self.view addSubview:controller.view];

    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view = controller.view;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [self.view addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];

    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];

    self.preferredContentSize = controller.tableView.contentSize;
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

@end
