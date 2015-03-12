//
//  LCSystemInfo.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LCSystemInfo : NSObject

+ (CGFloat) cpuUsed;
+ (NSString *) freeDiskSpace;

+ (uint64_t)getSysCtl64WithSpecifier:(char*)specifier;

@end
