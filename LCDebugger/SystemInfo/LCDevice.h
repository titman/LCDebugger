//
//  AMDevice.h
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <Foundation/Foundation.h>
#import "LCDeviceInfo.h"
#import "LCCPUInfo.h"
#import "LCRAMInfo.h"
#import "LCNetworkInfo.h"
#import "LCStorageInfo.h"

#define kDefaultDataHistorySize     300

#define kCpuLoadUpdateFrequency     2
#define kRamUsageUpdateFrequency    1
#define kNetworkUpdateFrequency     1

@interface LCDevice : NSObject
@property (nonatomic, strong, readonly) LCDeviceInfo     *deviceInfo;
@property (nonatomic, strong, readonly) LCCPUInfo        *cpuInfo;
@property (nonatomic, copy, readonly)   NSArray        *processes;
@property (nonatomic, strong, readonly) LCRAMInfo        *ramInfo;
@property (nonatomic, strong, readonly) LCNetworkInfo    *networkInfo;
@property (nonatomic, strong, readonly) LCStorageInfo    *storageInfo;

- (void)refreshProcesses;
- (void)refreshStorageInfo;

@end
