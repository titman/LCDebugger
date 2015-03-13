//
//  CPUInfoController.h
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <Foundation/Foundation.h>
#import "LCCPULoad.h"
#import "LCCPUInfo.h"

@protocol LCCPUInfoControllerDelegate
- (void)cpuLoadUpdated:(NSArray*)loadArray;
@end

@interface LCCPUInfoController : NSObject
@property (nonatomic, weak) id<LCCPUInfoControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *cpuLoadHistory;


- (LCCPUInfo*)getCPUInfo;
- (void)startCPULoadUpdatesWithFrequency:(NSUInteger)frequency;
- (void)stopCPULoadUpdates;
- (void)setCPULoadHistorySize:(NSUInteger)size;
@end
