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
        
        [LCCMD addObjectCMD:@"cleanlog" CMDType:LC_CMD_TYPE_ACTION IMPObject:self CMDDescription:@"Clean all logs."];
        
        [self buildUI];
    }
    
    return self;
}

-(NSString *) CMDAction:(NSString *)cmd
{
    [LCGCD dispatchAsyncInMainQueue:^{
        
        self.logView.text = [NSString stringWithFormat:@"[Debugger Log]\n\n You can input 'see help' to see the all cmd.\n\n"];

    }];
    
    return nil;
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
