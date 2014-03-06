//
//  LOPTaskTableViewCell.h
//  William
//
//  Created by Pedro Lopes on 13/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

@class LOPTimeButton;

@interface LOPTaskTableViewCell : UITableViewCell

@property (nonatomic) NSDictionary *task;
@property (nonatomic) BOOL completed;
@property (nonatomic, readonly) UITapGestureRecognizer *editGestureRecognizer;
@property (nonatomic, readonly) LOPTimeButton *timeButton;

@end
