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

@interface LCDevice()
// Overriden
@property (nonatomic, strong) LCDeviceInfo     *deviceInfo;
@property (nonatomic, strong) LCCPUInfo        *cpuInfo;
//@property (nonatomic, strong) GPUInfo        *gpuInfo;
@property (nonatomic, copy)   NSArray        *processes;
@property (nonatomic, strong) LCRAMInfo        *ramInfo;
@property (nonatomic, strong) LCNetworkInfo    *networkInfo;
//@property (nonatomic, strong) StorageInfo    *storageInfo;
//@property (nonatomic, strong) BatteryInfo    *batteryInfo;
@end

@implementation LCDevice
@synthesize deviceInfo;
@synthesize cpuInfo;
//@synthesize gpuInfo;
@synthesize processes;
@synthesize ramInfo;
@synthesize networkInfo;
//@synthesize storageInfo;
//@synthesize batteryInfo;

- (id)init
{
    if (self = [super init])
    {
        // Warning: since we rely a lot on hardcoded data, hw.machine must be retrieved
        // before everything else!
        NSString *hwMachine = [LCUtils getSysCtlChrWithSpecifier:"hw.machine"];
        LCHardcodedDeviceData *hardcodeData = [LCHardcodedDeviceData sharedDeviceData];
        [hardcodeData setHwMachine:hwMachine];
        
        deviceInfo = [LCDeviceInfoController.LCS getDeviceInfo];
        cpuInfo = [LCCPUInfoController.LCS getCPUInfo];
//        gpuInfo = [app.gpuInfoCtrl getGPUInfo];
        processes = [LCProcessInfoController.LCS getProcesses];
        ramInfo = [LCRAMInfoController.LCS getRAMInfo];
        networkInfo = [LCNetworkInfoController.LCS getNetworkInfo];
//        storageInfo = [app.storageInfoCtrl getStorageInfo];
//        batteryInfo = [app.batteryInfoCtrl getBatteryInfo];
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
//
//- (void)refreshStorageInfo
//{
//    AppDelegate *app = [AppDelegate sharedDelegate];
//    storageInfo = [app.storageInfoCtrl getStorageInfo];
//}

@end
