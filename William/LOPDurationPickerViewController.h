//
//  LOPEditTimeViewController.h
//  William
//
//  Created by Pedro Lopes on 04/03/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

@protocol LOPDurationPickerViewControllerDelegate;

@interface LOPDurationPickerViewController : UIViewController
@property (nonatomic,weak) id<LOPDurationPickerViewControllerDelegate> delegate;
@property (nonatomic) NSTimeInterval duration;
@end

@protocol LOPDurationPickerViewControllerDelegate <NSObject>

@optional

-(void)durationPickerViewController:(LOPDurationPickerViewController *)editTimeViewController didPickDuration:(NSTimeInterval)duration;

@end
