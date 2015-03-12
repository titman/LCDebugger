//
//  DeviceInfoController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import <sys/sysctl.h>
#import "LCUtils.h"
#import "LCHardcodedDeviceData.h"
#import "LCDeviceInfoController.h"
#import <UIKit/UIKit.h>

@interface LCDeviceInfoController()
@property (nonatomic, strong) LCDeviceInfo    *deviceInfo;

- (const NSString*)getDeviceName;
- (NSString*)getHostName;
- (NSString*)getOSType;
- (NSString*)getOSVersion;
- (NSString*)getOSBuild;
- (NSInteger)getOSRevision;
- (NSString*)getKernelInfo;
- (NSUInteger)getMaxVNodes;
- (NSUInteger)getMaxProcesses;
- (NSUInteger)getMaxFiles;
- (NSUInteger)getTickFrequency;
- (NSUInteger)getNumberOfGroups;
- (time_t)getBootTime;
- (BOOL)getSafeBoot;

- (NSString*)getScreenResolution;
- (CGFloat)getScreenSize;
- (BOOL)isRetina;
- (NSUInteger)getPPI;
- (NSString*)getAspectRatio;
@end

@implementation LCDeviceInfoController

@synthesize deviceInfo;

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self class] new];
    });
    return sharedInstance;
}

#pragma mark - override

- (id)init
{
    if (self = [super init])
    {
        self.deviceInfo = [[LCDeviceInfo alloc] init];
    }
    return self;
}

#pragma mark - public

- (LCDeviceInfo*)getDeviceInfo
{
    self.deviceInfo.deviceName = [self getDeviceName];
    self.deviceInfo.hostName = [self getHostName];
    self.deviceInfo.osName = @"iOS";
    self.deviceInfo.osType = [self getOSType];
    self.deviceInfo.osVersion = [self getOSVersion];
    self.deviceInfo.osBuild = [self getOSBuild];
    self.deviceInfo.osRevision = [self getOSRevision];
    self.deviceInfo.kernelInfo = [self getKernelInfo];
    self.deviceInfo.maxVNodes = [self getMaxVNodes];
    self.deviceInfo.maxProcesses = [self getMaxProcesses];
    self.deviceInfo.maxFiles = [self getMaxFiles];
    self.deviceInfo.tickFrequency = [self getTickFrequency];
    self.deviceInfo.numberOfGroups = [self getNumberOfGroups];
    self.deviceInfo.bootTime = [self getBootTime];
    self.deviceInfo.safeBoot = [self getSafeBoot];
    self.deviceInfo.screenResolution = [self getScreenResolution];
    self.deviceInfo.screenSize = [self getScreenSize];
    self.deviceInfo.retina = [self isRetina];
    self.deviceInfo.retinaHD = [self isRetinaHD];
    self.deviceInfo.ppi = [self getPPI];
    self.deviceInfo.aspectRatio = [self getAspectRatio];
    
    return self.deviceInfo;
}

#pragma mark - private

- (const NSString*)getDeviceName
{
    LCHardcodedDeviceData *hardcodeData = [LCHardcodedDeviceData sharedDeviceData];
    return [hardcodeData getiDeviceName];
}

- (NSString*)getHostName
{
    return [LCUtils getSysCtlChrWithSpecifier:"kern.hostname"];
}

- (NSString*)getOSType
{
    return [LCUtils getSysCtlChrWithSpecifier:"kern.ostype"];
}

- (NSString*)getOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

- (NSString*)getOSBuild
{
    return [LCUtils getSysCtlChrWithSpecifier:"kern.osversion"];
}

- (NSInteger)getOSRevision
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.osrevision"];
}

- (NSString*)getKernelInfo
{
    return [LCUtils getSysCtlChrWithSpecifier:"kern.version"];
}

- (NSUInteger)getMaxVNodes
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.maxvnodes"];
}

- (NSUInteger)getMaxProcesses
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.maxproc"];
}

- (NSUInteger)getMaxFiles
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.maxfiles"];
}

- (NSUInteger)getTickFrequency
{
    struct clockinfo clockInfo;
    
    [LCUtils getSysCtlPtrWithSpecifier:"kern.clockrate" pointer:&clockInfo size:sizeof(struct clockinfo)];
    return clockInfo.hz;
}

- (NSUInteger)getNumberOfGroups
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.ngroups"];
}

- (time_t)getBootTime
{
    struct timeval bootTime;
    
    [LCUtils getSysCtlPtrWithSpecifier:"kern.boottime" pointer:&bootTime size:sizeof(struct timeval)];
    return bootTime.tv_sec;
}

- (BOOL)getSafeBoot
{
    return [LCUtils getSysCtl64WithSpecifier:"kern.safeboot"] > 0;
}

- (NSString*)getScreenResolution
{
    CGRect dimension = [UIScreen mainScreen].bounds;                    // Dimensions are flipped over.
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *resolution = [NSString stringWithFormat:@"%0.0fx%0.0f", dimension.size.height * scale, dimension.size.width * scale];
    return resolution;
}

- (CGFloat)getScreenSize
{
    LCHardcodedDeviceData *hardcode = [LCHardcodedDeviceData sharedDeviceData];
    return [hardcode getScreenSize];
}

- (BOOL)isRetina
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0));
}

- (BOOL)isRetinaHD
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            [UIScreen mainScreen].scale == 3.0);
}

- (NSUInteger)getPPI
{
    LCHardcodedDeviceData *hardcode = [LCHardcodedDeviceData sharedDeviceData];
    return [hardcode getPPI];
}

- (NSString*)getAspectRatio
{
    LCHardcodedDeviceData *hardcode = [LCHardcodedDeviceData sharedDeviceData];
    return [hardcode getAspectRatio];
}

@end
