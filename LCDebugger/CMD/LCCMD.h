//
//  LC_CMDAnalysis.h
//  LCFramework
//
//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LC_CMD_TYPE) {
    LC_CMD_TYPE_SEE, // see
    LC_CMD_TYPE_ACTION, // action
};

@protocol LC_CMD_IMP <NSObject>

@optional
+(NSString *) CMDSee:(NSString *)cmd;
+(void) CMDAction:(NSString *)cmd;

-(NSString *) CMDSee:(NSString *)cmd;
-(void) CMDAction:(NSString *)cmd;

@end


@interface LCCMD : NSObject

+(BOOL) addClassCMD:(NSString *)cmd CMDType:(LC_CMD_TYPE)cmdType IMPClass:(Class <LC_CMD_IMP>)impClass CMDDescription:(NSString *)cmdDescription;
+(BOOL) addObjectCMD:(NSString *)cmd CMDType:(LC_CMD_TYPE)cmdType IMPObject:(NSObject <LC_CMD_IMP> *)impObject CMDDescription:(NSString *)cmdDescription;

+(BOOL) analysisCommand:(NSString *)command;

@end





#pragma mark -

@interface LCCMDCache : NSObject

@property(nonatomic,assign) LC_CMD_TYPE cmdType;
@property(nonatomic,copy) NSString * cmd;
@property(nonatomic,strong) NSObject<LC_CMD_IMP> * object;
@property(nonatomic,strong) Class<LC_CMD_IMP> class;
@property(nonatomic,assign) BOOL afterAdd;


@property(nonatomic,copy) NSString * cmdDescription;

@end


