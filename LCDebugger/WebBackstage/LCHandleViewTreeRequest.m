//
//  LCHandleViewTreeRequest.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/20.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCHandleViewTreeRequest.h"
#import "UIView+Observer.h"
#import "NSObject+ViewTree.h"


@interface LCHandleViewTreeRequest ()

@property(nonatomic,assign) BOOL firstLoad;
@property(nonatomic,assign) double lastUpdate;

@end

@implementation LCHandleViewTreeRequest

-(instancetype) init
{
    if (self = [super init]) {
        
        
    }
    
    return self;
}

-(NSDictionary *) handleRequestPath:(NSString *)path
{
    NSString * param = [path componentsSeparatedByString:@"?"].lastObject;
    
    NSTimeInterval timeStamp = [[[param componentsSeparatedByString:@"="] lastObject] doubleValue];
    
    if ([UIView needsRefresh] == NO && self.lastUpdate <= timeStamp)
    {
        return @{
                   @"code":@(304)
                };
        
    }else{

        [UIView setNeedsRefresh:NO];
        
        timeStamp = [[NSDate date] timeIntervalSince1970];
        
        self.lastUpdate = timeStamp;
        
        return @{
                    @"code":        @(200),
                    @"lastUpdate":  [NSString stringWithFormat:@"%@",@(timeStamp)],
                    @"content":     [[UIApplication sharedApplication] toDict]
                 };
    }

    return nil;
}

@end
