//
//  QMBTab.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMBTabsAppearance.h"

@class QMBTab;

@protocol QMBTabDelegate <NSObject>

- (void) didSelectTab:(QMBTab *)tab;

- (void) tab:(QMBTab *)tab didSelectCloseButton:(UIButton *)button;

@end

@interface QMBTab : UIView
@property (nonatomic, assign) id<QMBTabDelegate> delegate;

@property (nonatomic, assign, setter = setHighlighted:) BOOL highlighted;
@property (nonatomic, assign) CGRect orgFrame;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *closeButton;

@property (strong, nonatomic) UIColor *innerBackgroundColor;
@property (strong, nonatomic) UIColor *foregroundColor;

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) QMBTabsAppearance *appearance;

@property (nonatomic) BOOL closable;

- (void) setHighlighted:(BOOL)highlighted;

@end
