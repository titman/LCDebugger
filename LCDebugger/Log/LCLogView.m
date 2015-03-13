//
//  LCLogView.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/13.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCLogView.h"
#import "LCDebuggerImport.h"
#import "LCCMDInput.h"
#import "LCUIKeyBoard.h"

#define MAX_LOG_LENGTH 50000

@interface LCLogView ()

@property(nonatomic,strong) UITextView * logView;
@property(nonatomic,strong) LCCMDInput * inputView;
@property(nonatomic,strong) LCUIKeyBoard * keyboard;

@end

@implementation LCLogView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
    }
    
    return self;
}

-(BOOL) resignFirstResponder
{
    [self.logView resignFirstResponder];
    [self.inputView resignFirstResponder];
    
    return [super resignFirstResponder];
}

-(void) buildUI
{
    self.logView = UITextView.view;
    self.logView.viewFrameX = 10;
    self.logView.viewFrameY = 10;
    self.logView.viewFrameWidth = self.viewFrameWidth - 20;
    self.logView.viewFrameHeight = self.viewFrameHeight - 20 - 40;
    self.logView.editable = NO;
    self.logView.font = [UIFont systemFontOfSize:14];
    self.logView.textColor = [UIColor whiteColor];
    self.logView.backgroundColor = [UIColor clearColor];
    self.logView.text = [NSString stringWithFormat:@"[Debugger Log]\n\n You can input 'see help' to see the all cmd.\n\n"];
    self.ADD(self.logView);
    
    
    self.inputView = [[LCCMDInput alloc] initWithFrame:LC_RECT(10, self.logView.viewBottomY, self.logView.viewFrameWidth, 40)];
    self.ADD(self.inputView);
    
    
    self.keyboard = [[LCUIKeyBoard alloc] init];
    [self.keyboard setAccessor:self.inputView];
}

-(void) appendLogString:(NSString *)logString
{
    if (!self.superview) {
        return;
    }
    
    [LCGCD dispatchAsyncInMainQueue:^{
        
        NSString * newLogString = [self.logView.text stringByAppendingString:LC_NSSTRING_FORMAT(@"%@\n",logString)];
        
        if (newLogString.length > MAX_LOG_LENGTH) {
            
            newLogString = [newLogString substringWithRange:NSMakeRange(newLogString.length - MAX_LOG_LENGTH, MAX_LOG_LENGTH)];
        }
        
        self.logView.text = newLogString;
        
        LC_FAST_ANIMATIONS(1, ^{
            
            NSRange txtOutputRange;
            
            txtOutputRange.location = _logView.text.length;
            txtOutputRange.length = 0;
            
            self.logView.editable = YES;
            
            [self.logView scrollRangeToVisible:txtOutputRange];
            [self.logView setSelectedRange:txtOutputRange];
            
            self.logView.editable = NO;            
        });
        
    }];
    
}

@end
