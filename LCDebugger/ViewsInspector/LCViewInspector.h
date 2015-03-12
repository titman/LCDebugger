//
//  LC_ViewInspector.h
//  LCFramework

//  Created by Licheng Guo . ( SUGGESTIONS & BUG titm@tom.com ) on 13-10-9.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).
//
//

#import <UIKit/UIKit.h>

// Copy from BeeFramework ( https://github.com/gavinkwoe/BeeFramework )
@interface LCViewInspector : UIView

- (void)prepareShow:(UIView *)inView;
- (void)prepareHide;

- (void)show;
- (void)hide;

@end

@interface LCInspectorLayer : UIImageView

@property (nonatomic, assign) CGFloat		depth;
@property (nonatomic, assign) CGRect		rect;
@property (nonatomic, strong) UIView  *	view;
@property (nonatomic, strong) UILabel *	label;

@end
