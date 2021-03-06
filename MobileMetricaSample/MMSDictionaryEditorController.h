/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import <UIKit/UIKit.h>

@interface MMSDictionaryEditorController : UIViewController

@property (nonatomic, copy) void(^dictionaryHandler)(NSDictionary *dictionary);
@property (nonatomic, assign) BOOL emptyValuesAllowed;
@property (nonatomic, copy) NSString *actionTitle;

@end
