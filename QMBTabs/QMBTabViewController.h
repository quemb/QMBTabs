//
//  QMBTabViewController.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMBTabBar.h"

@class UIView, UIImage, UINavigationController;
@protocol QMBTabViewControllerDelegate;

@interface QMBTabViewController : UIViewController<QMBTabBarDelegate>

@property(nonatomic,strong) NSArray *viewControllers;
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;


@property(nonatomic,assign) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;

@property(nonatomic,readonly) QMBTabBar *tabBar;

@property(nonatomic,assign) id<QMBTabViewControllerDelegate> delegate;

@end

@protocol QMBTabViewControllerDelegate <NSObject>
@optional
- (BOOL)tabViewController:(QMBTabViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(QMBTabViewController *)tabBarController didSelectViewController:(UIViewController *)viewController;

- (void)tabBarController:(QMBTabViewController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers;
- (void)tabBarController:(QMBTabViewController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
- (void)tabBarController:(QMBTabViewController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
@end

