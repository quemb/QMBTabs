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

static UIColor *randomLightColor() {
    return [UIColor colorWithRed:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                           green:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                            blue:(CGFloat) arc4random() / ARC4RANDOM_MAX + 0.2f
                           alpha:0.95f];
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
	
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<10; i++) {
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view setBackgroundColor:randomLightColor()];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 300, 50)];
        [label setText:[NSString stringWithFormat:@"%d",i]];
        [viewController.view addSubview:label];
        [array addObject:viewController];
    }
    [self setViewControllers:array animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
