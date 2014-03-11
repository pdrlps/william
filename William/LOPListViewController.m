//
//  LOPListViewController.m
//  William
//
//  Created by Pedro Lopes on 05/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPListViewController.h"
#import "LOPTaskTableViewCell.h"
#import "LOPEditViewController.h"
#import "LOPTaskTextField.h"
#import "LOPDurationPickerViewController.h"
#import "LOPTimeButton.h"
#import <Crashlytics/Crashlytics.h>

// CocoaPods
#import <SAMGradientView/SAMGradientView.h>

@interface LOPListViewController () <UITextFieldDelegate, LOPEditViewControllerDelegate, LOPDurationPickerViewControllerDelegate>

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic) NSMutableArray *completedTasks;
@property (nonatomic) NSIndexPath *editingIndexPath;
@property (nonatomic, readonly) LOPTaskTextField *textField;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSIndexPath *tickingIndexPath;

@end

@implementation LOPListViewController

# pragma  mark - Accessors

@synthesize textField = _textField;
@synthesize timer = _timer;

-(LOPTaskTextField *)textField {
    if (!_textField) {
        _textField = [[LOPTaskTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 56.0f)];
        _textField.delegate = self;
    }
    
    return  _textField;
    
}

-(void)setTimer:(NSTimer *)timer {
    if(_timer != timer) {
        [_timer invalidate];
    }
    _timer = timer;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:_timer != nil];
}

# pragma mark - UIViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[LOPTaskTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // full background gradient
    SAMGradientView *gradientView = [[SAMGradientView alloc] init];
    gradientView.gradientColors = @[[UIColor colorWithRed:0.32 green:0.40 blue:0.48 alpha:1], [UIColor colorWithRed:0.17 green:0.19 blue:0.23 alpha:1]];
    self.tableView.backgroundView = gradientView;
    
    // separators
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.00];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // rows
    self.tableView.rowHeight = 56.0f;
    // set input text to table header
    self.tableView.tableHeaderView = self.textField;
    
    // set title image
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit:)];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *loadedTasks = [userDefaults arrayForKey:@"tasks"];
    self.tasks = [[NSMutableArray alloc] initWithArray:loadedTasks];
    
    loadedTasks = [userDefaults arrayForKey:@"completedTasks"];
    self.completedTasks = [[NSMutableArray alloc] initWithArray:loadedTasks];
    
    [self.tableView reloadData];
    
    for (NSInteger i = 0; i < self.tasks.count; i++) {
        NSDictionary *task = self.tasks[i];
        if(task[@"startedTimingAt"]) {
            [self startTimingIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            break;
        }
    }
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.tasks.count == 0 && self.completedTasks.count == 0) {
        [self.textField becomeFirstResponder];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if(self.tickingIndexPath) {
        [self stopTimingIndexPath:self.tickingIndexPath reload:YES];
    }
    
    if(editing) {
        [self.textField resignFirstResponder];
        self.navigationItem.rightBarButtonItem.image =[UIImage imageNamed:@"done"];
    } else {
        self.navigationItem.rightBarButtonItem.image =[UIImage imageNamed:@"pencil"];
    }
}


# pragma mark - Actions

-(void)toggleEdit:(id) sender {
    
    [self setEditing:!self.editing animated:YES];
}

-(void)editTask:(UITapGestureRecognizer *) sender {
    self.editingIndexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender.view];
    
    LOPEditViewController *viewController = [[LOPEditViewController alloc] init];
    viewController.delegate = self;
    viewController.text = [self taskForIndexPath:self.editingIndexPath];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    [self setEditing:NO animated:YES];
}

-(void)time:(id)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath =[self.tableView indexPathForRowAtPoint:point];
    
    
    NSDictionary *task = [self taskForIndexPath:indexPath];
    
    if (self.editing) {
        [self pickTimeWithIndexPath:indexPath];
        return;
    }
    
    // With time, start tick
    NSNumber *timeRemaining = task[@"timeRemaining"];
    if(timeRemaining) {
        // alreadt ticking stop
        if([indexPath isEqual:self.tickingIndexPath]) {
            [self stopTimingIndexPath:indexPath reload:YES];
        } else {
            if(self.tickingIndexPath) {
                [self stopTimingIndexPath:self.tickingIndexPath reload:YES];
            }
            
            [self setTaskValue:[NSDate date] forKey:@"startedTimingAt" indexPath:indexPath];
            [self startTimingIndexPath:indexPath];
        }
        return;
    }
    
    // No time, pick
    [self pickTimeWithIndexPath:indexPath];
    
}

# pragma mark - Private

-(void)pickTimeWithIndexPath:(NSIndexPath * )indexPath {
    self.editingIndexPath = indexPath;
    NSDictionary *task = [self taskForIndexPath:indexPath];
    LOPDurationPickerViewController *viewController = [[LOPDurationPickerViewController alloc] init];
    viewController.delegate = self;
    viewController.duration = [task[@"timeRemaining"] doubleValue];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

-(void)tick:(id)sender {
    if(!self.tickingIndexPath) {
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:@[self.tickingIndexPath] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)save {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.tasks forKey:@"tasks"];
    [userDefaults setObject:self.completedTasks forKey:@"completedTasks"];
    [userDefaults synchronize];
}

- (NSMutableArray *) arrayForSection:(NSInteger) section {
    if (section == 0)
        return self.tasks;
    
    return self.completedTasks;
}

-(NSDictionary *) taskForIndexPath:(NSIndexPath *)indexPath {
    return [self arrayForSection:indexPath.section][indexPath.row];
} 

-(void) setTask:(NSDictionary *)task forIndexPath:(NSIndexPath *)indexPath reload:(BOOL) reload {
    NSMutableArray *array = [self arrayForSection:indexPath.section];
    array[indexPath.row] = task;
    
    if(reload) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self save];
}

-(void)setTaskValue:(id)value forKey:(NSString *)key indexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *task = [[self taskForIndexPath:indexPath] mutableCopy];
    task[key] = value;
    [self setTask:task forIndexPath:indexPath reload:YES];
}

-(void)startTimingIndexPath:(NSIndexPath *)indexPath {
    self.tickingIndexPath = indexPath;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}

-(void)stopTimingIndexPath:(NSIndexPath *)indexPath reload:(BOOL)reload {
    NSDictionary *task = [self taskForIndexPath:indexPath];
    NSDate *startedTimingAt = task[@"startedTimingAt"];
    NSMutableDictionary *saved = [task mutableCopy];
    saved[@"timeRemaining"] = @([task[@"timeRemaining"] doubleValue] - [[NSDate date] timeIntervalSinceDate:startedTimingAt]);
    [saved removeObjectForKey:@"startedTimingAt"];
    [self setTask:saved forIndexPath:indexPath reload:NO];
    self.timer = nil;
    self.tickingIndexPath = nil;
    
    if (reload) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

# pragma  mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self arrayForSection:indexPath.section] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self save];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self arrayForSection: section] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LOPTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
	[cell.editGestureRecognizer addTarget:self action:@selector(editTask:)];
	[cell.timeButton addTarget:self action:@selector(time:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
	cell.task = [self taskForIndexPath:indexPath];
	cell.completed = indexPath.section == 1;
	
	return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *array = [self arrayForSection:sourceIndexPath.section];
    
    NSString *task = array[sourceIndexPath.row];
    [array removeObjectAtIndex:sourceIndexPath.row];
    [array insertObject:task atIndex:destinationIndexPath.row];
    
    [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [self save];
}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.tickingIndexPath]) {
        return NO;
    }
    return YES;
}

# pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.textField resignFirstResponder];
}

# pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textField resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];
    
    // Uncompleted, move to completed.
    if (indexPath.section == 0) {
        if([indexPath isEqual:self.tickingIndexPath]) {
            [self stopTimingIndexPath:indexPath reload:NO];
        }
        
        NSString *task = self.tasks[indexPath.row];
        [self.tasks removeObjectAtIndex:indexPath.row];
        [self.completedTasks insertObject:task atIndex:0];
        
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];

    }
    // Completed, move to uncompleted.
    else {
        NSString *task = self.completedTasks[indexPath.row];
        [self.completedTasks removeObjectAtIndex:indexPath.row];
        [self.tasks insertObject:task atIndex:0];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

    }
       // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView endUpdates]; 
    
    [self save];
}

# pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setEditing:NO animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        textField.text = nil;
        [textField resignFirstResponder];
        return NO;
    }
    
    NSDictionary *task = @{
        @"text":textField.text
     };
    
    [self.tasks insertObject:task atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade ];

    textField.text = nil;
    
    [self save];

    return NO;
}

# pragma mark - WEditViewControllerDelegate

-(void)editViewController:(LOPEditViewController *)editViewController didEditText:(NSString *)text {
    [self setTaskValue:text forKey:@"text" indexPath:self.editingIndexPath];
}

# pragma mark - WDurationPickerViewControllerDelegate

-(void)durationPickerViewController:(LOPDurationPickerViewController *)editTimeViewController didPickDuration:(NSTimeInterval)duration {
    [self setTaskValue:@(duration) forKey:@"timeRemaining" indexPath:self.editingIndexPath];
}

@end
