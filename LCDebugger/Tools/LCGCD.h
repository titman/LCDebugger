//  LC_GCD.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-17.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <Foundation/Foundation.h>

typedef enum _LC_GCD_PRIORITY{
    
    LC_GCD_PRIORITY_HIGH = DISPATCH_QUEUE_PRIORITY_HIGH,
    LC_GCD_PRIORITY_DEFAULT = DISPATCH_QUEUE_PRIORITY_DEFAULT,
    LC_GCD_PRIORITY_LOW = DISPATCH_QUEUE_PRIORITY_LOW,
    LC_GCD_PRIORITY_BACKGROUND = DISPATCH_QUEUE_PRIORITY_BACKGROUND,
    
}LC_GCD_PRIORITY;

typedef void (^LCGCDBlock)();

@interface LCGCD : NSObject

+(void) dispatchAsync:(LC_GCD_PRIORITY)priority block:(LCGCDBlock)block;

+(void) dispatchAsyncInMainQueue:(LCGCDBlock)block;

@end
