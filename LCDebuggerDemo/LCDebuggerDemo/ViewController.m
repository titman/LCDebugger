//
//  ViewController.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/10.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "ViewController.h"
#import "LCDebugger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:0];
}

static LCDebugger * touch = nil;

-(void) test
{
    if (!touch) {
        touch = [[LCDebugger alloc] init];
    }

}

@end
