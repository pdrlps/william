//
//  LOPEditViewController.m
//  William
//
//  Created by Pedro Lopes on 17/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPEditViewController.h"
#import "LOPTaskTextField.h"
#import <SAMGradientView/SAMGradientView.h>

@interface LOPEditViewController () <UITextFieldDelegate>

@property (nonatomic) LOPTaskTextField *textField;
@property (nonatomic) CGRect keyboardFrame;

@end

@implementation LOPEditViewController

# pragma mark - Accessors

@synthesize textField = _textField;
@synthesize text = _text;

-(LOPTaskTextField *)textField {
    if(!_textField) {
        _textField = [[LOPTaskTextField alloc] init];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
    }
    
    return _textField;
}

-(void)setText:(NSDictionary *)task {
    _text = task;
    self.textField.text = task[@"text"];
}

# pragma mark - NSObject

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

# pragma  mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Edit";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"done"] style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:self.view.bounds];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView.gradientColors = @[[UIColor colorWithRed:0.32 green:0.40 blue:0.48 alpha:1], [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1]];
    [self.view addSubview:gradientView];
    
    [self.view addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.bounds.size;
    self.textField.frame = CGRectMake(0.0f, roundf((size.height - self.keyboardFrame.size.height + self.topLayoutGuide.length - 56.0f)/2), size.width, 56.0f);
}

# pragma mark - Actions

-(void)save:(id)sender {
    if ([self.delegate respondsToSelector:@selector(editViewController:didEditText:)]) {
        [self.delegate editViewController:self didEditText:self.textField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma  mark - Private
-(void)keyboardWillChangeFrame:(NSNotification *)notification {
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
         [self viewDidLayoutSubviews];
    }];   
}

# pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length) {
        return NO;
    }
    
    [self save:textField];
    
    return NO;
}

@end
