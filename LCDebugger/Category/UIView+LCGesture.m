//
//  UIView+TapGesture.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-11.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "UIView+LCGesture.h"

#pragma mark -

@interface __LC_TapGesture : UITapGestureRecognizer

@end

#pragma mark -

@implementation __LC_TapGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{
		self.numberOfTapsRequired = 1;
		self.numberOfTouchesRequired = 1;
		self.cancelsTouchesInView = YES;
		self.delaysTouchesBegan = YES;
		self.delaysTouchesEnded = YES;
	}
	return self;
}

@end

#pragma mark -

#pragma mark -

@interface __LC_PanGesture : UIPanGestureRecognizer

@end

#pragma mark -

@implementation __LC_PanGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
	if ( self )
	{

	}
	return self;
}

@end

#pragma mark -

@interface __LC_PinchGesture : UIPinchGestureRecognizer
@end

@implementation __LC_PinchGesture

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super initWithTarget:target action:action];
    
	if ( self )
	{
        
	}
	return self;
}

@end

#pragma mark -

@implementation UIView (LCGesture)

#pragma mark -

- (CGPoint) panOffset
{
	return [self.panGesture translationInView:self];
}

- (CGFloat) pinchScale
{
	UIPinchGestureRecognizer * gesture = self.pinchGesture;
	if ( nil == gesture )
	{
		return 1.0f;
	}
	
	return gesture.scale;
}

#pragma mark -

- (UITapGestureRecognizer *)tapGesture
{
	__LC_TapGesture * tapGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__LC_TapGesture class]] )
		{
			tapGesture = (__LC_TapGesture *)gesture;
		}
	}
	
	return tapGesture;
}

-(UITapGestureRecognizer *) addTapTarget:(id)target selector:(SEL)selector
{
    __LC_TapGesture * tapGesture = [[__LC_TapGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

#pragma mark -

- (UIPanGestureRecognizer *) panGesture
{
	__LC_PanGesture * panGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__LC_PanGesture class]] )
		{
			panGesture = (__LC_PanGesture *)gesture;
		}
	}
	
	return panGesture;
}

-(UIPanGestureRecognizer *) addPanTarget:(id)target selector:(SEL)selector
{
    __LC_PanGesture * panGesture = [[__LC_PanGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:panGesture];
    
    return panGesture;
}

#pragma mark -

-(UIPinchGestureRecognizer *) pinchGesture
{
    __LC_PinchGesture * pinchGesture = nil;
	
	for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
	{
		if ( [gesture isKindOfClass:[__LC_PinchGesture class]] )
		{
			pinchGesture = (__LC_PinchGesture *)gesture;
		}
	}
	
	return pinchGesture;
}

-(UIPinchGestureRecognizer *) addPinchTarget:(id)target selector:(SEL)selector
{
    __LC_PinchGesture * pinchGesture = [[__LC_PinchGesture alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:pinchGesture];
    
    return pinchGesture;
}

@end
