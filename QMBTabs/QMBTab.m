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

static float qmbTabSideOffset = 5.0f;
static float qmbTabTopOffset = 5.0f;
static float qmbTabBevelWidth = 10.0f;
static float qmbTabRadius = 5.0f;
static float pi = 3.14159265358979323846264338327950288f;

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
        
        //Title Label
        if (!self.titleLabel){
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 2.0f, self.frame.size.width-(2*20.0f), self.frame.size.height)];
            [titleLabel setText:NSLocalizedString(@"New tab is what it is", nil)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            [self addSubview:titleLabel];
            self.titleLabel = titleLabel;
        }
        
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
    if (!self.normalColor){
        self.normalColor = self.appearance.tabBackgroundColorEnabled;
        self.highlightColor = self.appearance.tabBackgroundColorHighlighted;
    }
    
    [self.closeButton setImage:self.appearance.tabCloseButtonImage forState:UIControlStateNormal];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGMutablePathRef path;
	CGPoint point;
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
    
    CGPathAddLineToPoint(path, NULL, qmbTabSideOffset, startY);
    CGPathAddLineToPoint(path, NULL, qmbTabBevelWidth + qmbTabSideOffset, qmbTabTopOffset);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - qmbTabBevelWidth - qmbTabSideOffset, qmbTabTopOffset);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - qmbTabSideOffset, startY);
    
    /* Radius development
    CGPathAddArc(path, NULL, qmbTabSideOffset - qmbTabRadius, startY - qmbTabRadius, qmbTabRadius, pi / 2, 0, true);
    // CGPathAddLineToPoint(path, NULL, qmbTabSideOffset, startY);
    CGPathAddLineToPoint(path, NULL, qmbTabBevelWidth + qmbTabSideOffset - qmbTabRadius, qmbTabTopOffset - qmbTabRadius);
    // CGPathAddArc(path, NULL, qmbTabBevelWidth + qmbTabSideOffset, qmbTabTopOffset - qmbTabRadius, qmbTabRadius, pi, pi / 2, true);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - qmbTabBevelWidth, qmbTabTopOffset);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width - qmbTabSideOffset, startY);
    */
     
	CGPathCloseSubpath(path);
	[_innerBackgroundColor setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);

	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
    
    [self.titleLabel setFrame:CGRectMake(20.0f, 2.0f, self.frame.size.width-(2*20.0f), self.frame.size.height)];
    [self.closeButton setFrame:CGRectMake(self.frame.size.width - qmbTabBevelWidth - (1.5 * (self.appearance.tabCloseButtonImage).size.width),
                                          (self.frame.size.height - (self.appearance.tabCloseButtonImage).size.height) / 2,
                                          (self.appearance.tabCloseButtonImage).size.width,
                                          (self.appearance.tabCloseButtonImage).size.height)];
    
    [self.titleLabel setFont:(_highlighted ? self.appearance.tabLabelFontHighlighted : self.appearance.tabLabelFontEnabled)];
    [self.titleLabel setTextColor:(_highlighted ? self.appearance.tabLabelColorHighlighted : self.appearance.tabLabelColorEnabled)];
    
    [self.closeButton setHidden:!_highlighted];
    
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
