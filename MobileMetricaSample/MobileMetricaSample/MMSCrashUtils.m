/*
 *  MMSCrashUtils.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2013 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import "MMSCrashUtils.h"

@implementation MMSCrashUtils

+ (void)randomCrash
{
    int switcher = arc4random() % 4;
    NSLog(@"randomCrash: %d", switcher);
    switch (switcher) {
        case 0: {
            NSObject *a = (__bridge NSObject *)(void *)0xDEADBEEF;
            [a class];
        }
            break;
        case 1:
            switcher = switcher / 0.0f;
            break;
        case 2:
            [self dereferenceNullPointer];
            break;
        case 3:
            [self useCorruptObject];
        default:
            break;
    }
    NSLog(@"switcher: %d", switcher);
}

+ (void)dereferenceNullPointer
{
    int *g_crasher_null_ptr = NULL;
    *g_crasher_null_ptr = 1;
}

+ (void)useCorruptObject
{
    // From http://landonf.bikemonkey.org/2011/09/14

    // Random data
    void *pointers[] = {NULL, NULL, NULL};
    void *randomData[] = {"a", "b", pointers, "d", "e", "f"};

    // A corrupted/under-retained/re-used piece of memory
    struct {void *isa;} corruptObj = {randomData};

    // Message an invalid/corrupt object.
    // This will deadlock if called in a crash handler.
    [(__bridge id)&corruptObj class];
}

@end
