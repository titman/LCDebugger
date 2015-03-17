//
//  LCCrashReport.h
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/16.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __cplusplus
extern "C" {
#endif
    
    void LCCrashReportHandler( NSException * exception );
    
#if __cplusplus
};
#endif


@interface LCCrashReport : NSObject

@end
