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

#import "LCUIKeyBoard.h"
#import "LCDebuggerImport.h"

#define	DEFAULT_KEYBOARD_HEIGHT	(216.0f)

@interface LCUIKeyBoard ()
{
	CGRect		_accessorFrame;
	UIView *	_accessor;
}

@end

@implementation LCUIKeyBoard


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(id) init
{
    LC_SUPER_INIT({
    
        _isShowing = NO;
        _animationDuration = 0.25;
        _height = DEFAULT_KEYBOARD_HEIGHT;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIKeyboardDidHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    });
}


-(void) handleNotification:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    
	if ( userInfo )
	{
		_animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	}
    
    if ([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        
        if (NO == _isShowing){
			_isShowing = YES;
            // Is showing.
		}
		
		NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value)
		{
			CGRect keyboardEndFrame = [value CGRectValue];
			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if ( keyboardHeight != _height )
			{
				_height = keyboardHeight;
                // Height changed.
			}
		}


    }else if ([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification]){
        
        NSValue * value1 = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
		NSValue * value2 = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value1 && value2)
		{
			CGRect rect1 = [value1 CGRectValue];
			CGRect rect2 = [value2 CGRectValue];
            
			if (rect1.origin.y >= [UIScreen mainScreen].bounds.size.height){
				if (NO == _isShowing){
					_isShowing = YES;
					// Is showing.
				}
                
				if ( rect2.size.height != _height ){
					_height = rect2.size.height;
					// Height changed.
				}
			}
			else if (rect2.origin.y >= [UIScreen mainScreen].bounds.size.height){
				if (rect2.size.height != _height){
					_height = rect2.size.height;
					// Height changed.
				}
                
				if (_isShowing){
					_isShowing = NO;
					// Is hidden.
				}
			}
		}
    }else if ([notification.name isEqualToString:UIKeyboardDidHideNotification]){
    
        NSValue * value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
		if (value)
		{
			CGRect	keyboardEndFrame = [value CGRectValue];

			CGFloat	keyboardHeight = keyboardEndFrame.size.height;
			
			if (keyboardHeight != _height){
				_height = keyboardHeight;
			}
		}
        
		if (_isShowing){
			_isShowing = NO;
			// Height changed.
		}
    }

    [self updateAccessorFrame];
}

- (void)setAccessor:(UIView *)view
{
	_accessor = view;
	_accessorFrame = view.frame;
}

-(void) updateAccessorFrame
{
    if ( nil == _accessor )
		return;
    
    LC_FAST_ANIMATIONS(self.animationDuration, ^{
    
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        if (_isShowing){
            CGFloat containerHeight = _accessor.superview.bounds.size.height;
            CGRect newFrame = _accessorFrame;
            newFrame.origin.y = containerHeight - (_accessorFrame.size.height + _height);
            _accessor.frame = newFrame;
        }
        else{
            _accessor.frame = _accessorFrame;
        }
    
    });
}


@end
