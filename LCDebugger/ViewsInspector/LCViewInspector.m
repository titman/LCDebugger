//
//  LC_ViewInspector.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-9.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LCViewInspector.h"
#import "LCDebuggerView.h"
#import "UIWindow+LCUIWindowHook.h"

#define D2R( __degree ) (M_PI / 180.0f * __degree)

#define MAX_DEPTH	(36)

#pragma mark -

@interface UIView (LCScreenShot)

@end

@implementation UIView (LCScreenShot)

- (UIImage *) screenshotOneLayer
{
    NSMutableArray * temp = [NSMutableArray array];
    
    for ( UIView * subview in self.subviews )
    {
        if ( NO == subview.hidden )
        {
            subview.hidden = YES;
            
            [temp addObject:subview];
        }
    }
    
    UIImage * image = [self capture];
    
    for ( UIView * subview in temp )
    {
        subview.hidden = NO;
    }
    
    return image;
}

- (UIImage *)capture
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGRect captureBounds = CGRectZero;
    captureBounds.size = self.bounds.size;
    
    if ( captureBounds.size.width > screenSize.width )
    {
        captureBounds.size.width = screenSize.width;
    }
    
    if ( captureBounds.size.height > screenSize.height )
    {
        captureBounds.size.height = screenSize.height;
    }
    
    return [self capture:captureBounds];
}

- (UIImage *)capture:(CGRect)frame
{
    UIImage * result = nil;
    
    UIGraphicsBeginImageContextWithOptions( frame.size, NO, 1.0 );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ( context )
    {
        CGContextTranslateCTM( context, -frame.origin.x, -frame.origin.y );
        
        //		CGContextScaleCTM(context, 0.5, 0.5);
        [self.layer renderInContext:context];
        
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end

@implementation LCInspectorLayer


- (instancetype) init
{
    if (self = [super init]) {
        
        self.userInteractionEnabled = YES;
        
        self.label = [[UILabel alloc] init];
        self.label.hidden = NO;
        self.label.textColor = [UIColor yellowColor];
        self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.label.font = [UIFont boldSystemFontOfSize:12.0f];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];

    }
    
    return self;
}

- (void)setFrame:(CGRect)f
{
	[super setFrame:f];
	
	CGRect labelFrame;
	labelFrame.size.width = fminf( 200.0f, f.size.width );
	labelFrame.size.height = fminf( 16.0f, f.size.height );
	labelFrame.origin.x = 0;
	labelFrame.origin.y = 0;
    
	self.label.frame = labelFrame;
}

@end

#pragma mark -

@interface LCViewInspector ()
{
    float				_rotateX;
    float				_rotateY;
    float				_distance;
	BOOL				_animating;
	
	CGPoint				_panOffset;
	CGFloat				_pinchOffset;
	
	UIButton *          _showLabel;
	BOOL				_labelShown;
    
    UIView *            _inView;
}

@end

#pragma mark -

@implementation LCViewInspector

-(id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];

        self.alpha = 0;
        
        _labelShown = NO;
        
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [self addGestureRecognizer:pan];
        

        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandle:)];
        [self addGestureRecognizer:pinch];

        
        CGRect buttonFrame;
        buttonFrame.size.width = 160.0f;
        buttonFrame.size.height = 40.0f;
        buttonFrame.origin.x = 10.0f;
        buttonFrame.origin.y = self.frame.size.height - buttonFrame.size.height - 10.0f;
        
        _showLabel = [[UIButton alloc] initWithFrame:buttonFrame];
        _showLabel.hidden = NO;
        [_showLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _showLabel.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _showLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        _showLabel.layer.cornerRadius = 6.0f;
        _showLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _showLabel.layer.borderWidth = 1.0f;
        [_showLabel setTitle:@"Show view name (OFF)" forState:UIControlStateNormal];
        [_showLabel addTarget:self action:@selector(showLabelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_showLabel];

        
        buttonFrame.size.width = 100;
        buttonFrame.origin.y = self.frame.size.height - buttonFrame.size.height*2 - 10.0f*2;
        
        
        UIButton * closeButton = [[UIButton alloc] initWithFrame:buttonFrame];
        closeButton.hidden = NO;
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        closeButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        closeButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        closeButton.layer.cornerRadius = 6.0f;
        closeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        closeButton.layer.borderWidth = 1.0f;
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    
    return self;
}

- (void)buildSublayersFor:(UIView *)view depth:(CGFloat)depth origin:(CGPoint)origin
{
	if ( depth >= MAX_DEPTH )
		return;
	
	if ( view.hidden )
		return;
    
	if ( 0 == view.frame.size.width || 0 == view.frame.size.height )
		return;
    
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect viewFrame;
	
	viewFrame.origin.x = origin.x + view.center.x - view.bounds.size.width / 2.0f;
	viewFrame.origin.y = origin.y + view.center.y - view.bounds.size.height / 2.0f;
    
	if ( [view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UITableView class]] )
	{
		CGPoint viewOrigin = [self convertPoint:CGPointZero toView:view];
		viewFrame.origin.x -= viewOrigin.x;
		viewFrame.origin.y -= viewOrigin.y;
	}
    
	viewFrame.size.width = view.bounds.size.width;
	viewFrame.size.height = view.bounds.size.height;
	
	CGFloat overflowWidth = screenBound.size.width * 1.5;
	CGFloat overflowHeight = screenBound.size.height * 1.5;
	
	if ( CGRectGetMaxX(viewFrame) < -overflowWidth || CGRectGetMinX(viewFrame) > (screenBound.size.width + overflowWidth) )
		return;
	if ( CGRectGetMaxY(viewFrame) < -overflowHeight || CGRectGetMinY(viewFrame) > (screenBound.size.height + overflowHeight) )
		return;
    
    //	INFO( @"view = %@", [[view class] description] );
	
	LCInspectorLayer * layer = [[LCInspectorLayer alloc] init];
    
	if ( layer )
	{
		layer.layer.borderWidth = 1.5f;
		layer.layer.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.5].CGColor;
		layer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        
		CGPoint anchor;
		anchor.x = (screenBound.size.width / 2.0f - viewFrame.origin.x) / viewFrame.size.width;
		anchor.y = (screenBound.size.height / 2.0f - viewFrame.origin.y) / viewFrame.size.height;
        
		layer.view = view;
		
		if ( view.tag )
		{
			layer.label.text = [NSString stringWithFormat:@"%@ (%@)", [[view class] description], @(view.tag)];
			layer.label.textColor = [UIColor yellowColor];
		}
		else
		{
			layer.label.text =  [[view class] description];
			layer.label.textColor = [UIColor yellowColor];
		}
		
		layer.label.hidden = _labelShown ? NO : YES;
		layer.rect = viewFrame;
		layer.depth = depth;
		layer.frame = viewFrame;
		layer.image = view.screenshotOneLayer;
		layer.layer.anchorPoint = anchor;
		layer.layer.anchorPointZ = (layer.depth * -1.0f) * 75.0f;
		[self addSubview:layer];
	}
    
	for ( UIView * subview in view.subviews )
	{
        if (![subview isKindOfClass:[LCViewInspector class]] && ![subview isKindOfClass:[LCDebuggerView class]] && ![subview isKindOfClass:[LCWindowHookBorder class]]) {
            [self buildSublayersFor:subview depth:(depth + 1 + [view.subviews indexOfObject:subview] * 0.025f) origin:layer.rect.origin];
        }
	}
}

- (void)buildLayers
{
	[self buildSublayersFor:[UIApplication sharedApplication].keyWindow depth:0 origin:CGPointZero];
}

- (void)removeLayers
{
	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];
    
	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[LCInspectorLayer class]] )
		{
			[subview removeFromSuperview];
		}
	}
}

- (void)transformLayers:(BOOL)setFrames
{
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = -0.002;
	transform2 = CATransform3DTranslate( transform2, _rotateY * -2.5f, 0, 0 );
	transform2 = CATransform3DTranslate( transform2, 0, _rotateX * 3.5f, 0 );
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation( 0, 0, _distance * 1000 );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateX), 1, 0, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateY), 0, 1, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(0), 0, 0, 1), transform );
    transform = CATransform3DConcat( transform, transform2 );
    
	NSArray * subviewsCopy = [NSArray arrayWithArray:self.subviews];
    
	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[LCInspectorLayer class]] )
		{
			LCInspectorLayer * layer = (LCInspectorLayer *)subview;
			layer.frame = layer.rect;
            
			if ( _animating )
			{
				layer.layer.transform = CATransform3DIdentity;
			}
			else
			{
				layer.layer.transform = transform;
			}
			
			[layer setNeedsDisplay];
		}
	}
}

- (void)prepareShow:(UIView *)inView
{
    _inView = inView;
    [_inView addSubview:self];
    
	[self removeLayers];
	[self buildLayers];
    
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;
	
    //	[self setAlpha:1.0f];
	[self transformLayers:YES];
}

- (void)show
{
	_rotateX = 5.0f;
	_rotateY = 30.0f;
	_distance = -1.0f;
	_animating = NO;
    
    //	[self setAlpha:1.0f];
	[self transformLayers:NO];
}

- (void)prepareHide
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;
    
    [self setAlpha:0.0f];
	[self transformLayers:YES];
}

- (void)hide
{
	_animating = NO;
    
	[self removeLayers];
    [self removeFromSuperview];
}


-(void) panHandle:(UIPanGestureRecognizer *)panGesture
{
	if ( UIGestureRecognizerStateBegan == panGesture.state )
	{
        _panOffset.x = _rotateY;
        _panOffset.y = _rotateX * -1.0f;
	}
	else if ( UIGestureRecognizerStateChanged == panGesture.state )
	{
        _rotateY = _panOffset.x + [panGesture translationInView:self].x * 0.5f;
        _rotateX = _panOffset.y * -1.0f - [panGesture translationInView:self].y * 0.5f;
        
        [self transformLayers:NO];
	}
}

-(void) pinchHandle:(UIPinchGestureRecognizer *)pinch
{
    if (UIGestureRecognizerStateBegan == pinch.state) {
        
        _pinchOffset = _distance;
    }
    else if (UIGestureRecognizerStateChanged == pinch.state){
        
        _distance = _pinchOffset + (pinch.scale - 1);
        _distance = (_distance < -5 ? -5 : (_distance > 0.5 ? 0.5 : _distance));
        
        [self transformLayers:NO];
    }
}

-(void) showLabelAction
{
    _labelShown = _labelShown ? NO : YES;
	
	if ( _labelShown )
	{
		[_showLabel setTitle:@"Show view name (ON)" forState:UIControlStateNormal];
	}
	else
	{
        [_showLabel setTitle:@"Show view name (OFF)" forState:UIControlStateNormal];
	}
    
	for ( LCInspectorLayer * layer in self.subviews )
	{
		if ( [layer isKindOfClass:[LCInspectorLayer class]] )
		{
			layer.label.hidden = _labelShown ? NO : YES;
		}
	}
}

-(void) closeButton
{
    [UIView beginAnimations:@"CLOSE" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didClose)];
    
	[UIApplication sharedApplication].keyWindow.layer.transform = CATransform3DIdentity;
    
	[self prepareHide];
	
	[UIView commitAnimations];
}

-(void) didClose
{
    [self hide];
}

@end
