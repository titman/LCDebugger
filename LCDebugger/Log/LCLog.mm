//
//                  ___       ___
//                 /\__\     /\  \
//                /:/  /    /::\  \
//               /:/  /    /:/\:\  \
//              /:/  /    /:/  \:\  \
//             /:/__/    /:/__/ \:\__\
//             \:\  \    \:\  \  \/__/
//              \:\  \    \:\  \
//               \:\  \    \:\  \
//                \:\__\    \:\__\
//                 \/__/     \/__/
//
//
//  LS_LOG.m
//  LCFramework

//  Created by LiCheng Guo . ( SUGGESTIONS & BUG titm@tom.com / http://github.com/titman ) on 13-9-12.
//  Copyright (c) 2014年 Licheng Guo iOS developer ( http://nsobject.me ).All rights reserved.
//  Also see the copyright page ( http://nsobject.me/copyright.rtf ).


#import "LCLog.h"
#import "LCDebugger.h"

extern "C" NSString * NSStringFormatted( NSString * format, va_list argList )
{
	return [[NSString alloc] initWithFormat:format arguments:argList];
}

extern "C" void LCLog( NSObject * format, ... )
{
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


