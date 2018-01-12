/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSListItem.h"

@implementation MMSListItem

+ (instancetype)listItemWithBlock:(MMSListItemBlock)block
                            title:(NSString *)title
                       disclosing:(BOOL)disclosing
{
    return [[[self class] alloc] initWithBlock:block
                                         title:title
                                    disclosing:disclosing];
}

+ (instancetype)listItemWithBlock:(MMSListItemBlock)block
                            title:(NSString *)title
{
    return [[self class] listItemWithBlock:block
                                     title:title
                                disclosing:NO];
}

- (instancetype)initWithBlock:(MMSListItemBlock)block
                        title:(NSString *)title
                   disclosing:(BOOL)disclosing
{
    self = [super init];

    if (self != nil) {
        _block = [block copy];
        _title = [title copy];
        _disclosing = disclosing;
    }

    return self;
}

- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"%@\nTitle:%@\nBlock: %@", [super description], self.title, self.block];
    return  result;
}

@end
