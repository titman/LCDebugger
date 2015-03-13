//
//  UIView+Extension.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-11.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "UIView+LCExtension.h"
#import <objc/runtime.h>

@implementation UIView (LCExtension)

- (UIViewAddSubviewBlock)ADD
{
    UIViewAddSubviewBlock block = ^ id ( UIView * obj )
    {
        [self addSubview:obj];
        return self;
    };
    
    return block;
}

- (UIViewSizeToFitBlock)FIT
{
    UIViewSizeToFitBlock block = ^ id ()
    {
        [self sizeToFit];
        return self;
    };
    
    return block;
}


- (void)removeAllSubviews
{
	NSArray * array = [self.subviews copy];
    
	for ( UIView * view in array )
	{
		[view removeFromSuperview];
	}
}

+ (instancetype)view
{
	return [[self alloc] init];
}

+ (instancetype)viewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (UIViewController *)viewController
{
	UIView * view = self;
	
    //	while ( nil != view )
    //	{
    //		if ( nil == view.superview )
    //			break;
    //
    //		view = view.superview;
    //	}
    
	UIResponder * nextResponder = [view nextResponder];
    
	if ( nextResponder && [nextResponder isKindOfClass:[UIViewController class]] )
	{
		return (UIViewController *)nextResponder;
	}
	
	return nil;
}

//-(NSString *) signalName
//{
//    NSObject * obj = objc_getAssociatedObject( self, @"__SignalName" );
//    
//	if ( obj && [obj isKindOfClass:[NSString class]] ){
//        return (NSString *)obj;
//    }
//    else{
//        
//        return nil;
//    }
//    
//}
//
//-(void) setSignalName:(NSString *)signalName
//{
//    objc_setAssociatedObject( self, @"__SignalName", signalName, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
//
//    if (self.tapGesture) {
//        [self removeGestureRecognizer:self.tapGesture];
//    }
//    
//    if (signalName) {
//        
//        [self addTapTarget:self selector:@selector(__didTapAction)];
//    }
//    else{
//        
//    }
//}
//
//-(void) __didTapAction
//{
//    if ( self.signalName )
//    {
//        [self sendUISignal:self.signalName];
//    }
//}

@end
