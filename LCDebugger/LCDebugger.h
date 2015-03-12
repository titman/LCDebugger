//
//  LCDebugger.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCDebuggerView.h"

@interface LCDebugger : NSObject

@property(nonatomic,strong) LCDebuggerView * debuggerView;

+ (instancetype)sharedInstance;

@end
