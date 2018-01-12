/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSReportingUtils.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@implementation MMSReportingUtils

+ (void)reportEventWithName:(NSString *)name
{
    [YMMYandexMetrica reportEvent:name onFailure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

+ (void)reportEventWithName:(NSString *)name index:(int)index
{
    NSString *message = [NSString stringWithFormat:@"EVENT-%@ %d", name, index];
    [[self class] reportEventWithName:message];
}

+ (void)reportErrorWithName:(NSString *)name exception:(NSException *)exception
{
    [YMMYandexMetrica reportError:name exception:exception onFailure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

+ (void)reportEventWithName:(NSString *)name parameters:(NSDictionary *)params
{
    [YMMYandexMetrica reportEvent:name parameters:params onFailure:^(NSError *error) {
         NSLog(@"error: %@", [error localizedDescription]);
    }];
}

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

+ (void)reportError
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"ERROR %d", counter];

    [[self class] reportErrorWithName:name exception:nil];
}

+ (void)reportException
{
    static int counter = 0;
    ++counter;
    NSString *name = [NSString stringWithFormat:@"EXCEPTION %d", counter];

    NSException *testException = [NSException exceptionWithName:name
                                                         reason:@"test exception"
                                                       userInfo:nil];
    @try {
        [testException raise];
    }
    @catch (NSException *exception) {
        [[self class] reportErrorWithName:name exception:exception];
    }
    @finally {
        testException = nil;
    }
}

@end
