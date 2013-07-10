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

#define ARC4RANDOM_MAX 0x100000000

static UIColor *randomColor() {
    return [UIColor colorWithRed:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                           green:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                            blue:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                           alpha:1.0f];
}

@implementation SampleTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.delegate = self;
    
    for (int i = 0; i<6; i++) {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleTabItemViewController"];
        [self addViewController:viewController withCompletion:^(QMBTab *tabItem) {
            tabItem.titleLabel.text = [NSString stringWithFormat:@"Hello I'm a Tab! %d", i];
            tabItem.closable = YES;
        }];
    }
    
    [self addViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SampleTabItemViewController"] withCompletion:^(QMBTab *tabItem) {
        tabItem.titleLabel.text = @"Hello I'm a nonclosable Tab!";
        tabItem.closable = NO;
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
    
    [appearance setTabLabelColorHighlighted:[UIColor whiteColor]];
    
    [appearance setTabLabelColorEnabled:[UIColor darkGrayColor]];
    
    return appearance;
}

- (void)tabViewController:(QMBTabViewController *)tabViewController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tab Chaned to %d", [tabViewController indexForViewController:viewController]);
}

- (BOOL)tabViewController:(QMBTabViewController *)tabViewController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
