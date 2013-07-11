//
//  SampleTabViewController.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 30.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleTabViewController.h"

#import "SampleTabItemViewController.h"

@interface SampleTabViewController ()

@end

@implementation SampleTabViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.delegate = self;
    
    for (int i = 0; i<4; i++) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleTabItemViewController"];
        [self addViewController:viewController withCompletion:^(QMBTab *tabItem) {
            tabItem.titleLabel.text = [NSString stringWithFormat:@"Hello I'm a Tab! %d", i];
        }];
    }
    
    [self addViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SampleTabItemViewController"] withCompletion:^(QMBTab *tabItem) {
        tabItem.titleLabel.text = @"Printer!";
        
        tabItem.iconImage = [UIImage imageNamed:@"monotone_printer_hardware.png"];
        tabItem.iconHighlightedImage = [UIImage imageNamed:@"monotone_printer_hardware-highlight.png"];
    }];
    
    [self addViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SampleTabItemViewController"] withCompletion:^(QMBTab *tabItem) {
        tabItem.titleLabel.text = @"Hello I'm a nonclosable Tab!";
        tabItem.closable = NO;
        
        tabItem.iconImage = [UIImage imageNamed:@"monotone_wrench_settings.png"];
        tabItem.iconHighlightedImage = [UIImage imageNamed:@"monotone_wrench_settings-highlight.png"];
    }];
    
}

#pragma mark - QMBTabViewController Delegate

// Use this method to customize appearance

- (QMBTabsAppearance *)getDefaultAppearance
{
    QMBTabsAppearance *appearance = [super getDefaultAppearance];
    
    [appearance setTabBarBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation-bar-background_44.png"]]];
    
    // Tabs
    [appearance setTabBackgroundColorHighlighted:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qmb-tab-background-highlight.png"]]];
    [appearance setTabBackgroundColorEnabled:[UIColor colorWithPatternImage:[UIImage imageNamed:@"qmb-tab-background.png"]]];
    
    [appearance setTabBarHighlightColor:[UIColor colorWithRed:242.0f/255.0f green:140.0f/255.0f blue:19.0f/255.0f alpha:1.0f]];
    
    [appearance setTabCloseButtonImage:[UIImage imageNamed:@"qmb-tab-close-icon.png"]];
    [appearance setTabCloseButtonHighlightedImage:[UIImage imageNamed:@"qmb-tab-close-icon-highlight.png"]];
    
    [appearance setTabDefaultIconHighlightedImage:nil];
    [appearance setTabDefaultIconImage:nil];
    
//    [appearance setTabDefaultIconHighlightedImage:[UIImage imageNamed:@"qmb-tab-icon-default-highlight.png"]];
//    [appearance setTabDefaultIconImage:[UIImage imageNamed:@"qmb-tab-icon-default.png"]];
    
    [appearance setTabLabelColorHighlighted:[UIColor whiteColor]];
    
    [appearance setTabLabelColorEnabled:[UIColor blackColor]];
    
    return appearance;
}

- (void)tabViewController:(QMBTabViewController *)tabViewController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tab Changed to %d", [tabViewController indexForViewController:viewController]);
}

- (BOOL)tabViewController:(QMBTabViewController *)tabViewController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
