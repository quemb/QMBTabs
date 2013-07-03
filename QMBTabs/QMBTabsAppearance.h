//
//  QMBTabsAppearance.h
//  VSM
//
//  Created by Toni Möckel on 03.07.13.
//  Copyright (c) 2013 DREEBIT GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMBTabsAppearance : NSObject

//Tabs
@property (nonatomic,strong) UIColor *tabLabelColorDisabled;
@property (nonatomic,strong) UIColor *tabLabelColorEnabled;
@property (nonatomic,strong) UIColor *tabLabelColorHighlighted;

@property (nonatomic,strong) UIFont *tabLabelFont;

@property (nonatomic) NSTextAlignment tabLabelAlignment;

@property (nonatomic,strong) UIColor *tabBackgroundColorEnabled;
@property (nonatomic,strong) UIColor *tabBackgroundColorHighlighted; // = tabBarHighlightColor
@property (nonatomic,strong) UIColor *tabBackgroundColorDisabled;

@property (nonatomic,strong) UIImage *tabCloseButtonImage;

@property (nonatomic,strong) UIColor *tabStrokeColorEnabled;
@property (nonatomic,strong) UIColor *tabStrokeColorDisabled;
@property (nonatomic,strong) UIColor *tabStrokeColorHighlighted; // = tabBarStrokeHighlightColor

//TabBar
@property (nonatomic,strong) UIColor *tabBarBackgroundColor;
@property (nonatomic,strong) UIColor *tabBarHighlightColor;
@property (nonatomic,strong) UIColor *tabBarStrokeHighlightColor;

@end
