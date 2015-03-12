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


#import "LCUtils.h"
#import "LCHardcodedDeviceData.h"
#import "LCDeviceInfoController.h"
#import "LCCPUInfoController.h"
#import "LCDeviceInfo.h"
#import "LCCPUInfo.h"
//#import "GPUInfo.h"
#import "LCDevice.h"

@interface LCDevice()
// Overriden
@property (nonatomic, strong) LCDeviceInfo     *deviceInfo;
@property (nonatomic, strong) LCCPUInfo        *cpuInfo;
//@property (nonatomic, strong) GPUInfo        *gpuInfo;
//@property (nonatomic, copy)   NSArray        *processes;
//@property (nonatomic, strong) RAMInfo        *ramInfo;
//@property (nonatomic, strong) NetworkInfo    *networkInfo;
//@property (nonatomic, strong) StorageInfo    *storageInfo;
//@property (nonatomic, strong) BatteryInfo    *batteryInfo;
@end

@implementation LCDevice
@synthesize deviceInfo;
@synthesize cpuInfo;
//@synthesize gpuInfo;
//@synthesize processes;
//@synthesize ramInfo;
//@synthesize networkInfo;
//@synthesize storageInfo;
//@synthesize batteryInfo;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self class] new];
    });
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        // Warning: since we rely a lot on hardcoded data, hw.machine must be retrieved
        // before everything else!
        NSString *hwMachine = [LCUtils getSysCtlChrWithSpecifier:"hw.machine"];
        LCHardcodedDeviceData *hardcodeData = [LCHardcodedDeviceData sharedDeviceData];
        [hardcodeData setHwMachine:hwMachine];
        
//        AppDelegate *app = [AppDelegate sharedDelegate];
        deviceInfo = [[LCDeviceInfoController sharedInstance] getDeviceInfo];
        cpuInfo = [[LCCPUInfoController sharedInstance] getCPUInfo];
//        gpuInfo = [app.gpuInfoCtrl getGPUInfo];
//        processes = [app.processInfoCtrl getProcesses];
//        ramInfo = [app.ramInfoCtrl getRAMInfo];
//        networkInfo = [app.networkInfoCtrl getNetworkInfo];
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

//- (NSArray*)getProcesses
//{
//    return processes;
//}

#pragma mark - public

//- (void)refreshProcesses
//{
//    AppDelegate *app = [AppDelegate sharedDelegate];
//    processes = [app.processInfoCtrl getProcesses];
//}
//
//- (void)refreshStorageInfo
//{
//    AppDelegate *app = [AppDelegate sharedDelegate];
//    storageInfo = [app.storageInfoCtrl getStorageInfo];
//}

@end
