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

#import "UIView+LCUIViewFrame.h"
#import "LCDebuggerImport.h"

@implementation UIView (LCUIViewFrame)

-(instancetype) initWithX:(CGFloat)x Y:(CGFloat)y
{
    if (self = [self initWithFrame:CGRectMake(x,y,0,0)]) {
        
    }
    
    return self;
}

-(CGPoint)xy
{
    return CGPointMake(self.viewFrameX, self.viewFrameY);
}

-(CGFloat) viewCenterX
{
    return self.center.x;
}

-(void) setViewCenterX:(CGFloat)viewCenterX
{
    self.center = LC_POINT(viewCenterX, self.viewCenterY);
}

-(CGFloat) viewCenterY
{
    return self.center.y;
}

-(void) setViewCenterY:(CGFloat)viewCenterY
{
    self.center = LC_POINT(self.viewCenterX, viewCenterY);
}

-(void) setXy:(CGPoint)xy
{
    self.frame = LC_RECT_CREATE(xy.x, xy.y, self.viewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameX
{
    return self.frame.origin.x;
}

-(CGSize) viewSize
{
    return LC_SIZE(self.viewFrameWidth, self.viewFrameHeight);
}

-(void) setViewSize:(CGSize)viewSize
{
    self.viewFrameWidth = viewSize.width;
    self.viewFrameHeight = viewSize.height;
}

-(void) setViewFrameX:(CGFloat)newViewFrameX
{
    self.frame = LC_RECT_CREATE(newViewFrameX, self.viewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameY
{
    return self.frame.origin.y;
}

-(void) setViewFrameY:(CGFloat)newViewFrameY
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, newViewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameWidth
{
    return self.frame.size.width;
}

-(void) setViewFrameWidth:(CGFloat)newViewFrameWidth
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, self.viewFrameY, newViewFrameWidth, self.viewFrameHeight);
}

-(CGFloat) viewFrameHeight
{
    return self.frame.size.height;
}

-(void) setViewFrameHeight:(CGFloat)newViewFrameHeight
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, self.viewFrameY, self.viewFrameWidth, newViewFrameHeight);
}

-(CGFloat) viewRightX
{
    return self.viewFrameX+self.viewFrameWidth;
}

-(CGFloat) viewBottomY
{
    return self.viewFrameY+self.viewFrameHeight;
}

-(CGFloat) viewMidX
{
    return self.viewFrameX/2;
}

-(CGFloat) viewMidY
{
    return self.viewFrameY/2;
}

-(CGFloat) viewMidWidth
{
    return self.viewFrameWidth/2;
}

-(CGFloat) viewMidHeight
{
    return self.viewFrameHeight/2;
}

@end
