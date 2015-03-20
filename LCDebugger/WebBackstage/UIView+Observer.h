//
//  UIView+Observer.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-4.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Observer)

+ (BOOL)needsRefresh;

+ (void)setNeedsRefresh:(BOOL)_needsrefresh;

+ (void)startObserving;

+ (void)stopObserving;

@end
