/*
 *  MMSAppDelegate.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "MMSAppDelegate.h"
#import "MMSRootControllerProvider.h"
#import "asl.h"

@implementation MMSAppDelegate

+ (void)initialize
{
    if ([self class] == [MMSAppDelegate class]) {
        [YMMYandexMetrica startWithAPIKey:@"1111"];
        //manual log level setting for whole library
        //[YMMYandexMetrica setLogLevel:ASL_LEVEL_DEBUG];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootController = [MMSRootControllerProvider rootController];
    self.window.rootViewController = rootController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    __block UIBackgroundTaskIdentifier taskId = UIBackgroundTaskInvalid;
    taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background event expired: %llu", (unsigned long long int)taskId);
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
}

@end
