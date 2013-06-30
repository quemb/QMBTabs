//
//  QMBTabBar.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBTabBar.h"

@interface QMBTabBar (){
    int _activeTabIndex;
    float firstX, firstY, prevX;
}

@property (nonatomic, strong) UIView *highlightBar;

@end


static float kMaxTabWidth = 150.0f;
static float kMinTabWidth = 90.0f;

@implementation QMBTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [NSMutableArray array];
        _activeTabIndex = 0;
        
        self.normalColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.highlightColor = [UIColor colorWithWhite:0.7 alpha:1];
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        if (!_highlightBar){
            _highlightBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-5.0f, self.frame.size.width, 5.0f)];
        }
        
        [_highlightBar setBackgroundColor:self.highlightColor];
        [self addSubview:_highlightBar];
        
        [self bringSubviewToFront:_highlightBar];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    
    
}


- (void)addTabItem
{
    
    
    QMBTab *tabItem = [[QMBTab alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
    tabItem.titleLabel.text = [NSString stringWithFormat:@"%d",[self.items count]];
    [tabItem setDelegate:self];
    
    [self.items addObject:tabItem];
    [self addSubview:tabItem];
    
    self.selected = [self.items count]-1;
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self rearrangeTabs];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}

- (void) rearrangeTabs
{
    float currentTabItemWidth = kMaxTabWidth;
    if ((currentTabItemWidth * [self.items count]) > self.frame.size.width){
        currentTabItemWidth = self.frame.size.width / ([self.items count] +1 );
        if (currentTabItemWidth < kMinTabWidth){
            currentTabItemWidth = kMinTabWidth;
        }
    }
    
    int i = 0;
    
    for (QMBTab *tab in self.items) {

        float newXPostion = i * currentTabItemWidth;
        [tab setFrame:CGRectMake(newXPostion,
                                 tab.frame.origin.y,
                                 currentTabItemWidth,
                                 tab.frame.size.height)];
        [tab setOrgFrame:tab.frame];
        
        if (_activeTabIndex < i){
            [self sendSubviewToBack:tab];
        }
        //[tab.view setFrame:CGRectMake(0, 0,tab.frame.size.width, tab.frame.size.height)];
        [tab layoutSubviews];
        i++;
    }
    
    
    [self setContentSize:CGSizeMake(i * currentTabItemWidth, self.frame.size.height)];
    [self bringSubviewToFront:_highlightBar];
    [_highlightBar setFrame:CGRectMake(-(i * currentTabItemWidth)/2, _highlightBar.frame.origin.y, 2*(i * currentTabItemWidth), _highlightBar.frame.size.height)];
}
/*
-(void)layoutSubviews
{
    [super layoutSubviews];
    // Stacking

    if (self.contentOffset.x > 0){
        for (QMBTab *tab in self.items) {
            if (tab.frame.origin.x <= self.contentOffset.x){
                CGRect frame = tab.frame;
                frame.origin.x = self.contentOffset.x;
                tab.frame = frame;
            }
            
        }
    }
}
*/
#pragma mark - QMBTab Delegate

- (void)didSelectTab:(QMBTab *)tab{
    int i =0;

    for (QMBTab *tabItem in self.items) {
        if (tab == tabItem){
            [tabItem setHighlighted:true];
            self.selected = i;
            [self bringSubviewToFront:_highlightBar];
            [self bringSubviewToFront:tabItem];
        }else {
            [tabItem setHighlighted:false];
        }
        i++;
    }
    
    if ([self.tabBarDelegeate respondsToSelector:@selector(tabBar:didChangeTabItem:)]){
        [self.tabBarDelegeate performSelector:@selector(tabBar:didChangeTabItem:) withObject:self withObject:tab];
    }
}

@end
