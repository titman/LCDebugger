//
//  UIView+UIViewFrame.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-21.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "UIView+LCUIViewFrame.h"
#import "LCDebuggerImport.h"

@implementation UIView (LCUIViewFrame)

-(instancetype) initWithX:(float)x Y:(float)y
{
    if (self = [self initWithFrame:CGRectMake(x,y,0,0)]) {
        
    }
    
    return self;
}

-(CGPoint)xy
{
    return CGPointMake(self.viewFrameX, self.viewFrameY);
}

-(float) viewCenterX
{
    return self.center.x;
}

-(void) setViewCenterX:(float)viewCenterX
{
    self.center = LC_POINT(viewCenterX, self.viewCenterY);
}

-(float) viewCenterY
{
    return self.center.y;
}

-(void) setViewCenterY:(float)viewCenterY
{
    self.center = LC_POINT(self.viewCenterX, viewCenterY);
}

-(void) setXy:(CGPoint)xy
{
    self.frame = LC_RECT_CREATE(xy.x, xy.y, self.viewFrameWidth, self.viewFrameHeight);
}

-(float) viewFrameX
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

-(void) setViewFrameX:(float)newViewFrameX
{
    self.frame = LC_RECT_CREATE(newViewFrameX, self.viewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(float) viewFrameY
{
    return self.frame.origin.y;
}

-(void) setViewFrameY:(float)newViewFrameY
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, newViewFrameY, self.viewFrameWidth, self.viewFrameHeight);
}

-(float) viewFrameWidth
{
    return self.frame.size.width;
}

-(void) setViewFrameWidth:(float)newViewFrameWidth
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, self.viewFrameY, newViewFrameWidth, self.viewFrameHeight);
}

-(float) viewFrameHeight
{
    return self.frame.size.height;
}

-(void) setViewFrameHeight:(float)newViewFrameHeight
{
    self.frame = LC_RECT_CREATE(self.viewFrameX, self.viewFrameY, self.viewFrameWidth, newViewFrameHeight);
}

-(float) viewRightX
{
    return self.viewFrameX+self.viewFrameWidth;
}

-(float) viewBottomY
{
    return self.viewFrameY+self.viewFrameHeight;
}

-(float) viewMidX
{
    return self.viewFrameX/2;
}

-(float) viewMidY
{
    return self.viewFrameY/2;
}

-(float) viewMidWidth
{
    return self.viewFrameWidth/2;
}

-(float) viewMidHeight
{
    return self.viewFrameHeight/2;
}

@end
