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
        
        
        return [NSString stringWithFormat:@"%@ (*)",_cmdDescription];
    }
    
    return _cmdDescription;
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
    
    command = [command lowercaseString];
    
    CMDLog(@"CMD - %@",command);
    
    NSString * errorString = [NSString stringWithFormat:@"Invalid command : %@. ( You can input 'see help' to see all command. Or add the command use 'LCCMD.h')",command];
    
    NSMutableArray * commandArray = [[command componentsSeparatedByString:@" "] mutableCopy];

    if (commandArray.count == 1) {
     
        [commandArray insertObject:@"sim" atIndex:0];
    }
    else if (!commandArray || commandArray.count <= 1 || ![command isKindOfClass:[NSString class]]) {

        CMDLog(errorString);
        return NO;
    }
    
    //NSString * type = commandArray[0];
    NSString * cmd = commandArray[1];
    
    LCCMDCache * cache = self.commandCache[cmd];
    
    if (!cache) {
        CMDLog(errorString);
        return NO;
    }
    
    if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
        [self execute:cache];
        return YES;
    }
    else if (cache.cmdType == LC_CMD_TYPE_ACTION) {
            
        [self execute:cache];
        return YES;
    }
    
    CMDLog(errorString);
    return NO;
}

+(void) execute:(LCCMDCache *)cache
{
    if (cache.class) {
        
        if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
            NSString * info = [cache.class CMDSee:cache.cmd];
            
            CMDLog(info);
        }
        else if (cache.cmdType == LC_CMD_TYPE_ACTION){
            
             NSString * info = [cache.class CMDAction:cache.cmd];
            
            if (info) {
                CMDLog(info);
            }
        }
        
        return;
    }
    
    
    if (cache.object) {
        
        if (cache.cmdType == LC_CMD_TYPE_SEE) {
            
            NSString * info = [cache.object CMDSee:cache.cmd];
            
            CMDLog(info);
        }
        else if (cache.cmdType == LC_CMD_TYPE_ACTION){
            
            NSString * info = [cache.object CMDAction:cache.cmd];
            
            if (info) {
                CMDLog(info);
            }
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
+(NSString *) CMDAction:(NSString *)cmd
{
    if ([cmd isEqualToString:@"exit"]) {
        
        exit(0);
    }
    
    return nil;
}

+(NSString *) CMDSee:(NSString *)cmd
{
    if ([cmd isEqualToString:@"help"]) {
     
        
        NSDictionary * datasource = [LCCMD commandCache];
        
        if (!datasource) {
            return @"No cmd, or not use LCCMD.";
        }
        
        NSMutableString * info = [NSMutableString stringWithFormat:@"   * CMD Count : %@\n", @(datasource.allKeys.count)];
        
        for (NSString * key in datasource.allKeys) {
            
            LCCMDCache * cache = datasource[key];
            
            [info appendFormat:@"  * %@ - %@ [%@]\n", cache.cmdType == LC_CMD_TYPE_SEE ? @"see" : @"action", cache.cmd, cache.cmdDescription];
        }
        
        return info;
    }
    
    return @"";
}

@end
