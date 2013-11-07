//
//  QMBTabViewController.h
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMBTabBar.h"
#import "QMBTabsAppearance.h"

@class QMBTabViewController;

@protocol QMBTabViewControllerDelegate <NSObject>


@optional
- (QMBTabsAppearance *) tabViewControllerNeedsAppearance:(QMBTabViewController *)tabViewController;
// Controller's title will be shown in tabs by default. Use this method to set the title on your own.
- (NSString *) tabViewController:(QMBTabViewController *)tabViewController titleForTabAtIndex:(NSUInteger)index;

// If false is returned to tab view won't change to the target view controller (By default = yes)
- (BOOL)tabViewController:(QMBTabViewController *)tabViewController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabViewController:(QMBTabViewController *)tabViewController didSelectViewController:(UIViewController *)viewController;

- (void)tabViewController:(QMBTabViewController *)tabViewController willAddViewController:(UIViewController *)viewController;
- (void)tabViewController:(QMBTabViewController *)tabViewController didAddViewController:(UIViewController *)viewController;

- (void)tabViewController:(QMBTabViewController *)tabViewController willRemoveViewController:(UIViewController *)viewController;
- (void)tabViewController:(QMBTabViewController *)tabViewController didRemoveViewController:(UIViewController *)viewController;

@end

@interface QMBTabViewController : UIViewController<QMBTabBarDelegate>

@property(nonatomic,strong, readonly) NSMutableArray *viewControllers;

@property (nonatomic, strong) QMBTabsAppearance *appearance;

@property(nonatomic,assign) UIViewController *selectedViewController;

@property(nonatomic,strong, readonly) QMBTabBar *tabBar;
//top offset to rearrange the tabBar below the statusbar, by default its set to the status bar height (set it to 0) for fullsize
@property float tabBarTopOffset;

@property(nonatomic,assign) id<QMBTabViewControllerDelegate> delegate;


- (void)addViewController:(UIViewController *)controller;
- (void)addViewController:(UIViewController *)controller withCompletion:(void (^)(QMBTab *tabItem))completition;
- (void)removeViewController:(UIViewController *)controller;
- (void)selectViewController:(UIViewController *)controller;
- (NSUInteger) indexForViewController:(UIViewController *)viewcontroller;
- (QMBTabsAppearance *) getDefaultAppearance;

@end

// category on UIViewController to access QMBTabViewController from an item - like UINavigationController
@interface UIViewController (QMBTabViewController)

- (QMBTabViewController*)tabViewController;

@end



