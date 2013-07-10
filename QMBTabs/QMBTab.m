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
            //[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            self.titleLabel = titleLabel;
            [self addSubview:self.titleLabel];
            
        }
        
        // close button
        if (!self.closeButton){
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton addTarget:self action:@selector(closeButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [closeButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [closeButton setFrame:CGRectMake(self.frame.size.width-30.0f, 12.0f, 15.0f, 15.0f)];
            [closeButton setHidden:YES];
            [self addSubview:closeButton];
            self.closeButton = closeButton;
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
    
    if (_highlighted){
        [self.closeButton setFrame:CGRectMake(qmbTabWidth - qmbTabSideOffset - qmbTabCurvature - (self.appearance.tabCloseButtonImage).size.width,
                                              (qmbTabHeight - (self.appearance.tabCloseButtonImage).size.height) / 2 + qmbTabTopOffset,
                                              (self.appearance.tabCloseButtonImage).size.width, (self.appearance.tabCloseButtonImage).size.height)];
    }else {
        [self.closeButton setFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    
    [self.titleLabel setFrame:CGRectMake(qmbTabSideOffset + qmbTabCurvature, 2.0f,
                                         qmbTabWidth - qmbTabSideOffset - 2*qmbTabCurvature - self.closeButton.frame.size.width, self.frame.size.height)];
    
    
    
    
    [self.titleLabel setFont:(_highlighted ? self.appearance.tabLabelFontHighlighted : self.appearance.tabLabelFontEnabled)];
    [self.titleLabel setTextColor:(_highlighted ? self.appearance.tabLabelColorHighlighted : self.appearance.tabLabelColorEnabled)];
    
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

- (void) didTap:(id)sender {
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
