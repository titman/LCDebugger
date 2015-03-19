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

#import "LCDebuggerImport.h"
#import <Foundation/Foundation.h>

typedef enum {
    CONNECTION_STATUS_ESTABLISHED,
    CONNECTION_STATUS_CLOSED,
    CONNECTION_STATUS_OTHER
} ConnectionStatus_t;

@interface LCActiveConnection : NSObject
@property (nonatomic, copy) NSString              *localIP;
@property (nonatomic, copy) NSString              *localPort;
@property (nonatomic, copy) NSString              *localPortService;

@property (nonatomic, copy) NSString              *remoteIP;
@property (nonatomic, copy) NSString              *remotePort;
@property (nonatomic, copy) NSString              *remotePortService;

@property (nonatomic, assign) ConnectionStatus_t    status;
@property (nonatomic, copy) NSString                *statusString;

@property (nonatomic, assign) CGFloat               totalTX;
@property (nonatomic, assign) CGFloat               totalRX;
@end
