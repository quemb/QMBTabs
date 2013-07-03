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
    float firstX, firstY, prevX, currentTabItemWidth;
}

@property (nonatomic, strong) UIView *highlightBar;
@property (nonatomic, strong) QMBTab *selectedTab;
@end


static float kMaxTabWidth = 320.0f;
static float kMinTabWidth = 150.0f;
static float highlightBarHeight = 5.0f;

@implementation QMBTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        _items = [NSMutableArray array];
        _activeTabIndex = 0;
        
        currentTabItemWidth = kMaxTabWidth;
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setAlwaysBounceHorizontal:YES];
        
        
    }
    return self;
}




- (void) addTabItemWithCompletition:(void (^)(QMBTab *tabItem))completition
{
    
   
    QMBTab *tabItem = [[QMBTab alloc] initWithFrame:CGRectMake([_items count] * currentTabItemWidth, 0, 0, self.frame.size.height-highlightBarHeight)];
    [tabItem setAppearance:self.appearance];
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
    
    currentTabItemWidth = kMaxTabWidth;
    
    int i = 0;
    float inset = 15.0;
    
    if (((currentTabItemWidth * [_items count]) - (inset * [_items count])) > self.frame.size.width){
        currentTabItemWidth = self.frame.size.width  / ([_items count]);
        if (currentTabItemWidth < kMinTabWidth){
            currentTabItemWidth = kMinTabWidth;
        }
    }
    
    [self setContentSize:CGSizeMake([_items count] * currentTabItemWidth - [_items count]*inset, self.frame.size.height)];
    
    for (QMBTab *tab in _items) {

        float newXPostion = i * (currentTabItemWidth - inset);
        CGRect frame = CGRectMake(newXPostion,
                                  tab.frame.origin.y,
                                  currentTabItemWidth,
                                  tab.frame.size.height);
        
        [tab setOrgFrame:frame];
        frame.origin.x = [self calcXPostionOfTab:tab];
        [tab setFrame:frame];

        [tab setNeedsDisplay];
        [tab layoutSubviews];
        i++;
    }
    
    [self bringSubviewToFront:_highlightBar];
    [self bringSubviewToFront:_selectedTab];

    
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
    
   
    for (QMBTab *tab in _items) {
        
        CGRect frame = tab.frame;
        frame.origin.x = [self calcXPostionOfTab:tab];
        tab.frame = frame;
        
    }
    
}

- (float) calcXPostionOfTab:(QMBTab *)tab
{
    if (tab.orgFrame.origin.x <= self.contentOffset.x){
        //NSLog(@"1: %f",self.contentOffset.x);
        return self.contentOffset.x;
    }else if (tab.orgFrame.origin.x + tab.orgFrame.size.width > self.frame.size.width + self.contentOffset.x){
        return self.frame.size.width - tab.orgFrame.size.width + self.contentOffset.x;
    }else{
        //NSLog(@"3: %f",tab.orgFrame.origin.x);
        return tab.orgFrame.origin.x;
    }
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    [self setBackgroundColor:[UIColor redColor]];
        
    self.normalColor = self.appearance.tabBackgroundColorEnabled;
    self.highlightColor = self.appearance.tabBackgroundColorHighlighted;
    [_highlightBar setBackgroundColor:self.appearance.tabBarHighlightColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-5.0f, rect.size.width, 5.0f)];
    [view setBackgroundColor:self.appearance.tabBarHighlightColor];
    _highlightBar = view;
    [_highlightBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:_highlightBar];
    
    //[self rearrangeTabs];
    
    [self bringSubviewToFront:_highlightBar];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self rearrangeTabs];
    
    // Highlight Bar should stack and not scroll
    [_highlightBar setFrame:CGRectMake(self.contentOffset.x, _highlightBar.frame.origin.y, _highlightBar.frame.size.width, _highlightBar.frame.size.height)];
   
}

- (void) selectTab:(QMBTab *)tab{
    
    int i =0;
    
    
    for (QMBTab *tabItem in _items) {
        if (tab == tabItem){
            [tabItem setHighlighted:true];
        }else {
            [tabItem setHighlighted:false];
            
        }
        [self sendSubviewToBack:tabItem];
        i++;
    }
    
    _selectedTab = tab;
    
    [self bringSubviewToFront:_highlightBar];
    [self bringSubviewToFront:_selectedTab];
    
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
