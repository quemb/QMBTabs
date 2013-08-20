//
//  QMBNumericBadgeView.m
//  QMBTabs Demo
//
//  Created by Barry Allard on 2013-08-18.
//  Copyright (c) 2013 Toni Möckel. All rights reserved.
//

#import "QMBNumericBadgeView.h"

@implementation QMBNumericBadgeView
@synthesize maxCount = _maxCount;
@synthesize count = _count;
@synthesize countRoundingMultiple = _countRoundingMultiple;

- (id) initWithFrame:(CGRect)rect
{
	if ((self = [super initWithFrame:rect])) {
        _maxCount = 999;
 	}
	return self;
}


- (NSString*) displayedBadge:(NSUInteger)count
{
    NSUInteger bc = self.count;
    if (bc == 0) {
        return @"";
    }
    // Cap to a limit
    if (self.maxCount > 0 && bc > self.maxCount) {
        return [NSString stringWithFormat:@"%d+", self.maxCount];
    }
    // Round if neccessary
    if (self.countRoundingMultiple > 0) {
        bc = (bc / self.countRoundingMultiple) * self.countRoundingMultiple;
    }
    return [NSString stringWithFormat:@"%d", bc];
}

- (void) setCount:(NSUInteger)count
{
    _count = count;
    self.text = [self displayedBadge:count];
    [self setNeedsDisplay];
}

- (void) setMaxCount:(NSUInteger)maxCount
{
    if (maxCount != _maxCount) {
		_maxCount = maxCount;
        self.count = self.count; // redisplay count
	}
}

- (void) setCountRoundingMultiple:(NSUInteger)countRoundingMultiple
{
    if (countRoundingMultiple != _countRoundingMultiple) {
        _countRoundingMultiple = countRoundingMultiple;
        self.count = self.count; // redisplay count
    }
}
@end
