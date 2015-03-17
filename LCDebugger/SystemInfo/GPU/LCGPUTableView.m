//
//  LCGPUTableView.m
//  LCDebuggerDemo
//
//  Created by Leer on 15/3/15.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCGPUTableView.h"

@interface LCGPUTableView ()

@property(nonatomic, strong) NSMutableArray * titles;
@property(nonatomic, strong) NSMutableArray * values;

@end


@implementation LCGPUTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

@end
