//
//  QMBTabViewController.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBTabViewController.h"


@interface QMBTabViewController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation QMBTabViewController

- (void)awakeFromNib
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewControllers = [NSMutableArray array];
    
    float width = self.view.bounds.size.width;
    float height = self.view.bounds.size.height;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight){
        width = self.view.bounds.size.height;
        height = self.view.bounds.size.width;
    }
    QMBTabBar *tabBar = [[QMBTabBar alloc] initWithFrame:CGRectMake(0, 0,width, 45.0f)];
    tabBar.tabBarDelegeate = self;
    [tabBar setBackgroundColor:[UIColor clearColor]];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self.view addSubview:tabBar];
    
    _tabBar = tabBar;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, tabBar.frame.size.height, width, height-tabBar.frame.size.height)];
    [contentView setClipsToBounds:YES];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:contentView];
    _contentView = contentView;
    
}


- (void)addViewController:(UIViewController *)controller {
    if ([_viewControllers containsObject:controller])
        return;
    
    [self addChildViewController:controller];
    [_viewControllers addObject:controller];

    [controller.view setNeedsLayout];
    controller.view.frame = CGRectMake(0,0,_contentView.frame.size.width, _contentView.frame.size.height);
    
    __block QMBTabViewController *self_ = self;

    [_tabBar addTabItemWithCompletition:^(QMBTab *tabItem) {
        
        if ([self_.delegate respondsToSelector:@selector(tabViewController:titleForTabAtIndex:)]){
            NSString *title = [self_.delegate performSelector:@selector(tabViewController:titleForTabAtIndex:) withObject:self_ withObject:[NSIndexPath indexPathWithIndex:[self_ indexForViewController:controller]]];
            tabItem.titleLabel.text = title;
        }else {
            tabItem.titleLabel.text = controller.title;
        }
        
    }];
    
    [self.contentView addSubview:controller.view];
    self.selectedViewController = controller;
    [_tabBar selectTab:[_tabBar tabItemForIndex:[self indexForViewController:self.selectedViewController]]];
    [controller didMoveToParentViewController:self];
    
    
}

- (void)selectViewController:(UIViewController *)controller{
    UIViewController *current = self.selectedViewController;
    if (controller == self.selectedViewController)
        return;
    
    [self transitionFromViewController:current
                      toViewController:controller
                              duration:0.5
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:nil
                            completion:^(BOOL finished) {
                                self.selectedViewController = controller;
                                [_tabBar selectTab:[_tabBar tabItemForIndex:[self indexForViewController:self.selectedViewController]]];
                            }];
}

#pragma mark - QMBTabBar Delegate

- (void)tabBar:(QMBTabBar *)tabBar didChangeTabItem:(QMBTab *)tab{
    NSLog(@"%d",[tabBar indexForTabItem:tab]);
    UIViewController *newViewController = [_viewControllers objectAtIndex:[tabBar indexForTabItem:tab]];
    [self selectViewController:newViewController];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewcontroller
{
    int i = 0;
    for (UIViewController *viewControllerItem in _viewControllers) {
        if (viewControllerItem == viewcontroller){
            return i;
        }
        i++;
    }
    return -1;
}

- (void)tabBar:(QMBTabBar *)tabBar willRemoveTabItem:(QMBTab *)tab
{
    
    if ( [self indexForViewController:self.selectedViewController]+1 < [_viewControllers count]){
        [self selectViewController:[_viewControllers objectAtIndex:[self indexForViewController:self.selectedViewController]+1]];
    }else if ([self indexForViewController:self.selectedViewController]-1 < [_viewControllers count]){
        [self selectViewController:[_viewControllers objectAtIndex:[self indexForViewController:self.selectedViewController]-1]];
    }
    
    int removeIndex = [tabBar indexForTabItem:tab];
    UIViewController *removeController = [_viewControllers objectAtIndex:removeIndex];
    [removeController willMoveToParentViewController:nil];
    [removeController.view removeFromSuperview];
    
    [_viewControllers removeObject:removeController];
}

- (void)tabBar:(QMBTabBar *)tabBar didRemoveTabItem:(QMBTab *)tab
{
    
}

@end
