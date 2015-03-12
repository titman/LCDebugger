//
//  LCDebugger.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCDebugger.h"

@implementation LCDebugger


+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self class] new];
    });
    return sharedInstance;
}



-(instancetype) init
{
    if (self = [super init]) {
        
        self.debuggerView = [[LCDebuggerView alloc] init];
    }
    
    return self;
}

@end
