//
//  LCActionSheet.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/13.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCActionSheet.h"
#import "LCDebuggerImport.h"

#define PANDDING 10
#define HEIGHT 40


@interface LCActionSheet ()

@property(nonatomic,strong) UIImageView * backgroundView;
@property(nonatomic,strong) UIView * contentView;
@property(nonatomic,strong) NSMutableArray * items;

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
    //CGFloat height = self.viewFrameHeight - PANDDING * 2;
    CGFloat beginY = self.viewMidHeight - (HEIGHT * self.items.count + PANDDING * (self.items.count + 1))/2 ; // height - HEIGHT * self.items.count - PANDDING * self.items.count;
    
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
