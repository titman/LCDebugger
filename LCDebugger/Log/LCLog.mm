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

#import "LCLog.h"
#import "LCDebugger.h"

extern "C" NSString * NSStringFormatted( NSString * format, va_list argList )
{
	return [[NSString alloc] initWithFormat:format arguments:argList];
}

extern "C" void LCLog( NSObject * format, ... )
{
    if (!LCLogEnable) {
        return;
    }
    
	if ( nil == format )
		return;
    
	va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"/Log/ ➝ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"/Log/ ➝ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
    [[LCDebugger sharedInstance].debuggerView addLog:text];
    
	printf("%s",[text UTF8String]);
	printf("\n");
}


extern "C" void LCInfo( NSObject * format, ... )
{
    if (!LCLogEnable) {
        return;
    }
    
	if (nil == format )
		return;
    
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"/Info/ ➝ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"/Info/ ➝ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
    [[LCDebugger sharedInstance].debuggerView addLog:text];
    
	printf("%s",[text UTF8String]);
	printf("\n");
}

extern "C" void LCError( NSString * file, const char * function , int line, NSObject * format, ... )
{
    if (!LCLogEnable) {
        return;
    }
    
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"/Error/ ➝ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"/Error/ ➝ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
    
    [[LCDebugger sharedInstance].debuggerView addLog:text];
    [[LCDebugger sharedInstance].debuggerView addLog:[NSString stringWithFormat:@"\n\n[\n    File : %@",file]];
    [[LCDebugger sharedInstance].debuggerView addLog:[NSString stringWithFormat:@"\n    Line : %d",line]];
    [[LCDebugger sharedInstance].debuggerView addLog:[NSString stringWithFormat:@"\n    Function : %s\n]\n",function]];

    printf("%s",[text UTF8String]);
    printf("\n\n[\n    File : %s",[file UTF8String]);
    printf("\n    Line : %d",line);
    printf("\n    Function : %s\n]\n\n",function);
    
#if defined(LC_ERROR_LOCAL_FILE_LOG) && LC_ERROR_LOCAL_FILE_LOG

    // Write to file...
    
#endif

}

extern "C" void LCCMDInfo( NSObject * format, ... )
{
    if (!LCLogEnable) {
        return;
    }
    
    va_list args;
	va_start( args, format );
	
	NSString * text = nil;
	
	if ( [format isKindOfClass:[NSString class]] ){
		text = [NSString stringWithFormat:@"/CMD/ ➝ %@", NSStringFormatted((NSString *)format, args)];
	}
	else{
		text = [NSString stringWithFormat:@"/CMD/ ➝ %@", [format description]];
	}
    
    va_end( args );
    
	if ( [text rangeOfString:@"\n"].length ){
		text = [text stringByReplacingOccurrencesOfString:@"\n" withString:[NSString stringWithFormat:@"\n\t\t"]];
	}
    
    [[LCDebugger sharedInstance].debuggerView addLog:text];

    printf("%s",[text UTF8String]);
	printf("\n");
}


NSString * extractFileNameWithoutExtension(const char * filePath, BOOL copy)
{
	if (filePath == NULL) return nil;
	
	char *lastSlash = NULL;
	char *lastDot = NULL;
	
	char *p = (char *)filePath;
	
	while (*p != '\0')
	{
		if (*p == '/')
			lastSlash = p;
		else if (*p == '.')
			lastDot = p;
		
		p++;
	}
	
	char *subStr;
	NSUInteger subLen;
	
	if (lastSlash)
	{
		if (lastDot)
		{
			// lastSlash -> lastDot
			subStr = lastSlash + 1;
			subLen = lastDot - subStr;
		}
		else
		{
			// lastSlash -> endOfString
			subStr = lastSlash + 1;
			subLen = p - subStr;
		}
	}
	else
	{
		if (lastDot)
		{
			// startOfString -> lastDot
			subStr = (char *)filePath;
			subLen = lastDot - subStr;
		}
		else
		{
			// startOfString -> endOfString
			subStr = (char *)filePath;
			subLen = p - subStr;
		}
	}
	
	if (copy)
	{
		return [[NSString alloc] initWithBytes:subStr
		                                length:subLen
		                              encoding:NSUTF8StringEncoding];
	}
	else
	{
		// We can take advantage of the fact that __FILE__ is a string literal.
		// Specifically, we don't need to waste time copying the string.
		// We can just tell NSString to point to a range within the string literal.
		
		return [[NSString alloc] initWithBytesNoCopy:subStr
		                                      length:subLen
		                                    encoding:NSUTF8StringEncoding
		                                freeWhenDone:NO];
	}
}


