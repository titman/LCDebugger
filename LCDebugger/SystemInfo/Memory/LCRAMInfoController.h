//
//  RAMInfoController.h
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <Foundation/Foundation.h>
#import "LCRAMInfo.h"
#import "LCRAMUsage.h"

@protocol LCRAMInfoControllerDelegate
- (void)ramUsageUpdated:(LCRAMUsage*)usage;
@end

@interface LCRAMInfoController : NSObject
@property (nonatomic, weak) id<LCRAMInfoControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray              *ramUsageHistory;

- (LCRAMInfo*)getRAMInfo;
- (void)startRAMUsageUpdatesWithFrequency:(NSUInteger)frequency;
- (void)stopRAMUsageUpdates;
- (void)setRAMUsageHistorySize:(NSUInteger)size;
@end
