/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <Foundation/Foundation.h>

@class MMSListViewController;

typedef void(^MMSListItemBlock)(MMSListViewController *);

@interface MMSListItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) MMSListItemBlock block;
@property (nonatomic, assign) BOOL disclosing;

+ (instancetype)listItemWithBlock:(MMSListItemBlock)block
                            title:(NSString *)title
                       disclosing:(BOOL)disclosing;

+ (instancetype)listItemWithBlock:(MMSListItemBlock)block
                            title:(NSString *)title;

- (instancetype)initWithBlock:(MMSListItemBlock)block
                        title:(NSString *)title
                   disclosing:(BOOL)disclosing;

@end
