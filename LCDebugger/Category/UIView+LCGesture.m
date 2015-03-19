//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
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
