//
//  LC_CMDAnalysis.m
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import "LC_CMDAnalysis.h"

@implementation LC_CMDAnalysis

+(NSString *) analysisCommand:(NSString *)command
{
    NSArray * commandArray = [command componentsSeparatedByString:@" "];
    
    if (!commandArray || commandArray.count <= 1 || ![command isKindOfClass:[NSString class]]) {
        
        CMDLog(@"Error command : %@.",command);
        CMDLog(@"%@",LC_CMD_HELPER);
        return nil;
    }
    
    NSString * action = commandArray[0];
    NSString * execute = commandArray[1];
    
    NSString * info = [NSString stringWithFormat:@"Can't request the command : %@.",command];
    
    //Action
    if ([action isEqualToString:LC_CMD_SEE]) {
        
        if ([execute isEqualToString:LC_CMD_CURRENT_RUNNING_TIMER]) {
            
            return [NSObject runningTimerInfo];
        }
        else if ([execute isEqualToString:LC_CMD_CURRENT_WEB_IMAGE_CACHE]){
            
            return [LC_UIImageView currentWebImageCache];
        }
        else if ([execute isEqualToString:LC_CMD_CURRENT_DATASOURCE]){
         
            return [LC_Datasource currentDatasourceInfo];
        }
        else if ([execute isEqualToString:LC_CMD_CURRENT_INSTENCE]){
            
            return [NSObject currentInstenceInfo];
        }
        
    }else if ([action isEqualToString:LC_CMD_ACTION]){
        
        if ([execute isEqualToString:LC_CMD_EXIT]) {
         
            exit(0);
        }
        
    }
    
    return info;
    
}

@end
