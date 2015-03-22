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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LC_CMD_TYPE) {
    LC_CMD_TYPE_SEE, // see
    LC_CMD_TYPE_ACTION, // action
};

@protocol LC_CMD_IMP <NSObject>

@optional
+(NSString *) CMDSee:(NSString *)cmd;
+(NSString *) CMDAction:(NSString *)cmd;

-(NSString *) CMDSee:(NSString *)cmd;
-(NSString *) CMDAction:(NSString *)cmd;

@end


@interface LCCMD : NSObject

/**
    @brief   The method could dynamically add a command for a Class.
 
    @param   cmd a string describing the cmd.
    @param   cmdType LC_CMD_TYPE, LC_CMD_TYPE_SEE "see" LC_CMD_TYPE_ACTION "action"
    @param   impClass implementation class.
    @param   cmdDescription a string describing usage of the cmd .

    @example use this method
 
             [LCCMD addClassCMD:@"application" CMDType:LC_CMD_TYPE_SEE IMPClass:[AppDelegate class] CMDDescription:@"Test"];
 
             then implement <LC_CMD_IMP> protocol,
 
             +(NSString *)CMDSee:(NSString *)cmd{
                 if([cmd isEqualToString:@"application"])
                    return @"Response command!"
                 };
                 return @"";
             }
             
             at last, when input command at local or remote debug, 
             the string @"Response command!" will output on the device screen.
 
 */
+(BOOL) addClassCMD:(NSString *)cmd CMDType:(LC_CMD_TYPE)cmdType IMPClass:(Class <LC_CMD_IMP>)impClass CMDDescription:(NSString *)cmdDescription;


/**
    @brief   The method could dynamically add a command for a object.
 
    @param   cmd a string describing the cmd.
    @param   cmdType LC_CMD_TYPE, LC_CMD_TYPE_SEE "see" LC_CMD_TYPE_ACTION "action"
    @param   impObject implementation object.
    @param   cmdDescription a string describing usage of the cmd .
 
    @example use this method
 
             [LCCMD addClassCMD:@"application" CMDType:LC_CMD_TYPE_SEE IMPObject:anObject CMDDescription:@"Test"];
 
             then implement <LC_CMD_IMP> protocol,
 
             -(NSString *)CMDSee:(NSString *)cmd{
                 if([cmd isEqualToString:@"application"])
                     return @"Response command!"
                 };
                 return @"";
             }
 
             at last, when input command at local or remote debug,
             the string @"Response command!" will output on the device screen or remote debug.
 
 */
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


