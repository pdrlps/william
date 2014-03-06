//
//  LOPEditViewController.h
//  William
//
//  Created by Pedro Lopes on 17/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

@protocol LOPEditViewControllerDelegate;

@interface LOPEditViewController : UIViewController

@property (nonatomic, weak) id<LOPEditViewControllerDelegate> delegate;
@property (nonatomic) NSDictionary *text;

@end

@protocol LOPEditViewControllerDelegate <NSObject>

@optional

- (void)editViewController:(LOPEditViewController *) editViewController didEditText:(NSString *)text;

@end