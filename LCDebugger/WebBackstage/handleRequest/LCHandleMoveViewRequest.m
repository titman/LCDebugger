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

#import "LCHandleMoveViewRequest.h"
#import <UIKit/UIKit.h>
#import "LCGCD.h"

@implementation LCHandleMoveViewRequest

-(NSDictionary *) handleRequestPath:(NSString *)path
{
    NSString * param = [path componentsSeparatedByString:@"?"].lastObject;
    NSArray * params = [param componentsSeparatedByString:@"&"];
    
    NSString * frameString = [[[params[0] componentsSeparatedByString:@"="] lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSInteger address = [[[params[1] componentsSeparatedByString:@"="] lastObject] integerValue];
    
    NSArray * numbers = [frameString componentsSeparatedByString:@","];
    
    if (![frameString rangeOfString:@","].length && numbers.count != 4) {
        
        return @{@"code":@(304)};
    }
    
    
    CGRect rect = CGRectMake([numbers[0] floatValue], [numbers[1] floatValue], [numbers[2] floatValue], [numbers[3] floatValue]);
    
    UIView * view = [self view:[UIApplication sharedApplication] withAddress:address];
    
    [LCGCD dispatchAsyncInMainQueue:^{
       
        view.frame = rect;
    }];
    
    return @{@"code":@(200)};
}

- (UIView *)view:(id)obj withAddress:(NSInteger)address
{
    if ([obj isKindOfClass:[UIView class]]) {
        
        UIView *view = (UIView *)obj;
        
        if ((NSInteger)view == address)
        {
            return view;
        }
        
        for (UIView *v in view.subviews)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    if ([obj isKindOfClass:[UIApplication class]]) {
        
        UIApplication *app = (UIApplication *)obj;
        
        for (UIView *v in app.windows)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    return nil;
}

@end
