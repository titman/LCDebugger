//
//  LC_UIKeyBoardManager.h
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-17.
//  Copyright (c) 2013年 LS Developer ( http://www.likesay.com ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LCUIKeyBoard : NSObject

@property (nonatomic,readonly) float animationDuration;
@property (nonatomic,readonly) float height;
@property (nonatomic,readonly) BOOL isShowing;

- (void)setAccessor:(UIView *)view;

@end
