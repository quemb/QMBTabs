//
//  QMBTabBar.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBTab.h"

@class QMBTabBar;

@protocol QMBTabBarDelegate <NSObject>

- (void) tabBar:(QMBTabBar *)tabBar didChangeTabItem:(QMBTab *)tab;

@end

@interface QMBTabBar : UIScrollView<QMBTabDelegate>

@property (nonatomic, assign) id<QMBTabBarDelegate> tabBarDelegeate;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (assign, nonatomic) NSUInteger selected;

- (void) addTabItem;

@end
