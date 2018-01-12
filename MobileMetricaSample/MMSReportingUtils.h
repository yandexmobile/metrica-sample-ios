/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <Foundation/Foundation.h>

@interface MMSReportingUtils : NSObject

+ (void)reportEventA;
+ (void)reportEventB;
+ (void)reportEventWithName:(NSString *)name parameters:(NSDictionary *)params;
+ (void)reportError;
+ (void)reportException;

@end
