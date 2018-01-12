/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSCrashUtils.h"
#include <stdexcept>

void stdThrowingCode()
{
    throw std::runtime_error("My Exception");
}

class MyException: public std::exception
{
public:
    virtual const char *what() const noexcept;
};

const char *MyException::what() const noexcept
{
    return "Something bad happened...";
}

@interface MyProxy: NSProxy @end
@implementation MyProxy @end

class MyCPPClass
{
public:
    void throwAnException()
    {
        throw MyException();
    }
};

@interface RefHolder : NSObject
{
    __unsafe_unretained id _ref;
}
@property(nonatomic, readwrite, unsafe_unretained) id ref;

@end

@implementation RefHolder

- (id)ref
{
    return _ref;
}

- (void)setRef:(id) ref
{
    _ref = ref;
}

@end

@implementation MMSCrashUtils

+ (void)deadbeef
{
    NSObject *a = (__bridge NSObject *)(void *)0xDEADBEEF;
    [a class];
}

+ (void)releaseNULL
{
#ifndef __clang_analyzer__
    CFRelease(NULL);
#endif
}

+ (void)dereferenceNullPointer
{
#ifndef __clang_analyzer__
    int *g_crasher_null_ptr = NULL;
    *g_crasher_null_ptr = 1;
#endif
}

+ (void)useCorruptObject
{
    // From http://landonf.bikemonkey.org/2011/09/14

    // Random data
    void *pointers[] = {NULL, NULL, NULL};
    void *randomData[] = {(void *)"a", (void *)"b", pointers, (void *)"d", (void *)"e", (void *)"f"};

    // A corrupted/under-retained/re-used piece of memory
    struct {void *isa;} corruptObj = {randomData};

    // Message an invalid/corrupt object.
    // This will deadlock if called in a crash handler.
    [(__bridge id)&corruptObj class];
}

+ (void)indexOutOfBounds
{
    [@[] objectAtIndex:0];
}

+ (void)raiseException
{
    [NSException raise:@"Custom exception in main queue" format:nil];
}

+ (void)raiseExceptionInDefaultQueue
{
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{
        sleep(5);
    });

    dispatch_async(defaultQueue, ^{
        [NSException raise:@"Custom exception in default queue" format:nil];
    });
}

+ (void)raiseExceptionInCustomQueue
{
    dispatch_queue_t ivarQueue = dispatch_queue_create("ru.yandex.mobile.metrica.sample", NULL);

    dispatch_async(ivarQueue, ^{
        sleep(5);
    });

    dispatch_async(ivarQueue, ^{
        [NSException raise:@"Custom exception in default queue" format:nil];
    });
}

+ (void)objcHandlerCalledFromARunLoop
{
    //http://stackoverflow.com/questions/13777446/ios-how-to-get-stack-trace-of-an-unhandled-stdexception
    //    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    //without dispatching, stack trace displayed by Organizer would be incorrect.
    stdThrowingCode();
    //    });
}

//Following crashing methods were borrowed from KSCrash
//https://github.com/kstenerud/KSCrash/blob/master/Source/Common-Examples/Crasher.mm

+ (void)throwUncaughtNSException
{
    id data = [NSArray arrayWithObject:@"Hello World"];
    [(NSDictionary *)data objectForKey:0];
}

+ (void)doAbort
{
    abort();
}

+ (void)dereferenceBadPointer
{
    char *ptr = (char *) - 1;
    *ptr = 1;
}

+ (void)spinRunloop
{
#ifndef __clang_analyzer__
    // From http://landonf.bikemonkey.org/2011/09/14
    int *g_crasher_null_ptr = NULL;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ERROR: Run loop should be dead but isn't!");
    });
    *g_crasher_null_ptr = 1;
#endif
}

+ (void)causeStackOverflow
{
    [[self class] causeStackOverflow];
}

+ (void)doIllegalInstruction
{
    unsigned int data[] = {0x11111111, 0x11111111};
    void (*funcptr)() = (void (*)())data;
    funcptr();
}

+ (void)accessDeallocatedObject
{
    RefHolder *ref = [RefHolder new];
    ref.ref = [NSArray arrayWithObjects:@"test1", @"test2", nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Object = %@", [ref.ref objectAtIndex:1]);
    });
}

+ (void)accessDeallocatedPtrProxy
{
    RefHolder *ref = [RefHolder new];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-unsafe-retained-assign"
    ref.ref = [MyProxy alloc];
#pragma clang diagnostic pop

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Object = %@", ref.ref);
    });
}

+ (void)zombieNSException
{
    @try
    {
        NSString *value = @"This is a string";
        [NSException raise:@"TurboEncabulatorException"
                    format:@"Spurving bearing failure: Barescent skor motion non-sinusoidal for %p", value];
    }
    @catch (NSException *exception)
    {
        RefHolder *ref = [RefHolder new];
        ref.ref = exception;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Exception = %@", ref.ref);
        });
    }
}

+ (void)corruptMemory
{
    size_t stringsize = sizeof(uintptr_t) * 2 + 2;
    NSString *string = [NSString stringWithFormat:@"%d", 1];
    NSLog(@"%@", string);
    void *cast = (__bridge void *)string;
    uintptr_t address = (uintptr_t)cast;
    void *ptr = (char *)address + stringsize;
    memset(ptr, 0xa1, 500);
}

+ (void)deadlock
{
    NSLock *lock = [[NSLock alloc] init];
    [lock lock];
    [NSThread sleepForTimeInterval:0.2f];
    dispatch_async(dispatch_get_main_queue(), ^{
        [lock lock];
    });
}

+ (void)throwUncaughtCPPException
{
    MyCPPClass instance;
    instance.throwAnException();
}

@end
