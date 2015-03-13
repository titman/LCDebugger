//
//  NSObject+LCFastSingleton.h
//  LCFastSingleton

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com / https://github.com/titman ) on 13-9-16.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <Foundation/Foundation.h>
#import "LCCMD.h"

#undef  LC_SINGLETON_CUSTOM_METHOD_NAME
#define LC_SINGLETON_CUSTOM_METHOD_NAME LCS // You can custom the method name, for example: your project prefix + S.

@interface NSObject (LCFastSingleton) <LC_CMD_IMP>


+ (instancetype) LC_SINGLETON_CUSTOM_METHOD_NAME;
+ (instancetype) LCSingleton;

@end
