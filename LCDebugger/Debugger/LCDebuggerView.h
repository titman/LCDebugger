//
//  LCDebuggerTip.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef	weakly
#if __has_feature(objc_arc)
#define weakly( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define weakly( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	weakify

#ifndef	normally
#if __has_feature(objc_arc)
#define normally( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define normally( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@normalize



typedef void (^LCAssistiveTouchDidSelected) ();

@interface LCDebuggerView : UIButton

@property(nonatomic,copy) LCAssistiveTouchDidSelected didSelected;

-(void) addLog:(NSString *)log;

@end
