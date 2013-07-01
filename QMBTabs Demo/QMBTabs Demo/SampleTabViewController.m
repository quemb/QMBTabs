//
//  SampleTabViewController.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 30.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleTabViewController.h"

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
    
    for (int i = 0; i<4; i++) {
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view setBackgroundColor:randomColor()];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 300, 50)];
        [label setText:[NSString stringWithFormat:@"%d",i]];
        viewController.title = [NSString stringWithFormat:@"%d",i];
        [viewController.view addSubview:label];
        [self addViewController:viewController];
    }
    
    
}

#pragma mark - QMBTabViewController Delegate

- (void)tabViewController:(QMBTabViewController *)tabViewController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tab Chaned to %d", [tabViewController indexForViewController:viewController]);
}

- (BOOL)tabViewController:(QMBTabViewController *)tabViewController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

@end
