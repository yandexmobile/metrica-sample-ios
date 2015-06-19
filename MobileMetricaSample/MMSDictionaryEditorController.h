/*
 *  MMSDictionaryEditorController.h
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import <UIKit/UIKit.h>

@interface MMSDictionaryEditorController : UIViewController

@property (nonatomic, copy) void(^dictionaryHandler)(NSDictionary *dictionary);
@property (nonatomic, assign) BOOL emptyValuesAllowed;
@property (nonatomic, copy) NSString *actionTitle;

@end
