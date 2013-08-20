//
//  QMBBadgeView.h
//  QMBTabs Demo
//
//  Created by Barry Allard on 2013-08-18.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMBBadgeView : UIView

@property (nonatomic, strong) NSString *text;

// The badge text label.
@property (nonatomic, strong, readonly) UILabel *textLabel;

/*
 * Badge background color
 *
 * @see defaultColor
 */
@property (nonatomic, strong) UIColor *color;

/*
 * Corner radius used when rendering the rounded rect outline
 * Default is 12
 */
@property (nonatomic, assign) CGFloat cornerRadius;


/*
 * Default badge color
 */
+ (UIColor *)defaultColor;

/*
 * Default badge text color
 */
+ (UIColor *)defaultTextColor;
@end

