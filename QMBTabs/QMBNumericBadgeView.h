//
//  QMBNumericBadgeView.h
//  QMBTabs Demo
//
//  Created by Barry Allard on 2013-08-18.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QMBBadgeView.h"

@interface QMBNumericBadgeView : QMBBadgeView
/* 0 == no max (default = 999) */
@property (nonatomic, assign) NSUInteger maxCount;
@property (nonatomic, assign) NSUInteger count;
/* 0 == no rounding (default) */
@property (nonatomic, assign) NSUInteger countRoundingMultiple;
@end
