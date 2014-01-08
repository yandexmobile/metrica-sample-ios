/*
 *  MMSViewController.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2013 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>

#import "MMSViewController.h"
#import "MMSCrashUtils.h"

@interface MMSViewController ()

- (IBAction)reportEventA:(id)sender;
- (IBAction)reportEventB:(id)sender;
- (IBAction)reportError:(id)sender;
- (IBAction)reportException:(id)sender;

@end

@implementation MMSViewController

- (IBAction)reportEventA:(id)sender
{
    static int counter = 0;
    ++counter;
    NSError *error = nil;
    NSString *name = [NSString stringWithFormat:@"EVENT-A %d", counter];
    [YMMCounter reportEvent:name failure:&error];

    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (IBAction)reportEventB:(id)sender
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"EVENT-B %d", counter];

    NSError *error = nil;
    [YMMCounter reportEvent:name failure:&error];

    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (IBAction)reportError:(id)sender
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"ERROR %d", counter];

    NSError *error = nil;
    [YMMCounter reportError:name exception:nil failure:&error];

    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

- (IBAction)reportException:(id)sender
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"EXCEPTION %d", counter];

    NSError *error = nil;
    NSException *testException = [NSException exceptionWithName:name
                                                     reason:@"test exception"
                                                   userInfo:nil];
    @try {
        [testException raise];
    }
    @catch (NSException *exception) {
        [YMMCounter reportError:name exception:exception failure:&error];
    }
    @finally {
        testException = nil;
    }

    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

#pragma mark - app crash methods

- (IBAction)crash:(id)sender
{
    [MMSCrashUtils randomCrash];
}

@end
