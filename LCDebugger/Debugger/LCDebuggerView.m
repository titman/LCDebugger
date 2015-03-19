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

#import "LCDebuggerImport.h"
#import "LCDebuggerView.h"
#import "LCViewInspector.h"
#import "LCSystemInfo.h"
#import "LCNetworkTraffic.h"
#import "UIWindow+LCUIWindowHook.h"
#import "LCCPUTableView.h"
#import "LCLogView.h"
#import "LCActionSheet.h"
#import "LCDeviceTableView.h"
#import "LCProgressTableView.h"
#import "LCRAMTableView.h"
#import "LCNetworkTableView.h"
#import "LCStorageTableView.h"
#import "LCWebBackstageTableView.h"

typedef void (^__LCDebuggerLogButtonDidTap) ( NSInteger index );

@interface __LCDebuggerLog : UIView

LC_PROPERTY(strong) UILabel * backView;
LC_PROPERTY(strong) UIView * currentView;
LC_PROPERTY(strong) LCLogView * logView;

LC_PROPERTY(copy) __LCDebuggerLogButtonDidTap didTapButton;

@end

@implementation __LCDebuggerLog

-(instancetype) init
{
    if (self = [super init]) {
        
        self.viewFrameWidth = LC_DEVICE_WIDTH;
        self.viewFrameHeight = LC_DEVICE_HEIGHT - 64;
        
        [self buildUI];
    }
    
    return self;
}

-(void) buildUI
{
    CGFloat inv = 10;
    NSArray * titles = @[@"System Info",@"Skeleton",@"Crash Report",@"Web Backstage"];
    CGFloat width = (self.viewFrameWidth - (inv * (titles.count + 1))) / titles.count;
    
    for (NSInteger i = 0; i< titles.count; i++) {
        
        UIButton * button = UIButton.view;
        button.viewFrameX = inv * (i + 1) + width * i;
        button.viewFrameWidth = width;
        button.viewFrameHeight = 30;
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius = 6.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.tag = i;
        
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.ADD(button);
    }
    
    self.logView = [[LCLogView alloc] initWithFrame:LC_RECT(0, 40, self.viewFrameWidth, self.viewFrameHeight - 40)];
    self.ADD(self.logView);
}

-(void) changedCurrentView:(UIView *)view title:(NSString *)title
{
    [self back];
    
    self.backView.alpha = 1;
    self.backView.text = title;
    
    view.viewFrameY = self.backView.viewBottomY;
    view.viewFrameWidth = self.viewFrameWidth;
    view.viewFrameHeight = self.viewFrameHeight - view.viewFrameY;
    
    view.alpha = 0;
    self.ADD(view);

    LC_FAST_ANIMATIONS_F(0.2, ^{
        
        view.alpha = 1;
        self.logView.alpha = 0;
        
    }, ^(BOOL finished){
        
        self.currentView = view;
    });
    
}

-(UIView *) backView
{
    if (!_backView) {
        
        _backView = UILabel.view;
        _backView.viewFrameY = 40;
        _backView.viewFrameWidth = LC_DEVICE_WIDTH;
        _backView.viewFrameHeight = 30;
        _backView.font = [UIFont systemFontOfSize:14];
        _backView.alpha = 0;
        _backView.textColor = [UIColor whiteColor];
        _backView.textAlignment = NSTextAlignmentCenter;
        _backView.userInteractionEnabled = YES;
        [_backView addTapTarget:self selector:@selector(back)];
        self.ADD(_backView);

        
        UILabel * backButton = UILabel.view;
        backButton.viewFrameX = 10;
        backButton.viewFrameWidth = 44;
        backButton.viewFrameHeight = 30;
        backButton.text = @"←";
        backButton.font = [UIFont systemFontOfSize:18];
        backButton.textColor = [UIColor whiteColor];
        _backView.ADD(backButton);
    }
    
    return _backView;
}

-(void) back
{
    [self.logView resignFirstResponder];
    
    LC_FAST_ANIMATIONS_F(0.15, ^{
       
        self.backView.alpha = 0;
        self.currentView.alpha = 0;
        self.logView.alpha = 1;
        
    }, ^(BOOL finished){
        
        if (self.currentView) {
            [self.currentView removeFromSuperview];
        }
    });
}

-(void) buttonAction:(UIButton *)button
{
    if (self.didTapButton) {
        self.didTapButton(button.tag);
    }
}

-(void) addLog:(NSString *)log
{
    [self.logView appendLogString:log];
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
    if (self = [super initWithFrame:CGRectMake(LC_DEVICE_WIDTH - 70, LC_DEVICE_HEIGHT - 70 - 50, 70, 70)]) {
        
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
    
    
    self.closeButton = UILabel.view;
    self.closeButton.viewFrameX = LC_DEVICE_WIDTH - 30;
    self.closeButton.viewFrameWidth = 64;
    self.closeButton.viewFrameHeight = 64;
    self.closeButton.text = @"✕";
    self.closeButton.font = [UIFont systemFontOfSize:18];
    self.closeButton.textColor = [UIColor whiteColor];
    self.closeButton.alpha = 0;
    self.ADD(self.closeButton);
    
    
    self.simplePreview = UILabel.view;
    self.simplePreview.viewFrameWidth = self.viewFrameWidth;
    self.simplePreview.viewFrameHeight = self.viewFrameHeight;
    self.simplePreview.font = [UIFont systemFontOfSize:10];
    self.simplePreview.textColor = [UIColor whiteColor];
    self.simplePreview.textAlignment = NSTextAlignmentCenter;
    self.simplePreview.numberOfLines = 0;
    self.simplePreview.tag = 1;
    self.ADD(self.simplePreview);
    
    
    self.mainView = __LCDebuggerLog.view;
    self.mainView.viewFrameY = 64;
    self.mainView.alpha = 0;
    self.ADD(self.mainView);
    
    @weakly(self);
    
    self.mainView.didTapButton = ^(NSInteger index){
        
        @normally(self);
        
        if (index == 0) {
            
            LCActionSheet * sheet = LCActionSheet.view;
            [sheet addTitle:@"Log"];
            [sheet addTitle:@"CPU"];
            [sheet addTitle:@"Device"];
            [sheet addTitle:@"Processes"];
            [sheet addTitle:@"Memory"];
            [sheet addTitle:@"Network"];
            [sheet addTitle:@"Disk"];

            sheet.dismissedBlock = ^(NSInteger index){
              
                if (index == 0) {
                    
                    [self.mainView back];
                }
                else if (index == 1){
                    
                    LCCPUTableView * tableView = [[LCCPUTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"CPU"];
                }
                else if (index == 2){
                    
                    LCDeviceTableView * tableView = [[LCDeviceTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"Device"];
                }
                else if (index == 3){
                    
                    LCProgressTableView * tableView = [[LCProgressTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"Processes"];
                }
                else if (index == 4){
                    
                    LCRAMTableView * tableView = [[LCRAMTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"Memory"];
                }
                else if (index == 5){
                    
                    LCNetworkTableView * tableView = [[LCNetworkTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"Network"];
                }
                else if (index == 6){
                    
                    LCStorageTableView * tableView = [[LCStorageTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
                    
                    [self.mainView changedCurrentView:tableView title:@"Disk"];
                }
            };
            
            [sheet show];
        }
        
        if (index == 1) {
            
            [self restore:^{
                
                LCViewInspector * vi = LCViewInspector.view;
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
        else if (index == 2){
            
            [LCCMD analysisCommand:@"see crashlog"];
        }
        else if (index == 3){
            
            LCWebBackstageTableView * tableView = [[LCWebBackstageTableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height - 40)];
            
            [self.mainView changedCurrentView:tableView title:@"Web backstage"];
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
    [LC_KEYWINDOW addSubview:self];
}

-(void) addLog:(NSString *)log;
{
    [self.mainView addLog:log];
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
    if (self.viewFrameWidth == LC_DEVICE_WIDTH) {
        
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
        
        self.simplePreview.viewFrameWidth = LC_DEVICE_WIDTH;
        self.simplePreview.viewFrameHeight = 64;
        self.simplePreview.tag = 2;

        self.mainView.alpha = 1;
        self.closeButton.alpha = 1;
    }];
}


-(void) restore:(void (^)(void))finishedBlock
{
    [self.mainView.logView resignFirstResponder];
    
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
        
        self.simplePreview.viewFrameWidth = self.viewFrameWidth;
        self.simplePreview.viewFrameHeight = self.viewFrameHeight;
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
