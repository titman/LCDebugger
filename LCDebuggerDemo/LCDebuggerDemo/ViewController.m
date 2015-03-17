//
//  ViewController.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/10.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "ViewController.h"
#import "LCDebugger.h"
#import "LCWebServer.h"
#import "LCDebuggerImport.h"
#import "UIDevice+Reachability.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector:@selector(test) withObject:nil afterDelay:0];
    
    [LCWebServer.LCS start];
    
    NSString * address = [NSString stringWithFormat:@"http://%@:12352", [UIDevice localIPAddress]];
    
    INFO(@"Web address : %@", address);
}

static LCDebugger * touch = nil;

-(void) test
{
    if (!touch) {
        touch = [LCDebugger sharedInstance];
    }
}

@end
