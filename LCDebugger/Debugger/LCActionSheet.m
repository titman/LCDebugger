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

#import "LCActionSheet.h"
#import "LCDebuggerImport.h"

#define PANDDING 10
#define HEIGHT 40


@interface LCActionSheet ()

LC_PROPERTY(strong) UIImageView * backgroundView;
LC_PROPERTY(strong) UIView * contentView;
LC_PROPERTY(strong) NSMutableArray * items;

@end

@implementation LCActionSheet


-(instancetype) init
{
    if (self = [super initWithFrame:LC_RECT(0, 0, LC_DEVICE_WIDTH, LC_DEVICE_HEIGHT + 20)]) {
        
        self.items = NSMutableArray.array;
        
        
        self.backgroundView = UIImageView.view;
        self.backgroundView.frame = self.bounds;
        self.backgroundView.userInteractionEnabled = YES;
        self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.ADD(_backgroundView);
        
        
        self.contentView = UIView.view;
        self.contentView.frame = self.bounds;
        [self.contentView addTapTarget:self selector:@selector(cancel)];
        self.ADD(_contentView);
    }
    
    return self;
}


-(void) addTitle:(NSString *)title
{
    if (!self.titles) {
        self.titles = [NSMutableArray array];
    }
    
    [self.titles addObject:title];
    
    UIButton * button = UIButton.view;
    button.viewFrameWidth = self.viewFrameWidth - PANDDING * 2;
    button.viewFrameHeight = HEIGHT;
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 6;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = self.items.count;
    [button addTarget:self action:@selector(itemTap:) forControlEvents:UIControlEventTouchUpInside];
    self.contentView.ADD(button);
    
    [self.items addObject:button];
    
    [self layout];
}

-(void) layout
{
    CGFloat beginY = self.viewMidHeight - (HEIGHT * self.items.count + PANDDING * (self.items.count + 1)) / 2 ;
    
    LC_FOR(i, self.items.count, {
        
        UIButton * button = self.items[i];
        
        button.viewFrameX = PANDDING;
        button.viewFrameY = beginY + PANDDING * i + HEIGHT * i;
    })
}

#pragma mark -

-(void) show
{
    self.backgroundView.alpha = 0;
    self.contentView.alpha = 0;
    
    LC_KEYWINDOW.ADD(self);
    
    LC_FAST_ANIMATIONS(0.3, ^{
        
        self.backgroundView.alpha = 1;
        self.contentView.alpha = 1;
    });
}

-(void) hide
{
    LC_FAST_ANIMATIONS_F(0.3, ^{
        
        self.contentView.alpha = 0;
        self.backgroundView.alpha = 0;
        
    }, ^(BOOL finished){
        
        [self removeFromSuperview];
    });
}

-(void) cancel
{
    [self hide];
    
    if (self.dismissedBlock) {
        self.dismissedBlock(self.items.count);
    }
}

-(void) itemTap:(UIButton *)button
{
    [self hide];
    
    if (self.dismissedBlock) {
        self.dismissedBlock(button.tag);
    }
}


@end
