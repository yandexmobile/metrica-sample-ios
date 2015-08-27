/*
 *  MMSReportingUtils.h
 *
 * This file is a part of the AppMetrica
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <Foundation/Foundation.h>

@interface MMSReportingUtils : NSObject

+ (void)reportEventA;
+ (void)reportEventB;
+ (void)reportEventWithName:(NSString *)name parameters:(NSDictionary *)params;
+ (void)reportError;
+ (void)reportException;

@end
