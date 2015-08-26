/*
 *  MMSListItem.h
 *
 * This file is a part of the AppMetrica
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
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
