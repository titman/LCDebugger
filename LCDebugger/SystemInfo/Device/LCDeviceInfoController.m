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
    return (NSInteger)[LCUtils getSysCtl64WithSpecifier:"kern.osrevision"];
}

- (NSString*)getKernelInfo
{
    return [LCUtils getSysCtlChrWithSpecifier:"kern.version"];
}

- (NSUInteger)getMaxVNodes
{
    return (NSUInteger)[LCUtils getSysCtl64WithSpecifier:"kern.maxvnodes"];
}

- (NSUInteger)getMaxProcesses
{
    return (NSUInteger)[LCUtils getSysCtl64WithSpecifier:"kern.maxproc"];
}

- (NSUInteger)getMaxFiles
{
    return (NSUInteger)[LCUtils getSysCtl64WithSpecifier:"kern.maxfiles"];
}

- (NSUInteger)getTickFrequency
{
    struct clockinfo clockInfo;
    
    [LCUtils getSysCtlPtrWithSpecifier:"kern.clockrate" pointer:&clockInfo size:sizeof(struct clockinfo)];
    return clockInfo.hz;
}

- (NSUInteger)getNumberOfGroups
{
    return (NSUInteger)[LCUtils getSysCtl64WithSpecifier:"kern.ngroups"];
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
