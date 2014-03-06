//
//  LOPTaskTableViewCell.m
//  William
//
//  Created by Pedro Lopes on 13/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPTaskTableViewCell.h"
#import "LOPTimeButton.h"

@implementation LOPTaskTableViewCell

@synthesize task = _task;
@synthesize completed = _completed;
@synthesize editGestureRecognizer = _editGestureRecognizer;
@synthesize timeButton = _timeButton;


# pragma  mark - Accessors

-(LOPTimeButton *)timeButton{
    if(!_timeButton) {
        _timeButton = [[LOPTimeButton alloc] init];
    }
    
    return _timeButton;
}

-(void) setTask:(NSDictionary *)task {
    _task = task;
    self.textLabel.text = task[@"text"];
    
    [self updateTimeButton];
    
}

-(void)setCompleted:(BOOL)completed {
    _completed = completed;
    self.timeButton.hidden = _completed;
    
    if (_completed) {
        self.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    } else {
        self.textLabel.textColor = [UIColor whiteColor];
    }
}

-(UITapGestureRecognizer *) editGestureRecognizer {
    if(_editGestureRecognizer == nil) {
        _editGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        _editGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_editGestureRecognizer];
    }
    return _editGestureRecognizer;
}

#pragma mark - UIView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.contentView.bounds.size;
    CGSize buttonSize = [self.timeButton sizeThatFits:CGSizeMake(56.0f, size.height)];
    self.timeButton.frame = CGRectMake(size.width - buttonSize.width, 0.0f,  buttonSize.width, buttonSize.height);

    CGRect frame = self.textLabel.frame;
    frame.size.width = size.width - frame.origin.x - 8.0f - buttonSize.width;
    self.textLabel.frame = frame;
}

# pragma mark - UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self.contentView addSubview:self.timeButton];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16.0f];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:0.61 green:0.71 blue:0.53 alpha:1];
        
        self.selectedBackgroundView = view;
    }
    
    return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    self.editGestureRecognizer.enabled = editing;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.task = nil;
}

# pragma mark - UIGestureRecognizer

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    return CGRectContainsPoint(self.contentView.frame, point);
}

# pragma mark - Private
-(void)updateTimeButton {
    self.timeButton.ticking = self.task[@"startedTimingAt"] != nil;
    
    NSNumber *timeRemaining = self.task[@"timeRemaining"];
    if(!timeRemaining){
        self.timeButton.time = nil;
        return;
    }
    
    NSTimeInterval seconds = [self.task[@"timeRemaining"] doubleValue];
    if(self.timeButton.ticking) {
        NSDate *startedTimingAt = self.task[@"startedTimingAt"];
        seconds -= [[NSDate date] timeIntervalSinceDate:startedTimingAt];
    }
    
    self.timeButton.time = @(seconds); 
}

@end
