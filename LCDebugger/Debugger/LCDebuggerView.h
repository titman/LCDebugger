//
//  LCDebuggerTip.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/11.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^LCAssistiveTouchDidSelected) ();

@interface LCDebuggerView : UIButton

@property(nonatomic,copy) LCAssistiveTouchDidSelected didSelected;

-(void) addLog:(NSString *)log;

@end
