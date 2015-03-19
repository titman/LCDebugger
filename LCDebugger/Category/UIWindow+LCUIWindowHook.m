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

#import "UIWindow+LCUIWindowHook.h"
#import <objc/runtime.h>

@interface LCWindowHookIndicator : UIView

- (void)startAnimation;

@end

@implementation LCWindowHookIndicator

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
		self.userInteractionEnabled = NO;
	}
	return self;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	self.transform = CGAffineTransformMakeScale( 0.5f, 0.5f );
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

@end


@implementation LCWindowHookBorder

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.layer.borderWidth = 2.0f;
		self.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.5].CGColor;

        UILabel * label = [[UILabel alloc] init];
        label.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 9876521;
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 0;
        [self addSubview:label];
	}
	return self;
}

-(void) setText:(NSString *)text
{

}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	self.layer.cornerRadius = self.superview.layer.cornerRadius;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
    
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}



@end

@implementation UIWindow (LCUIWindowHook)

static BOOL	__printfTouchView = NO;
static BOOL	__blocked = NO;
static void (*__sendEvent)( id, SEL, UIEvent * );

+ (void)hook
{
	static BOOL __swizzled = NO;
    
	if ( NO == __swizzled )
	{
		Method method;
		IMP implement;
        
		method = class_getInstanceMethod( [UIWindow class], @selector(sendEvent:) );
		__sendEvent = (void *)method_getImplementation( method );
		
		implement = class_getMethodImplementation( [UIWindow class], @selector(mySendEvent:) );
		method_setImplementation( method, implement );
		
		__swizzled = YES;
	}
}

+ (void)block:(BOOL)flag
{
	__blocked = flag;
}

- (void) mySendEvent:(UIEvent *)event
{
	UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (self == keyWindow) {
        
        if ( UIEventTypeTouches == event.type )
        {
            NSSet * allTouches = [event allTouches];
            
            if ( 1 == [allTouches count] )
            {
                UITouch * touch = [[allTouches allObjects] objectAtIndex:0];
                
                if ( 1 == [touch tapCount] )
                {
                    if ( UITouchPhaseBegan == touch.phase )
                    {
                        if (__printfTouchView == YES) {
                            
                        }
                        
                        LCWindowHookBorder * border = [LCWindowHookBorder new];
                        border.frame = touch.view.bounds;
                        [touch.view addSubview:border];
                        [border startAnimation];
                    }
                    else if ( UITouchPhaseMoved == touch.phase )
                    {
                    }
                    else if ( UITouchPhaseEnded == touch.phase || UITouchPhaseCancelled == touch.phase )
                    {
                        LCWindowHookIndicator * indicator = [LCWindowHookIndicator new];
                        indicator.frame  = CGRectMake( 0, 0, 50.0f, 50.0f );
                        indicator.center = [touch locationInView:keyWindow];
						[keyWindow addSubview:indicator];
						[indicator startAnimation];
                    }
                }
            }
        }
        
    }
    
	if ( NO == __blocked )
	{
		if ( __sendEvent )
		{
			__sendEvent( self, _cmd, event );
		}
	}
}


@end

