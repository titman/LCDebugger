//
//  LCDebuggerTip.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCDebuggerView.h"
#import "LCViewInspector.h"
#import "LCSystemInfo.h"
#import "LCNetworkTraffic.h"
#import "UIWindow+LCUIWindowHook.h"
#import "LCCPUTableView.h"

typedef void (^__LCDebuggerLogButtonDidTap) ( NSInteger index );

@interface __LCDebuggerLog : UIView

@property(nonatomic,copy) __LCDebuggerLogButtonDidTap didTapButton;

@end

@implementation __LCDebuggerLog

-(instancetype) init
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        
        [self buildUI];
    }
    
    return self;
}

-(void) buildUI
{
    CGFloat inv = 10;
    CGFloat width = (self.frame.size.width - (inv * 5)) / 4;
    NSArray * titles = @[@"System Info",@"Skeleton",@"Crash Report",@"CMD Input"];
    
    for (NSInteger i = 0; i< 4; i++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(inv * (i + 1) + width * i, 0, width, 30)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius = 6.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0f;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    LCCPUTableView * tableView = [[LCCPUTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
    [self addSubview:tableView];
    
    [tableView show];
}

-(void) buttonAction:(UIButton *)button
{
    if (self.didTapButton) {
        self.didTapButton(button.tag);
    }
}

@end

#pragma mark -

@interface LCDebuggerView ()
{
    BOOL _isDragging;
    BOOL _singleTapBeenCanceled;
    
    CGPoint _beginLocation;
    CGRect _lastFrame;
}

@property (nonatomic,strong) UIView * contentView;
@property (nonatomic) BOOL draggable;
@property (nonatomic) BOOL autoDocking;

@property (nonatomic,strong) UILabel * simplePreview;
@property (nonatomic,strong) UILabel * closeButton;

@property (nonatomic,strong) __LCDebuggerLog * mainView;

@end

@implementation LCDebuggerView

-(instancetype) init
{
    if (self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 70, [UIScreen mainScreen].bounds.size.height - 70 - 50, 70, 70)]) {
        
        [UIWindow hook];

        [self buildUI];
    }
    
    return self;
}


-(void) buildUI
{
    [self defaultSetting];
    
    [self performSelector:@selector(addToKeyWindow) withObject:nil afterDelay:0];
}

- (void)defaultSetting
{
    self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    self.layer.cornerRadius = 16;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    
    
    self.closeButton = [[UILabel alloc] init];
    self.closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 30, 0, 64, 64);
    self.closeButton.text = @"✕";
    self.closeButton.font = [UIFont systemFontOfSize:18];
    self.closeButton.textColor = [UIColor whiteColor];
    self.closeButton.alpha = 0;
    [self addSubview:self.closeButton];
    
    
    self.simplePreview = [[UILabel alloc] init];
    self.simplePreview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.simplePreview.font = [UIFont systemFontOfSize:10];
    self.simplePreview.textColor = [UIColor whiteColor];
    self.simplePreview.textAlignment = NSTextAlignmentCenter;
    self.simplePreview.numberOfLines = 0;
    self.simplePreview.tag = 1;
    [self addSubview:self.simplePreview];
    
    
    self.mainView = [[__LCDebuggerLog alloc] init];
    self.mainView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.mainView.alpha = 0;
    [self addSubview:self.mainView];
    
    @weakly(self);
    
    self.mainView.didTapButton = ^(NSInteger index){
        
        @normally(self);
        
        if (index == 1) {
            
            [self restore:^{
                
                LCViewInspector * vi = [[LCViewInspector alloc] init];
                [vi prepareShow:[UIApplication sharedApplication].keyWindow];
                vi.alpha = 1;
                
                
                [UIView beginAnimations:@"OPEN" context:nil];
                [UIView setAnimationBeginsFromCurrentState:YES];
                [UIView setAnimationDuration:1.0f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                
                [vi show];
                
                [UIView commitAnimations];
                
            }];
        }
    };
    
    _draggable = YES;
    _autoDocking = YES;
    _singleTapBeenCanceled = NO;
    
    [self addTarget:self action:@selector(didSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self update];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)addToKeyWindow
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void) addLog:(NSString *)log;
{
    
}

-(void) didSelectedAction
{
    if (!_singleTapBeenCanceled && !_isDragging) {

        [self performSelector:@selector(executeButtonTouchedBlock) withObject:nil afterDelay:0];
    }
}

-(void) update
{
    if (self.simplePreview.tag == 1) {
        
        self.simplePreview.text = [NSString stringWithFormat:@"DEBUG\n CPU:%.0f%%\n DISK:%@", [LCSystemInfo cpuUsed] * 100, [LCSystemInfo freeDiskSpace]];
    }
    else{
        
        self.simplePreview.text = [NSString stringWithFormat:@"DEBUG  |  CPU:%.0f%%  |  DISK:%@", [LCSystemInfo cpuUsed] * 100, [LCSystemInfo freeDiskSpace]];
    }
}

-(void) executeButtonTouchedBlock
{
    if (self.frame.size.width == [UIScreen mainScreen].bounds.size.width) {
        
        [self restore:nil];
        return;
    }
    
    _lastFrame = self.frame;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(10);
    animation.toValue = @(0.0f);
    animation.duration = 0.25;
    [self.layer addAnimation:animation forKey:@"cornerRadius"];
    [self.layer setCornerRadius:0.0];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.layer.shadowColor = [UIColor clearColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1;
        
        self.simplePreview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        self.simplePreview.tag = 2;

        self.mainView.alpha = 1;
        self.closeButton.alpha = 1;
    }];
}


-(void) restore:(void (^)(void))finishedBlock
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = @(0);
    animation.toValue = @(10);
    animation.duration = 0.25;
    [self.layer addAnimation:animation forKey:@"cornerRadius"];
    [self.layer setCornerRadius:10];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = _lastFrame;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 1;
        
        self.simplePreview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.simplePreview.tag = 1;
        
        self.mainView.alpha = 0;
        self.closeButton.alpha = 0;
        
    } completion:^(BOOL finished) {
       
        if (finishedBlock) {
            finishedBlock();
        }
    }];
}

#pragma mark - 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    _isDragging = NO;
    
    UITouch * touch = [touches anyObject];
    
    if (touch.tapCount == 2) {
        _singleTapBeenCanceled = YES;

    } else {
        
        _singleTapBeenCanceled = NO;
    }
    
    _beginLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_draggable) {
        
        _isDragging = YES;
        
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self];
        
        float offsetX = currentLocation.x - _beginLocation.x;
        float offsetY = currentLocation.y - _beginLocation.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat leftLimitX = frame.size.width / 2;
        CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
        CGFloat topLimitY = frame.size.height / 2;
        CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
        
        if (self.center.x > rightLimitX) {
            self.center = CGPointMake(rightLimitX, self.center.y);
        }else if (self.center.x <= leftLimitX) {
            self.center = CGPointMake(leftLimitX, self.center.y);
        }
        
        if (self.center.y > bottomLimitY) {
            self.center = CGPointMake(self.center.x, bottomLimitY);
        }else if (self.center.y <= topLimitY){
            self.center = CGPointMake(self.center.x, topLimitY);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    
    if (_isDragging && _autoDocking) {
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat middleX = superviewFrame.size.width / 2;
        
        if (self.center.x >= middleX) {
            [UIView animateWithDuration:0.15 animations:^{
                self.center = CGPointMake(superviewFrame.size.width - frame.size.width / 2, self.center.y);
            } completion:^(BOOL finished) {
            }];
        } else {
            [UIView animateWithDuration:0.15 animations:^{
                self.center = CGPointMake(frame.size.width / 2, self.center.y);
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];

    _isDragging = NO;
}

#pragma mark -

- (BOOL)isDragging
{
    return _isDragging;
}


@end
