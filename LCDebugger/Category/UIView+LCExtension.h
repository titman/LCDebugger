//
//  UIView+Extension.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-11.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <UIKit/UIKit.h>

typedef id (^UIViewAddSubviewBlock)( id obj );
typedef id (^UIViewSizeToFitBlock)();

@interface UIView (LCExtension)

@property (nonatomic, readonly) UIViewAddSubviewBlock ADD;
@property (nonatomic, readonly) UIViewSizeToFitBlock  FIT;

+ (instancetype)view;
+ (instancetype)viewWithFrame:(CGRect)frame;

- (void) removeAllSubviews;

- (UIViewController *)viewController;

//-(NSString *) signalName;
//-(void) setSignalName:(NSString *)signalName;

@end
