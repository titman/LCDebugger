//
//  LCActionSheet.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/13.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LCActionSheetDismissed) (NSInteger index);

@interface LCActionSheet : UIView

@property(nonatomic, copy) LCActionSheetDismissed dismissedBlock;

-(void) addTitle:(NSString *)title;

-(void) show;


@end
