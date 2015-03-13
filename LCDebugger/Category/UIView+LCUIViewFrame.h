//
//  UIView+UIViewFrame.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-21.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <UIKit/UIKit.h>

@interface UIView (LCUIViewFrame)

@property(nonatomic,assign) CGPoint xy;
@property(nonatomic,assign) CGSize viewSize;

@property(nonatomic,assign) float viewCenterX;
@property(nonatomic,assign) float viewCenterY;
@property(nonatomic,assign) float viewFrameX;
@property(nonatomic,assign) float viewFrameY;
@property(nonatomic,assign) float viewFrameWidth;
@property(nonatomic,assign) float viewFrameHeight;

@property(nonatomic,assign,readonly) float viewRightX;
@property(nonatomic,assign,readonly) float viewBottomY;

@property(nonatomic,assign,readonly) float viewMidX;
@property(nonatomic,assign,readonly) float viewMidY;

@property(nonatomic,assign,readonly) float viewMidWidth;
@property(nonatomic,assign,readonly) float viewMidHeight;

-(instancetype) initWithX:(float)x Y:(float)y;

@end
