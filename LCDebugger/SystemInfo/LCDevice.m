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
