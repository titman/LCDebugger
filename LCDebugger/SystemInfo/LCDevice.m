//
//  AMDevice.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//


#import "LCDebuggerImport.h"
#import "LCUtils.h"
#import "LCHardcodedDeviceData.h"
#import "LCDeviceInfoController.h"
#import "LCCPUInfoController.h"
#import "LCDeviceInfo.h"
#import "LCCPUInfo.h"
#import "LCProcessInfoController.h"
#import "LCDevice.h"
#import "LCRAMInfoController.h"
#import "LCNetworkInfoController.h"
#import "LCStorageInfoController.h"

@interface LCDevice()
// Overriden
@property (nonatomic, strong) LCDeviceInfo     *deviceInfo;
@property (nonatomic, strong) LCCPUInfo        *cpuInfo;
@property (nonatomic, copy)   NSArray        *processes;
@property (nonatomic, strong) LCRAMInfo        *ramInfo;
@property (nonatomic, strong) LCNetworkInfo    *networkInfo;
@property (nonatomic, strong) LCStorageInfo    *storageInfo;

@end

@implementation LCDevice

@synthesize deviceInfo;
@synthesize cpuInfo;
@synthesize processes;
@synthesize ramInfo;
@synthesize networkInfo;
@synthesize storageInfo;

- (id)init
{
    if (self = [super init])
    {
        NSString *hwMachine = [LCUtils getSysCtlChrWithSpecifier:"hw.machine"];
        
        LCHardcodedDeviceData *hardcodeData = [LCHardcodedDeviceData sharedDeviceData];
        [hardcodeData setHwMachine:hwMachine];
        
        deviceInfo = [LCDeviceInfoController.LCS getDeviceInfo];
        cpuInfo = [LCCPUInfoController.LCS getCPUInfo];
        processes = [LCProcessInfoController.LCS getProcesses];
        ramInfo = [LCRAMInfoController.LCS getRAMInfo];
        networkInfo = [LCNetworkInfoController.LCS getNetworkInfo];
        storageInfo = [LCStorageInfoController.LCS getStorageInfo];
    }
    return self;
}

- (LCDeviceInfo*)getDeviceInfo
{
    return deviceInfo;
}

- (LCCPUInfo*)getCpuInfo
{
    return cpuInfo;
}

- (NSArray*)getProcesses
{
    return processes;
}

#pragma mark - public

- (void)refreshProcesses
{
    processes = [LCProcessInfoController.LCS getProcesses];
}

- (void)refreshStorageInfo
{
    storageInfo = [LCStorageInfoController.LCS getStorageInfo];
}

@end
