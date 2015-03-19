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
#import <sys/sysctl.h>
#import <UIKit/UIKit.h>

typedef enum {
    PROCESS_STATUS_FORKED       = SIDL,
    PROCESS_STATUS_RUNNABLE     = SRUN,
    PROCESS_STATUS_SLEEPING     = SSLEEP,
    PROCESS_STATUS_SUSPENDED    = SSTOP,
    PROCESS_STATUS_ZOMBIE_STATE = SZOMB
} ProcessStatus_t;

@interface LCProcessInfo : NSObject
@property (nonatomic, copy)   NSString          *name;
@property (nonatomic, assign) NSInteger         pid;
@property (nonatomic, assign) NSInteger         priority;
@property (nonatomic, assign) ProcessStatus_t   status;
@property (nonatomic, assign) time_t            startTime;
@property (nonatomic, copy)   NSString          *commandLine;
@property (nonatomic, strong) UIImage           *icon;

- (NSString*)getStatusString;
@end
