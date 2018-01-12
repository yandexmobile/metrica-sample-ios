/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <Foundation/Foundation.h>

@interface MMSCrashUtils : NSObject

+ (void)deadbeef;
+ (void)releaseNULL;
+ (void)dereferenceNullPointer;
+ (void)useCorruptObject;
+ (void)indexOutOfBounds;
+ (void)raiseException;
+ (void)raiseExceptionInDefaultQueue;
+ (void)raiseExceptionInCustomQueue;
+ (void)objcHandlerCalledFromARunLoop;

//Following crashing methods were borrowed from KSCrash
//https://github.com/kstenerud/KSCrash/blob/master/Source/Common-Examples/Crasher.mm
+ (void)throwUncaughtNSException;
+ (void)doAbort;
+ (void)dereferenceBadPointer;
+ (void)spinRunloop;
+ (void)causeStackOverflow;
+ (void)doIllegalInstruction;
+ (void)accessDeallocatedObject;
+ (void)accessDeallocatedPtrProxy;
+ (void)zombieNSException;
+ (void)corruptMemory;
+ (void)deadlock;
+ (void)throwUncaughtCPPException;

@end
