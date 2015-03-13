//
//  LC_CMDInput.m
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
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
