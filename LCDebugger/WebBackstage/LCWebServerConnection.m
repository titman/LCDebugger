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
#import "LCWebServerConnection.h"
#import "HTTPDynamicFileResponse.h"
#import "HTTPDataResponse.h"
#import "LCCMD.h"
#import "LCHandleRequest.h"

@implementation LCWebServerConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    NSString * filePath = [self filePathForURI:path];
    
    NSString * documentRoot = [config documentRoot];
    
    if (![filePath hasPrefix:documentRoot]){
        
        return nil;
    }
    
    
    if ([path rangeOfString:@"/?cmd="].length)
    {
        NSArray * parmater = [path componentsSeparatedByString:@"/?cmd="];
        
        if (parmater.count >= 2) {
            [LCCMD analysisCommand:[parmater[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        return [super httpResponseForMethod:method URI:path];
    }
    else if ([path rangeOfString:@"loadViewTree"].length)
    {
        return [[HTTPDataResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"state":@"success",@"data":[LCHandleViewTreeRequest.LCS handleRequestPath:path]} options:0 error:nil]];

    }
    else if ([path rangeOfString:@"highlightView"].length)
    {
        return [[HTTPDataResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"state":@"success",@"data":[LCHandleViewHighlightRequest.LCS handleRequestPath:path]} options:0 error:nil]];
    }
    else if ([path rangeOfString:@"moveview"].length)
    {
        return [[HTTPDataResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:@{@"state":@"success",@"data":[LCHandleMoveViewRequest.LCS handleRequestPath:path]} options:0 error:nil]];
    }
    else if ([path rangeOfString:@"deviceinfo"].length)
    {
        return [[HTTPDataResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[LCHandleDeviceInfoRequest.LCS handleRequestPath:path] options:0 error:nil]];
    }
    else if ([path rangeOfString:@"crashreport"].length)
    {
        [LCCMD analysisCommand:@"see crashreport"];
        
        return nil;
    }
    else if ([path rangeOfString:@"cmdhelp"].length)
    {
        [LCCMD analysisCommand:@"see help"];
        
        return nil;
    }

    return [super httpResponseForMethod:method URI:path];
}


@end
