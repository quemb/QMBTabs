//
//  QMBBadgeView.m
//  QMBTabs Demo
//
//  Created by Barry Allard on 2013-08-18.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBBadgeView.h"

@interface QMBBadgeView ()

@end

@implementation QMBBadgeView
@synthesize text = _text;
@synthesize textLabel = _textLabel;
@synthesize color = _color;
@synthesize cornerRadius = _cornerRadius;

#pragma mark -
#pragma mark Initialization

- (id) initWithFrame:(CGRect)rect
{
	if ((self = [super initWithFrame:rect])) {
        self.opaque = NO;
		self.backgroundColor = UIColor.clearColor;
        self.cornerRadius = 12.0f;
        self.color = self.class.defaultColor;
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.textColor = self.class.defaultTextColor;
	}
	return self;
}

#pragma mark - Class Methods

+ (UIColor *) defaultColor
{
    return UIColor.blueColor;
}

+ (UIColor *) defaultTextColor
{
    return UIColor.whiteColor;
}

#pragma mark -
#pragma mark Accessors

- (void) setColor:(UIColor *)color
{
	_color = color;
	
	[self setNeedsDisplay];
}


- (void) setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	
	[self setNeedsDisplay];
}

void DrawRoundedRect(CGContextRef context, CGRect rect, CGFloat radius)
{
	CGPoint min = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
	CGPoint max = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
	
	CGContextMoveToPoint(context, min.x, mid.y);
	CGContextAddArcToPoint(context, min.x, min.y, mid.x, min.y, radius);
	CGContextAddArcToPoint(context, max.x, min.y, max.x, mid.y, radius);
	CGContextAddArcToPoint(context, max.x, max.y, mid.x, max.y, radius);
	CGContextAddArcToPoint(context, min.x, max.y, min.x, mid.y, radius);
	
	CGContextClosePath(context);
	CGContextFillPath(context);
}

#pragma mark -

- (void) drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGSize size = self.frame.size;
	CGSize badgeSize = [self sizeThatFits:size];
	badgeSize.height = fminf(badgeSize.height, size.height);
	
    CGRect badgeRect = [self badgeRect:badgeSize withSize:size];
	if (_color) {
		[_color set];
		DrawRoundedRect(context, badgeRect, _cornerRadius);
	}
	
	[self.textLabel drawTextInRect:badgeRect];
}

- (CGRect) badgeRect:(CGSize) badgeSize withSize:(CGSize)size
{
    if (self.hidden) {
        return CGRectMake(0, 0, 0, 0);
    }
    return CGRectMake(roundf((size.width - badgeSize.width) / 2.0f),
               roundf((size.height - badgeSize.height) / 2.0f),
               badgeSize.width,
               badgeSize.height);
}

- (CGSize) sizeThatFits:(CGSize)size
{
    if (self.hidden) {
        return CGSizeMake(0.0f, 0.0f);
    }
	CGSize textSize = [self.textLabel sizeThatFits:self.bounds.size];
	return CGSizeMake(fmaxf(textSize.width + 12.0f, 30.0f), textSize.height + 8.0f);
}

- (void) willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
	if (newSuperview) {
		[self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        self.hidden = (_textLabel.text.length == 0);
	} else {
		[self.textLabel removeObserver:self forKeyPath:@"text"];
	}
}

- (void) setText:(NSString *)text
{
    self.textLabel.text = text;
    BOOL hidden = (text.length == 0);
    self.hidden = hidden;
    if (!hidden) {
        [self sizeToFit];
    }
    [self setNeedsDisplay];
}

- (NSString*) text
{
    return self.textLabel.text;
}

#pragma mark - KVO Notifications

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == _textLabel && [keyPath isEqualToString:@"text"]) {
		NSString *text = [change objectForKey:NSKeyValueChangeNewKey];
		if ([text isEqual:[NSNull null]]) {
			text = nil;
		}
		self.hidden = (text.length == 0);
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
@end
