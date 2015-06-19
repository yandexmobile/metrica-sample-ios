/*
 *  MMSDictionaryEditorController.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2015 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import "MMSDictionaryEditorController.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>
#import "MMSKeyValueInputView.h"

@interface MMSDictionaryEditorController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet MMSKeyValueInputView *parametersInput;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;

@end

@implementation MMSDictionaryEditorController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.parametersInput.emptyValuesAllowed = self.emptyValuesAllowed;
    [self.actionButton setTitle:self.actionTitle forState:UIControlStateNormal];
}

- (void)setEmptyValuesAllowed:(BOOL)emptyValuesAllowed
{
    if (_emptyValuesAllowed != emptyValuesAllowed) {
        _emptyValuesAllowed = emptyValuesAllowed;
        self.parametersInput.emptyValuesAllowed = emptyValuesAllowed;
    }
}

- (void)setActionTitle:(NSString *)actionTitle
{
    if ([_actionTitle isEqualToString:actionTitle] == NO) {
        _actionTitle = [actionTitle copy];
        [self.actionButton setTitle:_actionTitle forState:UIControlStateNormal];
    }
}

- (IBAction)handleDictionary:(id)sender
{
    if (self.dictionaryHandler != nil) {
        self.dictionaryHandler(self.parametersInput.value);
    }
}

@end
