//
//  LCWebServer.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/16.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol LCWebServerDelegate <NSObject>
//
//@optional
//- (void) webServerCouldNotBeEstablished;
//- (void) webServerWasEstablished;
//- (void) webServerWasLost;
//@end

@interface LCWebServer : NSObject

//@property (nonatomic,assign) NSString * cwd;
//@property (nonatomic,assign) NSInteger chosenPort;
//
//@property(nonatomic,weak) id<LCWebServerDelegate> delegate;

- (void) start;

@end
