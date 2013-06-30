//
//  QMBTab.m
//  QMBTabs Demo
//
//  Created by Toni Möckel on 29.06.13.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBTab.h"

const CGFloat kLTTabViewWidth = 60.0f;
const CGFloat kLTTabViewHeight = 2048.0f;
const CGFloat kLTTabInnerHeight = 80.0f;
const CGFloat kLTTabOuterHeight = 130.0f;
const CGFloat kLTTabLineHeight = 20.0f;
const CGFloat kLTTabCurvature = 10.0f;


@interface QMBTab ()


@end

@implementation QMBTab

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        self.normalColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.highlightColor = [UIColor colorWithWhite:0.7 alpha:1];
        
        _orgFrame = frame;
		_innerBackgroundColor = self.normalColor;
		_foregroundColor = [UIColor darkGrayColor];
        
        [self setClipsToBounds:NO];
        
		[self setOpaque:NO];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapGesture];
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


- (void)drawRect:(CGRect)dirtyRect
{

	CGContextRef context = UIGraphicsGetCurrentContext();
	UIColor *color;
	CGMutablePathRef path;
	CGPoint point;
	CGFloat lengths[2];
    CGFloat cornerOffset = (kLTTabOuterHeight - kLTTabInnerHeight) / 2;
    CGFloat startY = self.frame.size.height;//(kLTTabViewHeight - kLTTabOuterHeight) / 2;
	/*
    if (_highlighted){
        startY -= 5.0f;
    }
    */
	CGContextSaveGState(context);
    
#pragma mark - Shadow Begin
    
	color = [UIColor colorWithWhite:0.1f alpha:0.3f];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.5f), 7.0f, [color CGColor]);
	CGContextBeginTransparencyLayer(context, NULL);
	
#pragma mark - Tab
    
	path = CGPathCreateMutable();
	point = CGPointMake(0.0f, startY);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    CGPathAddLineToPoint(path, NULL, 5.0f, startY);
    CGPathAddLineToPoint(path, NULL, 15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-5.0f, startY);
    
	CGPathCloseSubpath(path);
	[[self innerBackgroundColor] setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);
    
    CGRect frame = self.frame;
    if (_highlighted){
        frame.size.height = _orgFrame.size.height - 5.0f;
    }else {
        frame.size.height = _orgFrame.size.height;
    }
    self.frame = frame;
    /*
    path = CGPathCreateMutable();
	point = CGPointMake(-1000.0f, startY);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    CGPathAddLineToPoint(path, NULL, 1000.0f, startY);
    CGPathAddLineToPoint(path, NULL, 1000.0f, startY-5.0f);
    CGPathAddLineToPoint(path, NULL, -1000.0f, startY-5.0f);
    
	CGPathCloseSubpath(path);
	[[self highlightColor] setFill];
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGPathRelease(path);
    */
    
#pragma mark - Shadow End

	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);

#pragma mark - Dots
    /*
	path = CGPathCreateMutable();
	point = CGPointMake(-1000.0f, startY);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
    
    CGPathAddLineToPoint(path, NULL, 5.0f, startY);
    CGPathAddLineToPoint(path, NULL, 15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-15.0f, 10.0f);
    CGPathAddLineToPoint(path, NULL, self.frame.size.width-5.0f, startY);
    
	CGPathCloseSubpath(path);
	[[self foregroundColor] setStroke];
    CGContextSetLineWidth(context, 1.0f);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineJoin(context, kCGLineJoinRound);
    lengths[0] = 1.0f;
	lengths[1] = 2.0f;

	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	*/
	CGContextRestoreGState(context);
}

- (void) setHighlighted:(BOOL)highlighted
{
    if (highlighted){
        [self setInnerBackgroundColor:self.highlightColor];
    }else {
        [self setInnerBackgroundColor:self.normalColor];
    }
    
    _highlighted = highlighted;
    
}

#pragma mark - Gesture

- (void) didTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectTab:)]){
        [self.delegate performSelector:@selector(didSelectTab:) withObject:self];
    }
}


@end
