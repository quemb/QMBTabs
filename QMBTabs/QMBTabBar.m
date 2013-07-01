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
        self.delegate = self;
        
        _items = [NSMutableArray array];
        _activeTabIndex = 0;
        
        self.normalColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.highlightColor = [UIColor colorWithWhite:0.7 alpha:1];
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setAlwaysBounceHorizontal:YES];
        
        if (!_highlightBar){
            _highlightBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-5.0f, self.frame.size.width, 5.0f)];
            [_highlightBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        
        [_highlightBar setBackgroundColor:self.highlightColor];
        [self addSubview:_highlightBar];
        
        [self bringSubviewToFront:_highlightBar];
    }
    return self;
}


- (void) addTabItemWithCompletition:(void (^)(QMBTab *tabItem))completition
{
    
    
    QMBTab *tabItem = [[QMBTab alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height-_highlightBar.frame.size.height)];
    tabItem.titleLabel.text = NSLocalizedString(@"New tab", @"QMBTabBar New Tab Title");
    [tabItem setDelegate:self];
    
    completition(tabItem);
    
    [_items addObject:tabItem];
    [self addSubview:tabItem];
    
    
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
    if ((currentTabItemWidth * [_items count]) > self.frame.size.width){
        currentTabItemWidth = self.frame.size.width / ([_items count] +1 );
        if (currentTabItemWidth < kMinTabWidth){
            currentTabItemWidth = kMinTabWidth;
        }
    }
    
    int i = 0;
    
    for (QMBTab *tab in _items) {

        float newXPostion = i * (currentTabItemWidth - 15.0f);
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
    
}

- (NSUInteger) indexForTabItem:(QMBTab *)tabItem
{
    int i = 0;
    for (QMBTab *tab in _items) {
        if (tabItem == tab){
            return i;
        }
        i++;
    }
    
    return -1;
}

- (QMBTab *)tabItemForIndex:(int)index
{
    return [_items objectAtIndex:index];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Stacking
    /*
    if (self.contentOffset.x > 0){
        
    }
    
    for (QMBTab *tab in _items) {

        if (tab.orgFrame.origin.x <= self.contentOffset.x){
            CGRect frame = tab.frame;
            frame.origin.x = self.contentOffset.x;
            tab.frame = frame;
        }else if (self.contentOffset.x + tab.orgFrame.origin.x + tab.orgFrame.size.width > self.frame.size.width){
            CGRect frame = tab.frame;
            frame.origin.x = tab.orgFrame.origin.x - (self.contentSize.width - self.frame.size.width) + self.contentOffset.x;
            tab.frame = frame;
        }else if (tab.frame.origin.x != tab.orgFrame.origin.x){
            CGRect frame = tab.frame;
            frame.origin.x = tab.orgFrame.origin.x;
            tab.frame = frame;
            
        }
        
        
        
    }
     */
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // Highlight Bar should stack and not scroll
    [_highlightBar setFrame:CGRectMake(self.contentOffset.x, _highlightBar.frame.origin.y, _highlightBar.frame.size.width, _highlightBar.frame.size.height)];
}

- (void) selectTab:(QMBTab *)tab{
    
    int i =0;
    
    for (QMBTab *tabItem in _items) {
        if (tab == tabItem){
            [tabItem setHighlighted:true];
            [self bringSubviewToFront:_highlightBar];
            [self bringSubviewToFront:tabItem];
        }else {
            [tabItem setHighlighted:false];
        }
        i++;
    }
    
}

#pragma mark - QMBTab Delegate

- (void)didSelectTab:(QMBTab *)tab{
    
    
    if ([self.tabBarDelegeate respondsToSelector:@selector(tabBar:didChangeTabItem:)]){
        [self.tabBarDelegeate performSelector:@selector(tabBar:didChangeTabItem:) withObject:self withObject:tab];
    }
}

- (void)tab:(QMBTab *)tab didSelectCloseButton:(UIButton *)button{
    
    if ([self.tabBarDelegeate respondsToSelector:@selector(tabBar:willRemoveTabItem:)]){
        [self.tabBarDelegeate performSelector:@selector(tabBar:willRemoveTabItem:) withObject:self withObject:tab];
    }
    
    [tab removeFromSuperview];
    [_items removeObject:tab];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self rearrangeTabs];
                     }
                     completion:^(BOOL finished){

                     }];
    
    if ([self.tabBarDelegeate respondsToSelector:@selector(tabBar:didRemoveTabItem:)]){
        [self.tabBarDelegeate performSelector:@selector(tabBar:didRemoveTabItem:) withObject:self withObject:tab];
    }
    
}

@end
