//
//  NetworkInfoController.h
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <Foundation/Foundation.h>
#import "LCNetworkBandwidth.h"
#import "LCNetworkInfo.h"

@protocol LCNetworkInfoControllerDelegate <NSObject>
@optional
- (void)networkBandwidthUpdated:(LCNetworkBandwidth*)bandwidth;
- (void)networkStatusUpdated;
- (void)networkExternalIPAddressUpdated;
- (void)networkMaxBandwidthUpdated;
- (void)networkActiveConnectionsUpdated:(NSArray*)connections;
@end

@interface LCNetworkInfoController : NSObject
@property (nonatomic, weak) id<LCNetworkInfoControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray    *networkBandwidthHistory;

@property (nonatomic, assign) CGFloat       currentMaxSentBandwidth;
@property (nonatomic, assign) CGFloat       currentMaxReceivedBandwidth;

- (LCNetworkInfo*)getNetworkInfo;

- (void)startNetworkBandwidthUpdatesWithFrequency:(NSUInteger)frequency;
- (void)stopNetworkBandwidthUpdates;
- (void)setNetworkBandwidthHistorySize:(NSUInteger)size;

- (void)updateActiveConnections;
@end
