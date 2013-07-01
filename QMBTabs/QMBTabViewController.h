//
//  QMBTabViewController.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMBTabBar.h"

@class QMBTabViewController;

@protocol QMBTabViewControllerDelegate <NSObject>

@optional
- (NSString *) tabViewController:(QMBTabViewController *)tabViewController titleForTabAtIndex:(NSUInteger)index;

- (BOOL)tabViewController:(QMBTabViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(QMBTabViewController *)tabBarController didSelectViewController:(UIViewController *)viewController;

- (void)tabBarController:(QMBTabViewController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers;
- (void)tabBarController:(QMBTabViewController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
- (void)tabBarController:(QMBTabViewController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
@end

@interface QMBTabViewController : UIViewController<QMBTabBarDelegate>

@property(nonatomic,strong, readonly) NSMutableArray *viewControllers;


@property(nonatomic,assign) UIViewController *selectedViewController;

@property(nonatomic,readonly) QMBTabBar *tabBar;

@property(nonatomic,assign) id<QMBTabViewControllerDelegate> delegate;

- (void)addViewController:(UIViewController *)controller;
- (void)selectViewController:(UIViewController *)controller;
- (NSUInteger) indexForViewController:(UIViewController *)viewcontroller;

@end



