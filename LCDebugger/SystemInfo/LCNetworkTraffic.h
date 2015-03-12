//
//  BSNetworkTraffic.h
//  NetworkTrafficTracking
//
//  Created by Bogdan Stasjuk on 4/6/14.
//  Copyright (c) 2014 Bogdan Stasjuk. All rights reserved.
//

#import <Foundation/Foundation.h>

// Copy from BSNetworkTraffic ( https://github.com/Bogdan-Stasjuk/BSNetworkTraffic )
struct LCNetworkTrafficValues
{
    NSUInteger WiFiSent;
    NSUInteger WiFiReceived;
    NSUInteger WWANSent;
    NSUInteger WWANReceived;
    NSUInteger errorCnt;
};


@interface LCNetworkTraffic : NSObject

@property(nonatomic, assign, readonly) struct   LCNetworkTrafficValues  *changes;
@property(nonatomic, assign, readonly) struct   LCNetworkTrafficValues  *counters;

@property(nonatomic,assign, readonly) NSString * allTraffic;

+ (instancetype)sharedInstance;

- (void)calcChanges;
- (void)resetChanges;

@end
