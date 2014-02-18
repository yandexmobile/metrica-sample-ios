/*
 *  MMSAppDelegate.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2013 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <YandexMobileMetrica/YandexMobileMetrica.h>

#import "MMSAppDelegate.h"
#import "MMSRootControllerProvider.h"
#import "asl.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import <AdSupport/AdSupport.h>

@interface MMSAppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MMSAppDelegate

+ (void)initialize
{
    if ([self class] == [MMSAppDelegate class]) {
        //Attention! setIDFA should be called only in applications that display ads
        //All other apps will be rejected from AppStore.
        [self setIDFA];
        // TODO: set appropriate application key provided by Yandex.Metrica
        [YMMCounter startWithAPIKey:1111];
        //manual log level setting for whole library
        //[YMMCounter setLogLevel:ASL_LEVEL_DEBUG];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootController = [MMSRootControllerProvider rootController];
    self.window.rootViewController = rootController;

    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLocationUpdates];
    });

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self shutdownLocationUpdates];
    __block UIBackgroundTaskIdentifier taskId = UIBackgroundTaskInvalid;
    taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background event expired: %llu", (unsigned long long int)taskId);
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self startLocationUpdates];
}

#pragma mark - Working with Location Updates

- (void)startLocationUpdates
{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)shutdownLocationUpdates
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}

#pragma mark - CLLocationManagerDelegate Implementation

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [YMMCounter setLocation:newLocation];
}

#pragma mark utils
//Attention!
//Application should display ads to be allowed to use AdSupport.framework
+ (void)setIDFA
{
    Class managerClass = [ASIdentifierManager class];
    if (managerClass != Nil) {
        id manager = [managerClass sharedManager];
        if ([manager isAdvertisingTrackingEnabled]) {
            NSUUID *value = [manager advertisingIdentifier];
            [YMMCounter setIDFA:[value UUIDString]];
        }
    }
}

@end
