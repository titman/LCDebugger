//
//  CPULoadFilter.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import "LCCPULoad.h"
#import "LCCPULoadFilter.h"

@interface LCCPULoadFilter()
@property (nonatomic, strong) NSMutableArray *rawCpuLoadHistory;

- (void)appendRawCpuLoad:(LCCPULoad*)cpuLoad;
@end

@implementation LCCPULoadFilter
@synthesize rawCpuLoadHistory;

static const NSUInteger kCpuLoadHistoryMax = 0;

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.rawCpuLoadHistory = [@[] mutableCopy];
    }
    return self;
}

#pragma mark - public

- (LCCPULoad*)filterLoad:(LCCPULoad*)cpuLoad
{
    NSUInteger i;
    float avgSystem = 0;
    float avgUser = 0;
    float avgNice = 0;
    float avgSystemWithoutNice = 0;
    float avgUserWithoutNice = 0;
    
    [self.rawCpuLoadHistory addObject:cpuLoad];
    
    for (i = 0; i < self.rawCpuLoadHistory.count; ++i)
    {
        LCCPULoad *load = self.rawCpuLoadHistory[i];
        avgSystem += load.system;
        avgUser += load.user;
        avgNice += load.nice;
        avgSystemWithoutNice += load.systemWithoutNice;
        avgUserWithoutNice += load.userWithoutNice;
    }
    
    LCCPULoad *result = [[LCCPULoad alloc] init];
    result.system = avgSystem / i;
    result.user = avgUser / i;
    result.nice = avgNice / i;
    result.systemWithoutNice = avgSystemWithoutNice / i;
    result.userWithoutNice = avgUserWithoutNice / i;
    result.total = result.system + result.user + result.nice;
    
    return result;
}

#pragma mark - private

- (void)appendRawCpuLoad:(LCCPULoad*)cpuLoad
{
    [self.rawCpuLoadHistory insertObject:cpuLoad atIndex:0];
    
    while (self.rawCpuLoadHistory.count > kCpuLoadHistoryMax)
    {
        [self.rawCpuLoadHistory removeLastObject];
    }
}

@end
