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



- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [self.view addSubview:contentView];
    _contentView = contentView;
    
}



- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated{
    self.viewControllers = viewControllers;
    
    _tabBar.items = [NSMutableArray array];
    
    for (UIViewController *controller in viewControllers) {
        [_tabBar addTabItem];
        self.selectedViewController = controller;
        [controller.view setNeedsLayout];
        [self addChildViewController:controller];
        [_contentView addSubview:controller.view];
    }

}

- (void)tabBar:(QMBTabBar *)tabBar didChangeTabItem:(QMBTab *)tab{
    UIViewController *current = self.selectedViewController;
    
    NSLog(@"%d",self.tabBar.selected);
    for (int i=0; i<[tabBar.items count] ; i++) {
        if ([tabBar.items objectAtIndex:i] == tab){
            UIViewController *newViewController = [self.viewControllers objectAtIndex:i];
            [self transitionFromViewController:current
                              toViewController:newViewController
                                      duration:0
                                       options:0
                                    animations:nil
                                    completion:NULL];
            
        }
    }
}

@end
