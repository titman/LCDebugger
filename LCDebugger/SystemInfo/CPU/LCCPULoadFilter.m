//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
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
