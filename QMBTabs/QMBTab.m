//
//  QMBTab.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBTab.h"

@interface QMBTab ()


@end

@implementation QMBTab

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        _orgFrame = frame;
		_closable = YES;
        
        [self setClipsToBounds:NO];
        
		[self setOpaque:NO];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapGesture];
        
        // title label
        if (!self.titleLabel){
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setText:NSLocalizedString(@"New tab is what it is", nil)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            self.titleLabel = titleLabel;
            [self addSubview:self.titleLabel];
        }
        
        // close button
        if (!self.closeButton){
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton addTarget:self action:@selector(closeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:closeButton];
            self.closeButton = closeButton;
        }
        
        // icon image view
        if (!self.iconImageView){
            UIImageView *iconImageView = [[UIImageView alloc] init];
            [self addSubview:iconImageView];
            self.iconImageView = iconImageView;
        }
        

	}
    
	return self;
}
- (void)setInnerBackgroundColor:(UIColor *)color
{
	if ([_innerBackgroundColor isEqual:color]) {
		return;
	}
	_innerBackgroundColor = color;
	[self setNeedsDisplay];
}

- (void)setForegroundColor:(UIColor *)color
{
	if ([_foregroundColor isEqual:color]) {
		return;
	}
	_foregroundColor = color;
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    
    if (!_innerBackgroundColor){
        [self setInnerBackgroundColor:self.appearance.tabBackgroundColorEnabled];
    }
    
    if (!self.normalColor){
        self.normalColor = self.appearance.tabBackgroundColorEnabled;
        self.highlightColor = self.appearance.tabBackgroundColorHighlighted;
    }
    
    [self.closeButton setImage:self.appearance.tabCloseButtonImage forState:UIControlStateNormal];
    [self.closeButton setImage:self.appearance.tabCloseButtonHighlightedImage forState:UIControlStateHighlighted];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGMutablePathRef path;
	CGPoint point;
    
    CGFloat qmbTabSideOffset = self.appearance.tabSideOffset;
    CGFloat qmbTabTopOffset = self.appearance.tabTopOffset;
    CGFloat qmbTabCurvature = self.appearance.tabCurvature;
    
    CGFloat qmbTabWidth = self.frame.size.width;
    CGFloat qmbTabHeight = self.frame.size.height - qmbTabTopOffset;;
    
    CGFloat startY = self.frame.size.height;
    
    CGFloat qmbTabIconWidth = 0.0f;
    CGFloat qmbTabIconMargin = 3.0f;

	CGContextSaveGState(context);
    
    // Shadow
	CGContextSaveGState(context);
    CGContextSetShadowWithColor(context,
                                CGSizeMake(self.appearance.tabShadowWidthOffset, self.appearance.tabShadowHeightOffset),
                                self.appearance.tabShadowBlur,
                                [self.appearance.tabShadowColor CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
    
	path = CGPathCreateMutable();
	point = CGPointMake(0.0f, startY);
	CGPathMoveToPoint(path, NULL, point.x, point.y);


    // offset left
    CGPathAddLineToPoint(path, NULL, qmbTabSideOffset, startY);
    
    
    // left curve
    CGPathAddCurveToPoint(path, NULL,
                          qmbTabSideOffset + qmbTabCurvature / 2, startY,
                          qmbTabSideOffset + qmbTabCurvature / 2, startY - qmbTabHeight,
                          qmbTabSideOffset + qmbTabCurvature, startY - qmbTabHeight);
    
    // top line
    CGPathAddLineToPoint(path, NULL, qmbTabWidth - qmbTabSideOffset - qmbTabCurvature, startY - qmbTabHeight);
    
    // right curve
    CGPathAddCurveToPoint(path, NULL,
                          qmbTabWidth - qmbTabSideOffset - qmbTabCurvature / 2, startY - qmbTabHeight,
                          qmbTabWidth - qmbTabSideOffset - qmbTabCurvature / 2, startY,
                          qmbTabWidth - qmbTabSideOffset, startY);
    
    // offset right
    CGPathAddLineToPoint(path, NULL, qmbTabWidth, startY);
    
    
	CGPathCloseSubpath(path);
	[_innerBackgroundColor setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);

	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
    
    [self.iconImageView setImage:nil];
    
    // highlighted tab
    if (_highlighted){
        // set frame of the close button
        [self.closeButton setFrame:CGRectMake(qmbTabWidth - qmbTabSideOffset - qmbTabCurvature - (self.appearance.tabCloseButtonImage).size.width,
                                              (qmbTabHeight - (self.appearance.tabCloseButtonImage).size.height) / 2 + qmbTabTopOffset,
                                              (self.appearance.tabCloseButtonImage).size.width, (self.appearance.tabCloseButtonImage).size.height)];
        
        // set font and color of the title label
        [self.titleLabel setFont:self.appearance.tabLabelFontHighlighted];
        [self.titleLabel setTextColor:self.appearance.tabLabelColorHighlighted];
        
        // tab default icon
        if(self.appearance.tabDefaultIconHighlightedImage) {
            [self.iconImageView setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature,
                                                    (qmbTabHeight - (self.appearance.tabDefaultIconHighlightedImage).size.height) / 2 + qmbTabTopOffset,
                                                    (self.appearance.tabDefaultIconHighlightedImage).size.width, (self.appearance.tabDefaultIconHighlightedImage).size.height)];
            [self.iconImageView setImage:self.appearance.tabDefaultIconHighlightedImage];
            
            qmbTabIconWidth = (self.appearance.tabDefaultIconHighlightedImage).size.width + qmbTabIconMargin;
        }
        
        // tab icon
        if(self.iconHighlightedImage) {
            [self.iconImageView setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature,
                                                    (qmbTabHeight - (self.iconHighlightedImage).size.height) / 2 + qmbTabTopOffset,
                                                    (self.iconHighlightedImage).size.width, (self.iconHighlightedImage).size.height)];
            [self.iconImageView setImage:self.iconHighlightedImage];
            
            qmbTabIconWidth = (self.iconHighlightedImage).size.width + qmbTabIconMargin;
        }
        
        [self.titleLabel setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature + qmbTabIconWidth, 2.0f,
                                             qmbTabWidth - 2*qmbTabSideOffset - 2*qmbTabCurvature - (_closable ? self.closeButton.frame.size.width + qmbTabIconMargin : 0.0f) - qmbTabIconWidth, self.frame.size.height)];
        
    }else {
        // set frame of the close button
        [self.closeButton setFrame:CGRectMake(qmbTabWidth - qmbTabSideOffset - qmbTabCurvature - (self.appearance.tabCloseButtonImage).size.width,
                                              (qmbTabHeight - (self.appearance.tabCloseButtonImage).size.height) / 2 + qmbTabTopOffset,
                                              0, (self.appearance.tabCloseButtonImage).size.height)];
        
        // set font and color of the title label
        [self.titleLabel setFont:self.appearance.tabLabelFontEnabled];
        [self.titleLabel setTextColor:self.appearance.tabLabelColorEnabled];
        
        // tab default icon
        if(self.appearance.tabDefaultIconImage) {
            [self.iconImageView setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature,
                                                    (qmbTabHeight - (self.appearance.tabDefaultIconImage).size.height) / 2 + qmbTabTopOffset,
                                                    (self.appearance.tabDefaultIconImage).size.width, (self.appearance.tabDefaultIconImage).size.height)];
            [self.iconImageView setImage:self.appearance.tabDefaultIconImage];
            
            qmbTabIconWidth = (self.appearance.tabDefaultIconImage).size.width + qmbTabIconMargin;
        }
        
        // tab icon
        if(self.iconImage) {
            [self.iconImageView setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature,
                                                    (qmbTabHeight - (self.iconImage).size.height) / 2 + qmbTabTopOffset,
                                                    (self.iconImage).size.width, (self.iconImage).size.height)];
            [self.iconImageView setImage:self.iconImage];
            
            qmbTabIconWidth = (self.iconImage).size.width + qmbTabIconMargin;
        }
        
        [self.titleLabel setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature + qmbTabIconWidth, 2.0f,
                                             qmbTabWidth - 2*qmbTabSideOffset - 2*qmbTabCurvature - qmbTabIconWidth, self.frame.size.height)];
    }
    
    [self.closeButton setHidden:!_highlighted || !_closable];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void) setHighlighted:(BOOL)highlighted
{
    if (highlighted){
        [self setInnerBackgroundColor:self.appearance.tabBackgroundColorHighlighted];
    }else {
        [self setInnerBackgroundColor:self.appearance.tabBackgroundColorEnabled];
    }
    
    _highlighted = highlighted;
    
}

#pragma mark - Gesture

- (void) didTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectTab:)]){
        [self.delegate performSelector:@selector(didSelectTab:) withObject:self];
    }
}

- (void) closeButtonTouchUpInside:(UIButton *)closeButton
{
    if ([self.delegate respondsToSelector:@selector(tab:didSelectCloseButton:)]){
        [self.delegate performSelector:@selector(tab:didSelectCloseButton:) withObject:self withObject:closeButton];
    }
}


@end
