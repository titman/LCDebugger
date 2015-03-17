//
//  LCCrashReport.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/16.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
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
    
    if ([cmd isEqualToString:@"crashreport"]) {
        
        NSMutableString * info = [NSMutableString stringWithFormat:@"\n  * Count : %@\n", @(crashLogs.count)];
        
        for (NSDictionary * crash in crashLogs) {
            
            [info appendFormat:@"   * Reason : %@ \nCallStackSymbols : %@\nTime : %@\n\n", crash[@"Reason"], crash[@"CallStackSymbols"], crash[@"Time"]];
        }
        
        return info;
    }
    else if ([cmd isEqualToString:@"lastcrash"]){
        
        return crashLogs.lastObject;
    }
    
    return @"";
}

+(void) CMDAction:(NSString *)cmd
{
    
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