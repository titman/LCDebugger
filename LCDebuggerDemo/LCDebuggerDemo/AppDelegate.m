//
//  AppDelegate.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/10.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "AppDelegate.h"
#import "LCCMD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // You must call this to use LCDebugger.
    [LCDebugger sharedInstance];
    
    
    // To close log printf.
    // [LCDebugger sharedInstance].logEnable = NO;
    
    // Do some settings.
    // [LCDebugger sharedInstance].debuggerView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];


    // We can dynamically add a command.
    // Just example.
    [LCCMD addClassCMD:@"token" CMDType:LC_CMD_TYPE_SEE IMPClass:[self class] CMDDescription:@"See the current device token."];
    [LCCMD addClassCMD:@"userid" CMDType:LC_CMD_TYPE_SEE IMPClass:[self class] CMDDescription:@"See the current user id."];

    //
    // You could use web browser to remote debug when you see "/Info/ ➝ Web backstage address : http://192.168.xxx.xxx:11231".
    //
    
    return YES;
}

+(NSString *)CMDSee:(NSString *)cmd
{
    if ([cmd isEqualToString:@"token"]) {
        
        return @"Your device token";
    }
    
    if ([cmd isEqualToString:@"userid"]) {
        
        return @"Your user id";
    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
