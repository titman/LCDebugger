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

#import "LCCMDInput.h"
#import "LCCMD.h"

@interface LCCMDInput ()<UITextFieldDelegate>
{
    UITextField * textField;
}

@end

@implementation LCCMDInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 6.0f;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        self.layer.borderWidth = 2.0f;
        
        textField = [[UITextField alloc] initWithFrame:LC_RECT_CREATE(4, 0, self.viewFrameWidth - 8, self.viewFrameHeight)];
        textField.backgroundColor = [UIColor clearColor];
        textField.textColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        textField.font = [UIFont systemFontOfSize:14];
        textField.returnKeyType = UIReturnKeySend;
        textField.delegate = self;
        textField.textAlignment = UITextAlignmentLeft;
        textField.placeholder = @"Input cmd. ( You can input 'see help' to see the all cmd. )";
        self.ADD(textField);
    }
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length <= 0) {
        return YES;
    }
    
    [LCCMD analysisCommand:[textField.text lowercaseString]];
    
    return YES;
}

-(BOOL) resignFirstResponder
{
    [textField resignFirstResponder];
    
    return [super resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
