/*
 *  MMSEventWithCustomParametersController.m
 *
 * This file is a part of the Yandex.Metrica for Apps.
 *
 * Version for iOS © 2014 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at http://legal.yandex.com/metrica_termsofuse/
 */

#import "MMSEventWithCustomParametersController.h"
#import <YandexMobileMetrica/YandexMobileMetrica.h>

@interface MMSEventWithCustomParametersController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextView *customParamsTextView;
@property (nonatomic, weak) IBOutlet UITextField *keyTextField;
@property (nonatomic, weak) IBOutlet UITextField *valueTextField;
@property (nonatomic, strong) NSMutableDictionary *customParams;

@end

@implementation MMSEventWithCustomParametersController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Event with parameters.";
    }
    return self;
}

#pragma mark - Events Handling

- (IBAction)addCustomParam:(id)sender
{
    if (self.valueTextField.text.length != 0 && self.keyTextField.text.length != 0) {
        [self.customParams setObject:self.valueTextField.text forKey:self.keyTextField.text];
    }
    else {
        UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                         message:@"Fill please both fields!"
                                                        delegate:self cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [notice show];
    }
    [self updateCustomParamsTextView];
}

- (void)updateCustomParamsTextView
{
    self.customParamsTextView.text = self.customParams.description;
}

- (IBAction)clearCustomParams:(id)sender
{
    [self.customParams removeAllObjects];
    [self updateCustomParamsTextView];
}

- (IBAction)reportEventWithCustomParameters:(id)sender
{
    [YMMYandexMetrica reportEvent:@"EVENT-WITH-CUSTOM-PARAMS"
                       parameters:self.customParams
                        onFailure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
    }];
}

#pragma mark view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customParams = [NSMutableDictionary dictionary];
    [self updateCustomParamsTextView];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
