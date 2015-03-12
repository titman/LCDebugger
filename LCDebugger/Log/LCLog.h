//
//  LS_LOG.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-9-12.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <Foundation/Foundation.h>



#undef	NSLog
#define	NSLog(desc,...) LCLog(desc, ##__VA_ARGS__)


#undef  INFO
#define INFO(desc,...) LCInfo(desc, ##__VA_ARGS__) /* Special "NSLog". For example:LC ✨INFO✨ ⥤ hello word! */


#undef  ERROR
#define ERROR(desc,...) LCError(LC_THIS_FILE, LC_THIS_METHOD, LC_THIS_LINE, desc, ##__VA_ARGS__) /* The ERROR is not affected by LC_DEBUG_ENABLE and could set the local filelogs. For example:LC 👿ERROR👿 ⥤ error warning! */


#undef  CMDLog
#define CMDLog(desc,...) LCCMDInfo(desc, ##__VA_ARGS__)


#ifdef DEBUG
#   define LCAssert(_cond, _format, ...)                                                        \
do {                                                                                    \
BOOL _condEval = (_cond);                                                           \
if (!_condEval)                                                                     \
{                                                                                   \
NSString *_msg = [[NSString alloc] initWithFormat:@"%s [ASSERT] `" #_cond "`: " #_format,   \
__PRETTY_FUNCTION__, ##__VA_ARGS__];      \
NSAssert(_condEval, _msg);                                                      \
}                                                                                   \
} while (0)
#else
#   define LCAssert(_cond, _format, ...)                                                        \
if (!(_cond))                                                                           \
{                                                                                       \
    ERROR(@"%s [ASSERT]: "    #_format, __PRETTY_FUNCTION__, ##__VA_ARGS__);       \
}
#endif


#if __cplusplus
extern "C" {
#endif
    
	void LCLog( NSObject * format, ... );
    
    void LCInfo( NSObject * format, ... );
    
    void LCCMDInfo( NSObject * format, ... );
    
    void LCError( NSString * file, const char * function, int line, NSObject * format, ... );
    
    NSString * extractFileNameWithoutExtension(const char * filePath, BOOL copy);

#if __cplusplus
};
#endif





#define LC_THIS_FILE (extractFileNameWithoutExtension(__FILE__, NO))

#define LC_THIS_METHOD __FUNCTION__

#define LC_THIS_LINE __LINE__





