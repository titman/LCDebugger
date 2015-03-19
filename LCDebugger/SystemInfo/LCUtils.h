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
#import <CoreGraphics/CoreGraphics.h>

#define AM_UNUSED(var)  (void)(var)

#define B_TO_KB(a)      ((a) / 1024.0)
#define B_TO_MB(a)      (B_TO_KB(a) / 1024.0)
#define B_TO_GB(a)      (B_TO_MB(a) / 1024.0)
#define B_TO_TB(a)      (B_TO_GB(a) / 1024.0)
#define KB_TO_B(a)      ((a) * 1024.0)
#define MB_TO_B(a)      (KB_TO_B(a) * 1024.0)
#define GB_TO_B(a)      (MB_TO_B(a) * 1024.0)
#define TB_TO_B(a)      (GB_TO_B(a) * 1024.0)

@interface LCUtils : NSObject
/* SysCtl */
+ (uint64_t)getSysCtl64WithSpecifier:(char*)specifier;
+ (NSString*)getSysCtlChrWithSpecifier:(char*)specifier;
+ (void*)getSysCtlPtrWithSpecifier:(char*)specifier pointer:(void*)ptr size:(size_t)size;
+ (uint64_t)getSysCtlHw:(uint32_t)hwSpecifier;

// Returns a value representing a specified percent of the value between max and min.
// i.e. 20 percent in the range of 0-10 is 2.
+ (CGFloat)percentageValueFromMax:(CGFloat)max min:(CGFloat)min percent:(CGFloat)percent;
+ (CGFloat)valuePercentFrom:(CGFloat)from to:(CGFloat)to value:(CGFloat)value;

+ (CGFloat)random;

+ (NSString*)toNearestMetric:(uint64_t)value desiredFraction:(NSUInteger)fraction;

+ (BOOL)isIPad;
+ (BOOL)isIPhone;
+ (BOOL)isIPhone5;

+ (BOOL)dateDidTimeout:(NSDate*)date seconds:(double)sec;

+ (void)openReviewAppPage;
@end
