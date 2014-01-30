/*
 *  MMSReportingUtils.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2014 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import "MMSReportingUtils.h"
#import <YandexMobileMetrica/YMMCounter.h>

@implementation MMSReportingUtils

+ (void)reportEventA
{
    static int counter = 0;
    ++counter;
    [[self class] reportEventWithName:@"A" index:counter];
}

+ (void)reportEventB
{
    static int counter = 0;
    ++counter;
    [[self class] reportEventWithName:@"B" index:counter];
}

+ (void)reportEventWithName:(NSString *)name index:(int)index
{
    NSString *message = [NSString stringWithFormat:@"EVENT-%@ %d", name, index];

    NSError * __autoreleasing error = nil;
    [YMMCounter reportEvent:message failure:&error];

    if (error != nil) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

+ (void)reportError
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"ERROR %d", counter];

    NSError * __autoreleasing error = nil;
    [YMMCounter reportError:name exception:nil failure:&error];

    if (error != nil) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

+ (void)reportException
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"EXCEPTION %d", counter];

    NSError * __autoreleasing error = nil;
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

    if (error != nil) {
        NSLog(@"error: %@", [error localizedDescription]);
    }
}

@end
