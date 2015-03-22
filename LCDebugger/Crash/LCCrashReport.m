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

#import "LCCrashReport.h"
#import "LCLog.h"
#import "LCCMD.h"

@interface LCCrashReport () <LC_CMD_IMP>

@end

@implementation LCCrashReport

+(void) load
{
    // Default cmd.
    [LCCMD addClassCMD:@"crashreport" CMDType:LC_CMD_TYPE_SEE IMPClass:[LCCrashReport class] CMDDescription:@"To see the all of crash logs."];
    [LCCMD addClassCMD:@"lastcrash" CMDType:LC_CMD_TYPE_SEE IMPClass:[LCCrashReport class] CMDDescription:@"To see the nearest of crash logs."];
    
    NSSetUncaughtExceptionHandler(&LCCrashReportHandler);
}

+ (BOOL)touchPath:(NSString *)path
{
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}
     
+(NSString *) folderPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/LCCrashReport"];
}

+(NSArray *) crashLogs
{
    NSArray * contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[LCCrashReport folderPath] error:NULL];
    
    NSMutableArray * crashLogs = [NSMutableArray array];
    
    for (NSString * fileName in contents) {
        
        [crashLogs addObject:[NSDictionary dictionaryWithContentsOfFile:[[self folderPath] stringByAppendingFormat:@"/%@",fileName]]];
    }
    
    NSArray * result = [crashLogs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        return [[obj1 objectForKey:@"Time"] doubleValue] > [[obj2 objectForKey:@"Time"] doubleValue];
        
    }];
    
    return result;
}

+(NSString *) CMDSee:(NSString *)cmd
{
    NSArray * crashLogs = self.crashLogs;
    
    if (!crashLogs) {
        
        return @"Don't have any crash.";
    }
    
    if ([cmd isEqualToString:@"crashreport"]) {
        
        NSMutableString * info = [NSMutableString stringWithFormat:@"\n  * Count : %@\n", @(crashLogs.count)];
        
        for (NSDictionary * crash in crashLogs) {
            
            [info appendFormat:@"   * Reason : %@ Time : %@\n\n", crash[@"Reason"], [NSDate dateWithTimeIntervalSince1970:[crash[@"Time"] doubleValue]]];
        }
        
        return info;
    }
    else if ([cmd isEqualToString:@"lastcrash"]){
        
        return [NSString stringWithFormat:@"   * Reason : %@ Time : %@\n\n", crashLogs.lastObject[@"Reason"], [NSDate dateWithTimeIntervalSince1970:[crashLogs.lastObject[@"Time"] doubleValue]]];
    }
    
    return @"";
}

+(NSString *) CMDAction:(NSString *)cmd
{
    return nil;
}

@end

void LCCrashReportHandler(NSException * exception)
{
    INFO(@"Exception has been intercepted by LCCrashReport. You can input 'see lastcrash' to see the crash detail.");
    
    [LCCrashReport touchPath:[LCCrashReport folderPath]];
    
    NSString * exc = [NSString stringWithFormat:@"%@",exception];
    NSString * css = [NSString stringWithFormat:@"%@",[exception callStackSymbols]];
    
    NSMutableDictionary * crash = [NSMutableDictionary dictionary];
    
    [crash setObject:exc forKey:@"Reason"];
    [crash setObject:css forKey:@"CallStackSymbols"];
    [crash setObject:@([[NSDate date] timeIntervalSince1970]) forKey:@"Time"];
    
    NSString * path = [[LCCrashReport folderPath] stringByAppendingFormat:@"/%@", @([[NSDate date] timeIntervalSince1970])];
    
    [crash writeToFile:path atomically:YES];

}