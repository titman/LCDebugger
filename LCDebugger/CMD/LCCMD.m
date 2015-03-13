//
//  LC_CMDAnalysis.m
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LCDebuggerImport.h"
#import "LCCMD.h"
#import "LCLog.h"

@interface LCCMDCache ()

@end

@implementation LCCMDCache

-(NSString *)cmdDescription
{
    if (LC_NSSTRING_IS_INVALID(_cmdDescription)) {
        return @"";
    }
    
    if (!self.afterAdd || [self.cmd isEqualToString:@"exit"] || [self.cmd isEqualToString:@"help"] || [self.cmd isEqualToString:@"lcs"]) {
        
        return _cmdDescription;
    }
    
    return [NSString stringWithFormat:@"%@ (After add)",_cmdDescription];
}

@end

#pragma mark -

static NSMutableDictionary * __commandCache = nil;

@implementation LCCMD

+(void) load
{
    // Default cmd.
    [LCCMD addClassCMD:@"exit" CMDType:LC_CMD_TYPE_ACTION IMPClass:[LCCMD class] CMDDescription:@"Exit the application."];
    [LCCMD addClassCMD:@"help" CMDType:LC_CMD_TYPE_SEE IMPClass:[LCCMD class] CMDDescription:@"See the all command."];
    [LCCMD addObjectCMD:@"lcs" CMDType:LC_CMD_TYPE_SEE IMPObject:[[NSObject alloc] init] CMDDescription:@"See the all LCFastSingleton"];
    
}

+(BOOL) analysisCommand:(NSString *)command
{
    if (command.length <= 0) {
        return NO;
    }
    
    CMDLog(@"CMD - %@",[command lowercaseString]);
    
    NSString * errorString = [NSString stringWithFormat:@"Invalid command : %@. ( You can input 'see help' to see all command. Or add the command use 'LCCMD.h')",command];
    
    NSArray * commandArray = [command componentsSeparatedByString:@" "];

    if (!commandArray || commandArray.count <= 1 || ![command isKindOfClass:[NSString class]]) {

        CMDLog(errorString);
        return NO;
    }
    
    NSString * type = commandArray[0];
    NSString * cmd = commandArray[1];
    
    LCCMDCache * cache = self.commandCache[cmd];
    
    if (!cache) {
        CMDLog(errorString);
        return NO;
    }
    
    if ([type isEqualToString:@"see"]) {
        
        if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
            [self execute:cache];
            return YES;
        }
        else{
            
            CMDLog(errorString);
            return NO;
        }
        
    }
    else if([type isEqualToString:@"action"]){
        
        if (cache.cmdType == LC_CMD_TYPE_ACTION) {
            
            [self execute:cache];
            return YES;
        }
        else{
            
            CMDLog(errorString);
            return NO;
        }
    }
    
    return YES;
}

+(void) execute:(LCCMDCache *)cache
{
    if (cache.class) {
        
        if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
            NSString * info = [cache.class CMDSee:cache.cmd];
            
            CMDLog(info);
        }
        else if (cache.cmdType == LC_CMD_TYPE_ACTION){
            
            [cache.class CMDAction:cache.cmd];
        }
        
        return;
    }
    
    
    if (cache.object) {
        
        if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
            NSString * info = [cache.object CMDSee:cache.cmd];
            
            CMDLog(info);
        }
        else if (cache.cmdType == LC_CMD_TYPE_ACTION){
            
            [cache.object CMDAction:cache.cmd];
        }
        return;
    }
}

+(BOOL) addClassCMD:(NSString *)cmd CMDType:(LC_CMD_TYPE)cmdType IMPClass:(Class <LC_CMD_IMP>)impClass CMDDescription:(NSString *)cmdDescription
{
    if (!cmd || cmd.length <= 0) {
        
        ERROR(@"Can't add command, Because it is invalid.");
        return NO;
    }
    
    LCCMDCache * cache = [[LCCMDCache alloc] init];
    cache.cmd = cmd;
    cache.cmdType = cmdType;
    cache.class = impClass;
    cache.cmdDescription = cmdDescription;
    cache.afterAdd = YES;
    
    [self.commandCache setObject:cache forKey:cmd];
    
    return YES;
}

+(BOOL) addObjectCMD:(NSString *)cmd CMDType:(LC_CMD_TYPE)cmdType IMPObject:(NSObject <LC_CMD_IMP> *)impObject CMDDescription:(NSString *)cmdDescription
{
    if (!cmd || cmd.length <= 0) {
        
        ERROR(@"Can't add command, Because it is invalid.");
        return NO;
    }
    
    LCCMDCache * cache = [[LCCMDCache alloc] init];
    cache.cmd = cmd;
    cache.cmdType = cmdType;
    cache.object = impObject;
    cache.cmdDescription = cmdDescription;
    cache.afterAdd = YES;
    
    [self.commandCache setObject:cache forKey:cmd];
    
    return YES;
}


+(NSMutableDictionary *) commandCache;
{
    if (!__commandCache) {
        __commandCache = [NSMutableDictionary dictionary];
    }
    
    return __commandCache;
}



// Default cmd
+(void) CMDAction:(NSString *)cmd
{
    if ([cmd isEqualToString:@"exit"]) {
        
        exit(0);
    }
}

+(NSString *) CMDSee:(NSString *)cmd
{
    if ([cmd isEqualToString:@"help"]) {
     
        
        NSDictionary * datasource = [LCCMD commandCache];
        
        if (!datasource) {
            return @"No cmd, or not use LCCMD.";
        }
        
        NSMutableString * info = [NSMutableString stringWithFormat:@"  * CMD Count : %@\n", @(datasource.allKeys.count)];
        
        for (NSString * key in datasource.allKeys) {
            
            LCCMDCache * cache = datasource[key];
            
            [info appendFormat:@"  * %@ - %@ [%@]\n", cache.cmdType == LC_CMD_TYPE_SEE ? @"see" : @"action", cache.cmd, cache.cmdDescription];
        }
        
        return info;
    }
    
    return @"";
}

@end
