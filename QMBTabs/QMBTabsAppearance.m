//
//  QMBTabsAppearance.m
//  VSM
//
//  Created by Toni Möckel on 03.07.13.
//  Copyright (c) 2013 DREEBIT GmbH. All rights reserved.
//

#import "QMBTabsAppearance.h"

@implementation QMBTabsAppearance

- (QMBTabsAppearance *)init {
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    
    return self;
}

- (void)setDefaults {
    _tabLabelColorDisabled = [UIColor lightGrayColor];
    _tabLabelColorEnabled = [UIColor darkGrayColor];
    _tabLabelColorHighlighted = [UIColor whiteColor];
    
    _tabLabelFontDisabled = [UIFont systemFontOfSize:10.0f];
    _tabLabelFontEnabled = [UIFont systemFontOfSize:10.0f];
    _tabLabelFontHighlighted = [UIFont systemFontOfSize:14.0f];
    
    _tabLabelAlignment = NSTextAlignmentCenter;
    
    _tabBarBackgroundColor = [UIColor colorWithRed:.9 green:.9 blue:1 alpha:1];
    
    _tabBackgroundColorEnabled = [UIColor colorWithWhite:0.8f alpha:1.0f];
    _tabBackgroundColorHighlighted = [UIColor colorWithWhite:0.6f alpha:1.0f];
    _tabBackgroundColorDisabled = [UIColor colorWithWhite:0.8f alpha:0.7f];
    
    _tabCloseButtonImage = [UIImage imageNamed:@"QMBTabViewCloseButton"];
    _tabCloseButtonHighlightedImage = [UIImage imageNamed:@"QMBTabViewCloseButtonHighlighted"];
    
    _tabDefaultIconImage = nil;
    _tabDefaultIconHighlightedImage = nil;
    
    _tabShadowWidthOffset = 0.0f;
    _tabShadowHeightOffset = 0.0f;
    _tabShadowBlur = 3.0f;
    _tabShadowColor = [UIColor colorWithWhite:0.2f alpha:0.3f];
    
    _tabSideOffset = 0.0f;
    _tabTopOffset = 5.0f;
    _tabCurvature = 30.0f;
    
    _tabStrokeColorEnabled = [UIColor colorWithWhite:0.5f alpha:1.0f];
    _tabStrokeColorDisabled = [UIColor colorWithWhite:0.3f alpha:1.0f];
    _tabStrokeColorHighlighted = [UIColor colorWithWhite:0.6f alpha:1.0f];
    
    _tabBarBackgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    _tabBarHighlightColor = _tabBackgroundColorHighlighted;
    _tabBarStrokeHighlightColor = _tabStrokeColorHighlighted;
    
}


@end
