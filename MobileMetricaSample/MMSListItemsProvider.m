/*
 *  MMSListItemsProvider.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2014 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import "MMSListItemsProvider.h"
#import "MMSCrashUtils.h"
#import "MMSReportingUtils.h"
#import "MMSListItem.h"
#import "MMSListViewController.h"
#import "MMSEventWithCustomParametersController.h"

@implementation MMSListItemsProvider

+ (NSArray *)crashingListItems
{
    static NSArray *crashItems = nil;
    void (^onceBlock)() = ^{
        crashItems =
        @[
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
        MMSListItemBlock showEventWithCustomParametersController = ^(MMSListViewController *lc) {
            MMSEventWithCustomParametersController *controller = [[MMSEventWithCustomParametersController alloc] init];
            controller.navigationItem.title = @"Report Event With Parameters";
            [lc.navigationController pushViewController:controller animated:YES];
        };
        reportingItems =
        @[
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
          [MMSListItem listItemWithBlock:showEventWithCustomParametersController
                                   title:@"Report Event With Parameters"
                              disclosing:YES]
          ];
    };

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, onceBlock);

    return [reportingItems copy];
}

@end
