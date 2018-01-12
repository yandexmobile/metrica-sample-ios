/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "MMSListItemsProvider.h"
#import "MMSCrashUtils.h"
#import "MMSReportingUtils.h"
#import "MMSListItem.h"
#import "MMSListViewController.h"
#import "MMSDictionaryEditorController.h"

@implementation MMSListItemsProvider

+ (NSArray *)crashingListItems
{
    static NSArray *crashItems = nil;
    void (^onceBlock)() = ^{
        crashItems =
        @[
          [self crashEnvironmentEditorItem],
          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils deadbeef];
          }
                                   title:@"0xDEADBEEF pointer used as NSObject"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils releaseNULL];
          }
                                   title:@"CFRelease called with NULL as argument"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils dereferenceNullPointer];
          }
                                   title:@"Attempt to dereference NULL"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils useCorruptObject];
          }
                                   title:@"Send message to corrupt object"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils indexOutOfBounds];
          }
                                   title:@"Access object at index beyond NSArray size"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils raiseException];
          }
                                   title:@"Raise NSException"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils raiseExceptionInDefaultQueue];
          }
                                   title:@"Asynchronously raise NSException in default queue"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils raiseExceptionInCustomQueue];
          }
                                   title:@"Asynchronously raise NSException in custom queue"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils objcHandlerCalledFromARunLoop];
          }
                                   title:@"Call std::runtime_error"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils throwUncaughtNSException];
          }
                                   title:@"Throw uncaught NSException (NSInvalidArgumentException)"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils doAbort];
          }
                                   title:@"Call abort()"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils dereferenceBadPointer];
          }
                                   title:@"Derefernce bad pointer (char *)-1"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils spinRunloop];
          }
                                   title:@"Spin run loop"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils causeStackOverflow];
          }
                                   title:@"Cause stack overflow"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils doIllegalInstruction];
          }
                                   title:@"Do illegal instruction via invalid function pointer call"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils accessDeallocatedObject];
          }
                                   title:@"Access deallocated object"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils accessDeallocatedPtrProxy];
          }
                                   title:@"Access deallocated property"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils zombieNSException];
          }
                                   title:@"Access deallocated NSException"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils corruptMemory];
          }
                                   title:@"Corrupt memory"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils deadlock];
          }
                                   title:@"Cause deadlock"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              [MMSCrashUtils throwUncaughtCPPException];
          }
                                   title:@"Throw user defined C++ class as exception"],

          [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
              NSUInteger randomIndex = arc4random() % (lc.availableItems.count - 1);
              NSIndexPath *randomIndexPath = [NSIndexPath indexPathForRow:randomIndex inSection:0];
              [lc tableView:lc.tableView didSelectRowAtIndexPath:randomIndexPath];
          }
                                   title:@"Random Crash"]
          ];
    };
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, onceBlock);

    return [crashItems copy];
}

+ (NSArray *)reportingListItems
{
    static NSArray *reportingItems = nil;
    void (^onceBlock)() = ^{

        reportingItems = @[
                           [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                               [MMSReportingUtils reportEventA];
                           }
                                                    title:@"Report event A"],

                           [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                               [MMSReportingUtils reportEventB];
                           }
                                                    title:@"Report event B"],

                           [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                               [MMSReportingUtils reportError];
                           }
                                                    title:@"Report error"],
                           
                           [MMSListItem listItemWithBlock:^(MMSListViewController *lc) {
                               [MMSReportingUtils reportException];
                           }
                                                    title:@"Report exception"],
                           [self reportEventWithParametersItem]
                           ];
    };

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, onceBlock);

    return [reportingItems copy];
}

#pragma mark - View Controller items

+ (MMSListItem *)reportEventWithParametersItem
{
    NSString *action = @"Report Event With Parameters";
    NSString *title = @"Event with parameters";
    MMSListItemBlock showEventWithCustomParametersController = ^(MMSListViewController *lc) {
        MMSDictionaryEditorController *controller = [[MMSDictionaryEditorController alloc] init];
        controller.dictionaryHandler = ^(NSDictionary *dictionary) {
            [YMMYandexMetrica reportEvent:@"EVENT-WITH-CUSTOM-PARAMS" parameters:dictionary onFailure:^(NSError *error) {
                NSLog(@"error: %@", [error localizedDescription]);
            }];
        };
        controller.navigationItem.title = title;
        controller.actionTitle = action;
        [lc.navigationController pushViewController:controller animated:YES];
    };
    return [MMSListItem listItemWithBlock:showEventWithCustomParametersController title:action];
}

+ (MMSListItem *)crashEnvironmentEditorItem
{
    NSString *title = @"Crash Environment";
    MMSListItemBlock showEventWithCustomParametersController = ^(MMSListViewController *lc) {
        MMSDictionaryEditorController *environmentEditor = [[MMSDictionaryEditorController alloc] init];
        environmentEditor.emptyValuesAllowed = YES;
        environmentEditor.dictionaryHandler = ^(NSDictionary *dictionary) {
            [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                if (value.length == 0) {
                    value = nil;
                }
                [YMMYandexMetrica setEnvironmentValue:value forKey:key];
            }];
        };
        environmentEditor.navigationItem.title = @"Crash Environment";
        environmentEditor.actionTitle = @"Set Crash Environment";
        [lc.navigationController pushViewController:environmentEditor animated:YES];
    };
    return [MMSListItem listItemWithBlock:showEventWithCustomParametersController title:title];
}

@end
