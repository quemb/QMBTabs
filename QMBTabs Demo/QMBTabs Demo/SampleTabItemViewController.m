//
//  SampleTabItemViewController.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 10.07.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "SampleTabItemViewController.h"

@interface SampleTabItemViewController ()

@end

@implementation SampleTabItemViewController

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
	
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.github.com"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
