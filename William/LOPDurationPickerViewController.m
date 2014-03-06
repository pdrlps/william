//
//  LOPEditTimeViewController.m
//  William
//
//  Created by Pedro Lopes on 04/03/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPDurationPickerViewController.h"

#import <SAMGradientView/SAMGradientView.h>

@interface LOPDurationPickerViewController ()

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) UILabel *quote;

@end

@implementation LOPDurationPickerViewController

@synthesize datePicker = _datePicker;
@synthesize duration = _duration;
@synthesize quote = _quote;

# pragma mark - Accessors

- (UILabel *)quote{
    if (!_quote) {
        _quote = [[UILabel alloc] init];
        _quote.numberOfLines = 0;
        _quote.textAlignment = NSTextAlignmentCenter;
        _quote.font = [UIFont fontWithName:@"HelveticaNeue-UltraLightItalic" size:16.0f];
        _quote.textColor = [UIColor whiteColor];
    }
    
    return _quote;
}

-(UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        _datePicker.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    }
    return _datePicker; 
}

-(void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    self.datePicker.countDownDuration = _duration;
}

# pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Timing";
    
   SAMGradientView *gradientView = [[SAMGradientView alloc] initWithFrame:self.view.bounds];
    gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientView.gradientColors = @[[UIColor colorWithRed:0.32 green:0.40 blue:0.48 alpha:1], [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1]];
    [self.view addSubview:gradientView];
    
    // quotes
    NSArray *quotes = @[
                        @"Do one thing every day that scares you.",
                        @"We are what we pretend to be, so we must be careful about what we pretend to be.",
                        @"It's not the load that breaks you down, it's the way you carry it.",
                        @"What you do makes a difference, and you have to decide what kind of difference you want to make.",
                        @"I dream my painting and I paint my dream.",
                        @"Do you want to know who you are? Don't ask. Act! Action will delineate and define you.",
                        @"You can't wait for inspiration. You have to go after it with a club.",
                        @"It's hard to beat a person who never gives up.",
                        ];
    
    self.quote.text = quotes[arc4random_uniform(quotes.count)];
    [self.view addSubview:self.quote];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"done"] style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [self.view addSubview:self.datePicker];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.datePicker sizeToFit];
    
    CGRect frame = self.datePicker.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    self.datePicker.frame = frame;
    
    CGSize size = self.view.bounds.size;
    self.quote.frame = CGRectMake(8.0f, self.topLayoutGuide.length, size.width - 8.0f, size.height -frame.size.height - self.topLayoutGuide.length);
    
    
}


# pragma mark - Actions

-(void)done:(id)sender {
    if ([self.delegate respondsToSelector:@selector(durationPickerViewController:didPickDuration:)]) {
        [self.delegate durationPickerViewController:self didPickDuration:self.datePicker.countDownDuration];
    }
    
    [self cancel:sender];
}

-(void)cancel:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
