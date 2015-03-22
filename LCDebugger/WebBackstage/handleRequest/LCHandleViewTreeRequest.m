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

#import "LCHandleViewTreeRequest.h"
#import "UIView+Observer.h"
#import "NSObject+ViewTree.h"


@interface LCHandleViewTreeRequest ()

@property(nonatomic,assign) BOOL firstLoad;
@property(nonatomic,assign) double lastUpdate;

@end

@implementation LCHandleViewTreeRequest

-(instancetype) init
{
    if (self = [super init]) {
        
        
    }
    
    return self;
}

-(NSDictionary *) handleRequestPath:(NSString *)path
{
    NSString * param = [path componentsSeparatedByString:@"?"].lastObject;
    
    NSTimeInterval timeStamp = [[[param componentsSeparatedByString:@"="] lastObject] doubleValue];
    
    if ([UIView needsRefresh] == NO && self.lastUpdate <= timeStamp)
    {
        return @{
                   @"code":@(304)
                };
        
    }else{

        [UIView setNeedsRefresh:NO];
        
        timeStamp = [[NSDate date] timeIntervalSince1970];
        
        self.lastUpdate = timeStamp;
        
        return @{
                    @"code":        @(200),
                    @"lastUpdate":  [NSString stringWithFormat:@"%@",@(timeStamp)],
                    @"content":     [[UIApplication sharedApplication] toDict]
                 };
    }

    return nil;
}

@end
