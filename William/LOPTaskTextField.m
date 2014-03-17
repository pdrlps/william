//
//  LOPTaskTextField.m
//  William
//
//  Created by Pedro Lopes on 17/02/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPTaskTextField.h"
#import "LOPFunctions.h"

@implementation LOPTaskTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
        self.returnKeyType = UIReturnKeyGo;
        self.placeholder = @"Do this!";
        self.font = [LOPFunctions preferredGillSansFontForTextStyle:[[UIApplication sharedApplication] preferredContentSizeCategory]];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

-(CGRect) textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];

    return CGRectInset(rect, 8.0f, 0.0f);
}

-(CGRect) editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
