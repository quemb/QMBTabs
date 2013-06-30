//
//  QMBTab.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT const CGFloat kLTTabViewWidth;
FOUNDATION_EXPORT const CGFloat kLTTabViewHeight;
FOUNDATION_EXPORT const CGFloat kLTTabOuterHeight;
FOUNDATION_EXPORT const CGFloat kLTTabInnerHeight;
FOUNDATION_EXPORT const CGFloat kLTTabLineHeight;
FOUNDATION_EXPORT const CGFloat kLTTabCurvature;

@class QMBTab;

@protocol QMBTabDelegate <NSObject>

- (void) didSelectTab:(QMBTab *)tab;

@end

@interface QMBTab : UIView
@property (nonatomic, assign) id<QMBTabDelegate> delegate;

@property (nonatomic, assign, setter = setHighlighted:) BOOL highlighted;
@property (nonatomic, assign) CGRect orgFrame;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIColor *innerBackgroundColor;
@property (strong, nonatomic) UIColor *foregroundColor;

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *normalColor;

- (void) setHighlighted:(BOOL)highlighted;

@end
