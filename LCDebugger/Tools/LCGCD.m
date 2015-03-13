//  LC_GCD.m
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-17.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LCGCD.h"

@implementation LCGCD

+(void) dispatchAsync:(LC_GCD_PRIORITY)priority block:(LCGCDBlock)block
{
    dispatch_async(dispatch_get_global_queue(priority, 0), block);
}

+(void) dispatchAsyncInMainQueue:(LCGCDBlock)block
{
    if(![NSThread isMainThread]){
        
        dispatch_async(dispatch_get_main_queue(),block);
    }
    else{
        
        block();
    }
}

@end
