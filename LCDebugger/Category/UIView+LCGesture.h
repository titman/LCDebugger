//
//  UIView+TapGesture.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-11.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <UIKit/UIKit.h>

@interface UIView (LCGesture)

@property (nonatomic, readonly) UITapGestureRecognizer * tapGesture;
@property (nonatomic, readonly) UIPanGestureRecognizer * panGesture;
@property (nonatomic, readonly) UIPinchGestureRecognizer * pinchGesture;

@property (nonatomic, readonly) CGPoint	panOffset;
@property (nonatomic, readonly) CGFloat	pinchScale;


-(UITapGestureRecognizer *) addTapTarget:(id)target selector:(SEL)selector;
-(UIPanGestureRecognizer *) addPanTarget:(id)target selector:(SEL)selector;
-(UIPinchGestureRecognizer *) addPinchTarget:(id)target selector:(SEL)selector;

@end
