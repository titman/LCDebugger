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

#import <mach/mach.h>
#import <mach/mach_host.h>
#import "LCLog.h"
#import "LCUtils.h"
#import "LCDevice.h"
#import "LCHardcodedDeviceData.h"
#import "LCRAMUsage.h"
#import "LCRAMInfoController.h"

@interface LCRAMInfoController()
@property (nonatomic, strong) LCRAMInfo           *ramInfo;

@property (nonatomic, assign) NSUInteger        ramUsageHistorySize;
- (void)pushRAMUsage:(LCRAMUsage*)ramUsage;

@property (nonatomic, strong) NSTimer           *ramUsageTimer;
- (void)ramUsageTimerCB:(NSNotification*)notification;

- (NSUInteger)getRAMTotal;
- (NSString*)getRAMType;
- (LCRAMUsage*)getRAMUsage;
@end

@implementation LCRAMInfoController
@synthesize delegate;
@synthesize ramUsageHistory;

@synthesize ramInfo;
@synthesize ramUsageHistorySize;
@synthesize ramUsageTimer;

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.ramInfo = [[LCRAMInfo alloc] init];
        self.ramUsageHistory = [@[] mutableCopy];
        self.ramUsageHistorySize = kDefaultDataHistorySize;
    }
    return self;
}

#pragma mark - public

- (LCRAMInfo*)getRAMInfo
{    
    self.ramInfo.totalRam = [self getRAMTotal];
    self.ramInfo.ramType = [self getRAMType];

    return ramInfo;
}

- (void)startRAMUsageUpdatesWithFrequency:(NSUInteger)frequency
{
    [self stopRAMUsageUpdates];
    self.ramUsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / frequency
                                                          target:self
                                                        selector:@selector(ramUsageTimerCB:)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.ramUsageTimer forMode:NSRunLoopCommonModes];
    [self.ramUsageTimer fire];
}

- (void)stopRAMUsageUpdates
{
    [self.ramUsageTimer invalidate];
    self.ramUsageTimer = nil;
}

- (void)setRAMUsageHistorySize:(NSUInteger)size
{
    self.ramUsageHistorySize = size;
}

#pragma mark - private

- (void)ramUsageTimerCB:(NSNotification*)notification
{
    LCRAMUsage *usage = [self getRAMUsage];
    [self pushRAMUsage:usage];
    [self.delegate ramUsageUpdated:usage];
}

- (void)pushRAMUsage:(LCRAMUsage*)ramUsage
{
    [self.ramUsageHistory addObject:ramUsage];
    
    while (self.ramUsageHistory.count > self.ramUsageHistorySize)
    {
        [self.ramUsageHistory removeObjectAtIndex:0];
    }
}

- (NSUInteger)getRAMTotal
{
    return (NSUInteger)[NSProcessInfo processInfo].physicalMemory;
}

- (NSString*)getRAMType
{
    LCHardcodedDeviceData *hardcodedData = [LCHardcodedDeviceData sharedDeviceData];
    return (NSString*) [hardcodedData getRAMType];
}

- (LCRAMUsage*)getRAMUsage
{
    mach_port_t             host_port = mach_host_self();
    mach_msg_type_number_t  host_size = HOST_VM_INFO64_COUNT;
    vm_size_t               pageSize;
    vm_statistics64_data_t  vm_stat;
    
//    if (host_page_size(host_port, &pageSize) != KERN_SUCCESS)
//    {
//        AMLogWarn(@"host_page_size() has failed - defaulting to 4K");
//        pageSize = 4096;
//    }
    // There is a crazy bug(?) on iPhone 5S causing host_page_size give 16384, but host_statistics64 provide statistics
    // relative to 4096 page size. For the moment it is relatively safe to hardcode 4096 here, but in the upcomming updates
    // it can misbehaves very badly.
    pageSize = 4096;
    
    if (host_statistics64(host_port, HOST_VM_INFO64, (host_info64_t)&vm_stat, &host_size) != KERN_SUCCESS)
    {
        ERROR(@"host_statistics() has failed.");
        return nil;
    }
    
    LCRAMUsage *usage = [[LCRAMUsage alloc] init];
    usage.usedRam = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pageSize;
    usage.activeRam = vm_stat.active_count * pageSize;
    usage.inactiveRam = vm_stat.inactive_count * pageSize;
    usage.wiredRam = vm_stat.wire_count * pageSize;
    usage.freeRam = self.ramInfo.totalRam - usage.usedRam;
    usage.pageIns = vm_stat.pageins;
    usage.pageOuts = vm_stat.pageouts;
    usage.pageFaults = vm_stat.faults;
    return usage;
}

@end
