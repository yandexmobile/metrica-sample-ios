/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSRootControllerProvider.h"
#import "MMSListItemsProvider.h"
#import "MMSListItem.h"
#import "MMSListViewController.h"

static CGFloat const kMMSNavBarBrightness = .75f;

@implementation MMSRootControllerProvider

+ (UIViewController *)rootController
{
    MMSListViewController *listController = [[self class] listController];
    return [[self class] wrapListController:listController];
}

#pragma mark - Root Controller

+ (MMSListViewController *)listController
{
    MMSListViewController *controller = [[MMSListViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.availableItems = [[self class] rootControllerStructure];
    controller.navigationItem.title = @"AppMetrica Sample";

    return controller;
}

+ (UIViewController *)wrapListController:(MMSListViewController *)listController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
    navController.navigationBar.translucent = NO;

    UIColor *tintColor = [UIColor colorWithWhite:kMMSNavBarBrightness alpha:1.f];
    if ([navController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        navController.navigationBar.barTintColor = tintColor;
    }
    else {
        navController.navigationBar.tintColor = tintColor;
    }

    return navController;
}

+ (NSArray *)rootControllerStructure
{
    NSArray *structure = @[[MMSListItem listItemWithBlock:[[self class] showEventsBlock]
                                                    title:@"Events"
                                               disclosing:YES],

                           [MMSListItem listItemWithBlock:[[self class] showCrashesBlock]
                                                    title:@"Crashes"
                                               disclosing:YES]];

    return structure;
}

+ (MMSListItemBlock)showEventsBlock
{
    MMSListItemBlock showEvents = ^(MMSListViewController *lc) {
        MMSListViewController *controller = [[MMSListViewController alloc] init];
        controller.availableItems = [MMSListItemsProvider reportingListItems];
        controller.navigationItem.title = @"Events";
        [lc.navigationController pushViewController:controller animated:YES];
    };

    return showEvents;
}

+ (MMSListItemBlock)showCrashesBlock
{
    MMSListItemBlock showCrashes = ^(MMSListViewController *lc) {
        MMSListViewController *controller = [[MMSListViewController alloc] init];
        controller.availableItems = [MMSListItemsProvider crashingListItems];
        controller.navigationItem.title = @"Crashes";
        [lc.navigationController pushViewController:controller animated:YES];
    };

    return showCrashes;
}

@end
