/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "MMSAppDelegate.h"
#import "MMSRootControllerProvider.h"

@implementation MMSAppDelegate

+ (void)initialize
{
    if ([self class] == [MMSAppDelegate class]) {
        /* Replace API_KEY with your unique API key. Please, read official documentation how to obtain one:
         https://tech.yandex.com/metrica-mobile-sdk/doc/mobile-sdk-dg/tasks/ios-quickstart-docpage/
         */
        [YMMYandexMetrica activateWithApiKey:@"API_KEY"];
        //manual log setting for whole library
        //[YMMYandexMetrica setLoggingEnabled:YES];
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
