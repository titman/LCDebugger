//
//  LCWebServerConnection.m
//  LCDebuggerDemo
//
//  Created by Leer on 15/3/17.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCWebServerConnection.h"
#import "HTTPDynamicFileResponse.h"
#import "LCCMD.h"

@implementation LCWebServerConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    // Use HTTPConnection's filePathForURI method.
    // This method takes the given path (which comes directly from the HTTP request),
    // and converts it to a full path by combining it with the configured document root.
    //
    // It also does cool things for us like support for converting "/" to "/index.html",
    // and security restrictions (ensuring we don't serve documents outside configured document root folder).
    
    NSString *filePath = [self filePathForURI:path];
    
    // Convert to relative path
    
    NSString *documentRoot = [config documentRoot];
    
    if (![filePath hasPrefix:documentRoot])
    {
        // Uh oh.
        // HTTPConnection's filePathForURI was supposed to take care of this for us.
        return nil;
    }
    
    NSRange range = [path rangeOfString:@"/?cmd="];
    
    if (range.length)
    {
        NSArray * parmater = [path componentsSeparatedByString:@"/?cmd="];
        
        if (parmater.count >= 2) {
            [LCCMD analysisCommand:[parmater[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        return [super httpResponseForMethod:method URI:path];
    }
    
    return [super httpResponseForMethod:method URI:path];
}


@end
