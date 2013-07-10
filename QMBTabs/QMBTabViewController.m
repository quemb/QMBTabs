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

- (id) init
{
    self = [super init];
    
    if (self){

        [self setup];
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void) setup
{
    QMBTabsAppearance *appearance;
    if ([self.delegate respondsToSelector:@selector(tabViewControllerNeedsAppearance:)]){
        appearance = [self.delegate performSelector:@selector(tabViewControllerNeedsAppearance:) withObject:self];
    }else {
        appearance = [self getDefaultAppearance];
    }
    self.appearance = appearance;
    
    QMBTabBar *tabBar = [[QMBTabBar alloc] init];
    tabBar.tabBarDelegeate = self;
    tabBar.appearance = self.appearance;
    [tabBar setBackgroundColor:self.appearance.tabBarBackgroundColor];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    _tabBar = tabBar;
}

- (QMBTabsAppearance *)getDefaultAppearance
{
    return [[QMBTabsAppearance alloc] init];
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
    
    [_tabBar setFrame:CGRectMake(0, 0,width, 44.0f)];
    [self.view addSubview:_tabBar];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, _tabBar.frame.size.height, width, height-_tabBar.frame.size.height)];
    [contentView setClipsToBounds:YES];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:contentView];
    _contentView = contentView;

}

- (void)addViewController:(UIViewController *)controller
{
    [self addViewController:controller withCompletion:nil];
}


- (void)addViewController:(UIViewController *)controller withCompletion:(void (^)(QMBTab *))completition {
    if ([_viewControllers containsObject:controller])
        return;
    
    if ([self.delegate respondsToSelector:@selector(tabViewController:willAddViewController:)]){
        [self.delegate performSelector:@selector(tabViewController:willAddViewController:) withObject:self withObject:controller];
    }
    
    [self addChildViewController:controller];
    [_viewControllers addObject:controller];

    
    
    [_tabBar addTabItemWithCompletition:completition];
    
    if([_viewControllers count] == 1){
        [self selectViewController:controller];
    }

    [controller didMoveToParentViewController:self];
    
    if ([self.delegate respondsToSelector:@selector(tabViewController:didAddViewController:)]){
        [self.delegate performSelector:@selector(tabViewController:didAddViewController:) withObject:self withObject:controller];
    }
}

- (void)selectViewController:(UIViewController *)controller{
    UIViewController *current = self.selectedViewController;
    if (controller == self.selectedViewController)
        return;

    controller.view.frame = CGRectMake(0,0,_contentView.frame.size.width, _contentView.frame.size.height);
    if (controller.view.superview == nil){
        [controller.view setNeedsLayout];
        [controller.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.contentView addSubview:controller.view];
        self.selectedViewController = controller;
        [_tabBar selectTab:[_tabBar tabItemForIndex:[self indexForViewController:self.selectedViewController]]];
    }else {
        [self transitionFromViewController:current
                          toViewController:controller
                                  duration:0
                                   options:0
                                animations:nil
                                completion:^(BOOL finished) {
                                    self.selectedViewController = controller;
                                    [_tabBar selectTab:[_tabBar tabItemForIndex:[self indexForViewController:self.selectedViewController]]];
                                    
                                    if ([self.delegate respondsToSelector:@selector(tabViewController:didSelectViewController:)]){
                                        [self.delegate performSelector:@selector(tabViewController:didSelectViewController:) withObject:self withObject:self.selectedViewController];
                                    }
                                    
                                }];
    }
    
    
    
    
}

#pragma mark - QMBTabBar Delegate

- (void)tabBar:(QMBTabBar *)tabBar didChangeTabItem:(QMBTab *)tab{
    
    BOOL select = YES;
    UIViewController *newViewController = [_viewControllers objectAtIndex:[tabBar indexForTabItem:tab]];
    
    if ([self.delegate respondsToSelector:@selector(tabViewController:shouldSelectViewController:)]){
        select = (BOOL)[self.delegate performSelector:@selector(tabViewController:shouldSelectViewController:) withObject:self withObject:newViewController];
    }
    if (select){
        [self selectViewController:newViewController];
    }
    
}

- (void)tabBar:(QMBTabBar *)tabBar didRemoveTabItem:(QMBTab *)tab
{
    // Nothing to do so far
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
    
    int removeIndex = [tabBar indexForTabItem:tab];
    UIViewController *removeController = [_viewControllers objectAtIndex:removeIndex];
    
    if ([self.delegate respondsToSelector:@selector(tabViewController:willRemoveViewController:)]){
        [self.delegate performSelector:@selector(tabViewController:willRemoveViewController:) withObject:self withObject:removeController];
    }
    
    if ( [self indexForViewController:self.selectedViewController]+1 < [_viewControllers count]){
        [self selectViewController:[_viewControllers objectAtIndex:[self indexForViewController:self.selectedViewController]+1]];
    }else if ([self indexForViewController:self.selectedViewController]-1 < [_viewControllers count]){
        [self selectViewController:[_viewControllers objectAtIndex:[self indexForViewController:self.selectedViewController]-1]];
    }
    
    [removeController willMoveToParentViewController:nil];
    [removeController.view removeFromSuperview];
    
    [_viewControllers removeObject:removeController];
    
    if ([self.delegate respondsToSelector:@selector(tabViewController:didRemoveViewController:)]){
        [self.delegate performSelector:@selector(tabViewController:didRemoveViewController:) withObject:self withObject:removeController];
    }
    
}

@end
