//
//  QMBTabBar.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBTab.h"
#import "QMBTabsAppearance.h"

@class QMBTabBar;

@protocol QMBTabBarDelegate <NSObject>

- (void) tabBar:(QMBTabBar *)tabBar didChangeTabItem:(QMBTab *)tab;

- (void) tabBar:(QMBTabBar *)tabBar willRemoveTabItem:(QMBTab *)tab;
- (void) tabBar:(QMBTabBar *)tabBar didRemoveTabItem:(QMBTab *)tab;

@end

@interface QMBTabBar : UIScrollView<QMBTabDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) id<QMBTabBarDelegate> tabBarDelegeate;
@property (nonatomic, strong, readonly) NSMutableArray *items;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) QMBTabsAppearance *appearance;

/*
 * > 0.0 stacks : tabs to the right, at the end of the last tab
 *
 * < 0.0 stacks : tabs to the left, on the right side of the last tab
 *
 * Default is 2.0, which looks nice on iPhone non-retina and iPad retina
 *
 */
@property (nonatomic) CGFloat stackedTabOffset;

- (void) addTabItemWithCompletition:(void (^)(QMBTab *tabItem))completition;
- (void) selectTab:(QMBTab *)tab;
- (void) removeTabItem:(QMBTab *)tab;

- (NSUInteger) indexForTabItem:(QMBTab *)tabItem;
- (QMBTab *) tabItemForIndex:(int)index;
- (void) rearrangeTabs;

@end
