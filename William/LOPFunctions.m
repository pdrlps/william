//
//  LOPFunctions.m
//  William
//
//  Created by Pedro Lopes on 15/03/14.
//  Copyright (c) 2014 Pedro Lopes. All rights reserved.
//

#import "LOPFunctions.h"

@implementation LOPFunctions

#pragma mark - DynamicType

+ (UIFont *)preferredGillSansFontForTextStyle:(NSString *)textStyle {
	// choose the font size, defaults to 16
	CGFloat fontSize = 16.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
    
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = 12.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 14.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 16.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 18.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 20.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 22.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 24.0;
	}
    
    
	// choose the font weight
	if ([textStyle isEqualToString:UIFontTextStyleHeadline] ||
		[textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        
		return [UIFont fontWithName:@"GillSans" size:fontSize];
        
	} else {
		return [UIFont fontWithName:@"GillSans-Light" size:fontSize];
	}
}

+ (UIFont *)preferredGillSansSmallFontForTextStyle:(NSString *)textStyle {
	// choose the small font size, defaults to 12
	CGFloat fontSize = 12.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
    
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = 8.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 10.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 12.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 14.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 16.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 18.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 20.0;
	}
    
    
	// choose the font weight
	if ([textStyle isEqualToString:UIFontTextStyleHeadline] ||
		[textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        
		return [UIFont fontWithName:@"GillSans" size:fontSize];
        
	} else {
		return [UIFont fontWithName:@"GillSans-Light" size:fontSize];
	}
}

+ (UIFont *)preferredGillSansItalicFontForTextStyle:(NSString *)textStyle {
	// choose the font size, defaults to 16
	CGFloat fontSize = 16.0;
	NSString *contentSize = [UIApplication sharedApplication].preferredContentSizeCategory;
    
	if ([contentSize isEqualToString:UIContentSizeCategoryExtraSmall]) {
		fontSize = 12.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategorySmall]) {
		fontSize = 14.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryMedium]) {
		fontSize = 16.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryLarge]) {
		fontSize = 18.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraLarge]) {
		fontSize = 20.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
		fontSize = 22.0;
        
	} else if ([contentSize isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
		fontSize = 24.0;
	}
    
    
	// choose the font weight
	if ([textStyle isEqualToString:UIFontTextStyleHeadline] ||
		[textStyle isEqualToString:UIFontTextStyleSubheadline]) {
        
		return [UIFont fontWithName:@"GillSans-Italic" size:fontSize];
        
	} else {
		return [UIFont fontWithName:@"GillSans-LightItalic" size:fontSize];
	}
}


@end
