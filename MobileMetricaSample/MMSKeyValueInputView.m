/*
 * Version for iOS
 * © 2013–2018 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "MMSKeyValueInputView.h"

@interface MMSKeyValueInputView () <UITextFieldDelegate>

@property (nonatomic, weak) UITextView *valueTextView;
@property (nonatomic, weak) UITextField *keyTextField;
@property (nonatomic, weak) UITextField *valueTextField;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) UIButton *clearButton;
@property (nonatomic, strong) NSMutableDictionary *pairs;

@end

@implementation MMSKeyValueInputView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self configure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    _pairs = [NSMutableDictionary dictionary];
    UITextField *keyTextField = [self textfield];
    keyTextField.placeholder = @"Key";
    [self addSubview:keyTextField];
    _keyTextField = keyTextField;

    UITextField *valueTextField = [self textfield];
    valueTextField.placeholder = @"Value";
    [self addSubview:valueTextField];
    _valueTextField = valueTextField;

    UIButton *addButton = [self button];
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addPair) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
    _addButton = addButton;

    UIButton *clearButton = [self button];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    _clearButton = clearButton;

    UITextView *valueTextView = [[UITextView alloc] init];
    valueTextView.translatesAutoresizingMaskIntoConstraints = NO;
    valueTextView.editable = NO;
    [self addSubview:valueTextView];
    _valueTextView = valueTextView;

    [self configureConstaints];
    [self updateText];
}

- (void)configureConstaints
{
    [self configureTextFieldsConstraints];
    [self configureButtonsConstraints];
    [self configureTextViewConstraints];
}

- (void)configureTextFieldsConstraints
{
    NSDictionary *bindings = [self viewBindings];

    NSArray *keyHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[key]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:bindings];
    NSArray *keyVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[key(40)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:bindings];

    NSArray *valueHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[value]-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:bindings];
    NSArray *valueVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[key]-[value(40)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:bindings];
    [self addConstraints:keyHorizontal];
    [self addConstraints:keyVertical];
    [self addConstraints:valueHorizontal];
    [self addConstraints:valueVertical];
}

- (void)configureButtonsConstraints
{
    NSDictionary *bindings = [self viewBindings];

    NSArray *addHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[add(40)]-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:bindings];
    NSArray *addVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[value]-[add(40)]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:bindings];
    NSArray *clearHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[clear(60)]-[add]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:bindings];
    NSArray *clearVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[value]-[clear(40)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:bindings];
    [self addConstraints:addHorizontal];
    [self addConstraints:addVertical];
    [self addConstraints:clearHorizontal];
    [self addConstraints:clearVertical];
}

- (void)configureTextViewConstraints
{
    NSDictionary *bindings = [self viewBindings];

    NSArray *textHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[text]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:bindings];
    NSArray *textVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[clear]-[text]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:bindings];



    [self addConstraints:textHorizontal];
    [self addConstraints:textVertical];
}

- (NSDictionary *)viewBindings
{
    UITextField *key = self.keyTextField;
    UITextField *value = self.valueTextField;
    UIButton *add = self.addButton;
    UIButton *clear = self.clearButton;
    UITextView *text = self.valueTextView;
    return NSDictionaryOfVariableBindings(key, value, add, clear, text);
}

#pragma mark - Controls

- (UITextField *)textfield
{
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.delegate = self;
    return textField;
}

- (UIButton *)button
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    return button;
}

#pragma mark - Actions

- (void)clear
{
    [self.pairs removeAllObjects];
    [self updateText];
}

- (void)addPair
{
    NSString *key = self.keyTextField.text;
    NSString *value = self.valueTextField.text;
    if (key.length > 0 && (value.length > 0 || self.emptyValuesAllowed)) {
        self.pairs[key] = value;
    }
    self.keyTextField.text = @"";
    self.valueTextField.text = @"";
    [self updateText];
}

- (void)updateText
{
    self.valueTextView.text = self.pairs.description;
}

#pragma mark - Accessors

- (NSDictionary *)value
{
    return [self.pairs mutableCopy];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
