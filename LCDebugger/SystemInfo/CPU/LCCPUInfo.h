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

@interface LCCPUInfo : NSObject

@property (nonatomic, copy)   NSString     *cpuName;
@property (nonatomic, assign) NSUInteger   activeCPUCount;
@property (nonatomic, assign) NSUInteger   physicalCPUCount;
@property (nonatomic, assign) NSUInteger   physicalCPUMaxCount;
@property (nonatomic, assign) NSUInteger   logicalCPUCount;
@property (nonatomic, assign) NSUInteger   logicalCPUMaxCount;
@property (nonatomic, assign) NSUInteger   cpuFrequency;
@property (nonatomic, assign) NSUInteger   l1DCache;
@property (nonatomic, assign) NSUInteger   l1ICache;
@property (nonatomic, assign) NSUInteger   l2Cache;
@property (nonatomic, copy)   NSString     *cpuType;
@property (nonatomic, copy)   NSString     *cpuSubtype;
@property (nonatomic, copy)   NSString     *endianess;
@end
