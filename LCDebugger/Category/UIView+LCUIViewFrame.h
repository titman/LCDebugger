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

#import <UIKit/UIKit.h>
#import "LCTools.h"

@interface UIView (LCUIViewFrame)

LC_PROPERTY(assign) CGPoint xy;
LC_PROPERTY(assign) CGSize viewSize;

LC_PROPERTY(assign) CGFloat viewCenterX;
LC_PROPERTY(assign) CGFloat viewCenterY;
LC_PROPERTY(assign) CGFloat viewFrameX;
LC_PROPERTY(assign) CGFloat viewFrameY;
LC_PROPERTY(assign) CGFloat viewFrameWidth;
LC_PROPERTY(assign) CGFloat viewFrameHeight;

LC_PROPERTY(readonly) CGFloat viewRightX;
LC_PROPERTY(readonly) CGFloat viewBottomY;

LC_PROPERTY(readonly) CGFloat viewMidX;
LC_PROPERTY(readonly) CGFloat viewMidY;

LC_PROPERTY(readonly) CGFloat viewMidWidth;
LC_PROPERTY(readonly) CGFloat viewMidHeight;

-(instancetype) initWithX:(CGFloat)x Y:(CGFloat)y;

@end
