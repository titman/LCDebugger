//
//  UIView+Observer.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-4.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "UIView+Observer.h"
#import "MethodSwizzle.h"

static BOOL needsRefresh;

static BOOL observing;

@implementation UIView (Observer)

+ (void)startObserving
{
    if (observing == NO) {
        MethodSwizzle([UIView class], @selector(setNeedsLayout), @selector(setNeedsLayoutSwizzled));
        MethodSwizzle([UIView class], @selector(setNeedsDisplay), @selector(setNeedsDisplaySwizzled));
        MethodSwizzle([UIView class], @selector(setFrame:), @selector(setFrameSwizzled:));

        observing = YES;
    }
}

+ (void)stopObserving
{
    if (observing == YES) {
        MethodSwizzle([UIView class], @selector(setNeedsLayout), @selector(setNeedsLayoutSwizzled));
        MethodSwizzle([UIView class], @selector(setNeedsDisplay), @selector(setNeedsDisplaySwizzled));
        MethodSwizzle([UIView class], @selector(setFrame:), @selector(setFrameSwizzled:));

        observing = NO;
    }
}

+ (BOOL)needsRefresh
{
    return needsRefresh;
}

+ (void)setNeedsRefresh:(BOOL)_needsrefresh
{
    needsRefresh = _needsrefresh;
}

- (void)setNeedsDisplaySwizzled
{
    [self setNeedsDisplaySwizzled];
    needsRefresh = YES;
}

- (void)setNeedsLayoutSwizzled
{
    [self setNeedsLayoutSwizzled];
    needsRefresh = YES;
}

- (void)setFrameSwizzled:(CGRect)frame
{
    [self setFrameSwizzled:frame];
    needsRefresh = YES;
}

@end
