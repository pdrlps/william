//
//  LOPTimeButton.m
//  William
//
//  Created by Pedro Lopes on 05/03/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPTimeButton.h"

@interface LOPTimeButton()

@property (nonatomic, readonly) UIView *circleView;

@end

@implementation LOPTimeButton


#pragma mark - Accessors
@synthesize time = _time;
@synthesize ticking = _ticking;
@synthesize circleView = _circleView;

-(UIView *)circleView {
    if(!_circleView) {
        _circleView = [[UIView alloc] init];
        _circleView.userInteractionEnabled = NO;
        _circleView.layer.cornerRadius = 16.0f;
    }
    return _circleView;
}

-(void)setTime:(NSNumber *)time {
    _time = time;
    
    [self update];
}

-(void)setTicking:(BOOL)ticking{
    _ticking = ticking;
    
    [self update];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.circleView];
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0f];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

        [self update];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    
    [self.titleLabel sizeToFit];
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = roundf((size.width - titleFrame.size.width)/2.0f);
    titleFrame.origin.y = roundf((size.height - titleFrame.size.height)/2.0f);
    self.titleLabel.frame = titleFrame;
    
    self.circleView.frame = CGRectMake(MIN(roundf((size.width - 32.0f)/2),titleFrame.origin.x - 8.0f), roundf((size.height - 32.0f) / 2.0f), MAX(32.0f, titleFrame.size.width + 16.0f), 32.0f);
    
}

-(CGSize)sizeThatFits:(CGSize)size{
    [self layoutSubviews];
    
    size.width = self.circleView.bounds.size.width + 20.0f;
    return size;
}

#pragma mark - Private

-(void)update {
    if(self.time) {
        NSString *title;
        [self setImage:Nil forState:UIControlStateNormal];
        NSTimeInterval timeInterval = [self.time doubleValue];
        
        if(self.ticking) {
            NSMutableString *dateFormat = [[NSMutableString alloc] init];

            if(timeInterval < 0) {
                [dateFormat appendString:@"-"];
            }
            
            if (fabsf(timeInterval) > 60 * 60) {
                [dateFormat appendString:@"HH:"];
            }
            
            if (fabsf(timeInterval) > 60) {
                [dateFormat appendString:@"mm:"];
            }
            [dateFormat appendString:@"ss"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = dateFormat;
            formatter.timeZone =  [NSTimeZone timeZoneForSecondsFromGMT:0];
            
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterval];
            title = [formatter stringFromDate:date];
            
            if ([self.time integerValue] >= 0) {
                self.circleView.backgroundColor = [UIColor colorWithRed:0.61 green:0.71 blue:0.53 alpha:1];
            } else {
                self.circleView.backgroundColor = [UIColor colorWithRed:0.64 green:0.27 blue:0.27 alpha:1];
            }
        } else {
            NSMutableString *text = [[NSMutableString alloc] init];
            
            if (fabsf(timeInterval) < 60 ) {
                //show seconds
                [text appendFormat:@"%.0fs", timeInterval];
            } else if (fabsf(timeInterval) < 60*60) {
                // show minutes
                [text appendFormat:@"%.0fm", floorf(timeInterval / 60)];
            } else {
                // show hours
                [text appendFormat:@"%.0fh", floorf(timeInterval / 60 / 60)];
            }
            title = text;
            self. circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.16f];
        }
        
        [self setTitle:title forState:UIControlStateNormal];
        
        return;
    }
    
    [self setTitle:nil forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    self.circleView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.04f];
    
}

@end
