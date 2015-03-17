//
//  LCWebServer.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/16.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCWebServer.h"
#include <arpa/inet.h>
#include <netdb.h>
#import "LCLog.h"
#import "UIDevice+Reachability.h"
#import "HTTPServer.h"

//#define BUFSIZE 8096

//#define STATUS_OFFLINE	0
//#define STATUS_ATTEMPT	1
//#define STATUS_ONLINE	2
//
//#define DO_CALLBACK(X, Y) if (self.delegate && [self.delegate respondsToSelector:@selector(X)]) [self.delegate performSelector:@selector(X) withObject:Y];


@interface LCWebServer ()

@property(nonatomic,strong) HTTPServer * server;

//@property (nonatomic,assign) NSInteger serverStatus;
//@property (nonatomic,assign) int listenfd;
//@property (nonatomic,assign) int socketfd;
//@property (nonatomic,assign) BOOL isServing;


@end

@implementation LCWebServer

+ (BOOL)touchPath:(NSString *)path
{
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

- (void) start
{
    [self buildWebFolder];
    
//    if (self.isServing) return;
//    
//    if (![UIDevice  networkAvailable])
//    {
//        ERROR(@"You are not connected to the network. Please do so before running this application.");
//        return;
//    }
//    
//    [self startServer];
//    
//    self.isServing = YES;
    
    // Create server using our custom MyHTTPServer class
    self.server = [[HTTPServer alloc] init];
    
    // Tell the server to broadcast its presence via Bonjour.
    // This allows browsers such as Safari to automatically discover our service.
    [self.server setType:@"_http._tcp."];
    
    // Normally there's no need to run our server on any specific port.
    // Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
    // However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [self.server setPort:12352];
    
    // Serve files from our embedded Web folder
    [self.server setDocumentRoot:[self.class webFolderPath]];
    
    [self startServer];
}



-(void) buildWebFolder
{
    [self.class touchPath:[self.class webFolderPath]];
    
    [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"cmd" ofType:@"html"] toPath:[[self.class webFolderPath] stringByAppendingString:@"index.html"] error:nil];
}

+(NSString *) webFolderPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches/LCWeb/"];
}

- (void)startServer
{
    // Start the server (and check for problems)
    NSError * error;
    
    if([self.server start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [self.server listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

//- (void) startServer
//{
//    static struct sockaddr_in serv_addr;
//    
//    // Set up socket
//    if((self.listenfd = socket(AF_INET, SOCK_STREAM,0)) < 0)
//    {
//        self.isServing = NO;
//        
//        DO_CALLBACK(webServerCouldNotBeEstablished, nil);
//        return;
//    }
//    
//    INFO(@"Web server start...");
//    
//    // Serve to a random port
//    serv_addr.sin_family = AF_INET;
//    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
//    serv_addr.sin_port = 0;
//    
//    // Bind
//    if(bind(self.listenfd, (struct sockaddr *)&serv_addr,sizeof(serv_addr)) <0)
//    {
//        self.isServing = NO;
//        DO_CALLBACK(webServerCouldNotBeEstablished, nil);
//        return;
//    }
//    
//    // Find out what port number was chosen.
//    int namelen = sizeof(serv_addr);
//    if (getsockname(self.listenfd, (struct sockaddr *)&serv_addr, (void *) &namelen) < 0) {
//        close(self.listenfd);
//        self.isServing = NO;
//        DO_CALLBACK(webServerCouldNotBeEstablished, nil);
//        return;
//    }
//    
//    self.chosenPort = ntohs(serv_addr.sin_port);
//    
//    // Listen
//    if(listen(self.listenfd, 64) < 0)
//    {
//        self.isServing = NO;
//        DO_CALLBACK(webServerCouldNotBeEstablished, nil);
//        return;
//    } 
//    
//    DO_CALLBACK(webServerWasEstablished, nil);
//    [NSThread detachNewThreadSelector:@selector(listenForRequests) toTarget:self withObject:NULL];
//}
//
//- (void) listenForRequests
//{
//    INFO(@"Web server request listenning...");
//
//    static struct sockaddr_in cli_addr;
//    socklen_t length = sizeof(cli_addr);
//    
//    while (1 > 0) {
//        if (!self.isServing) return;
//        
//        if ((self.socketfd = accept(self.listenfd, (struct sockaddr *)&cli_addr, &length)) < 0)
//        {
//            self.isServing = NO;
//            DO_CALLBACK(webServerWasLost, nil);
//            return;
//        }
//        
//        [self handleWebRequest:self.socketfd];
//    }
//}
//
//- (void) handleWebRequest:(int) fd
//{
//    // recover request
//    NSString *request = [self getRequest:fd];
//    
//    // Create a category and implement this meaningfully
//    NSMutableString *outcontent = [NSMutableString stringWithContentsOfFile:[[self.class webFolderPath] stringByAppendingString:@"/cmd.html"] encoding:NSUTF8StringEncoding error:nil];
////    [outcontent appendString:@"HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"];
////    [outcontent appendString:@"<html><h1>我正在等....</h1><h3>阿布爱nono</h3>"];
////    [outcontent appendString:@"<p>来填充我吧.\n"];
////    [outcontent appendString:@"Please quickly!</p>"];
////    [outcontent appendFormat:@"<pre>%@</pre></html>", request];
//    write (fd, [outcontent UTF8String], [outcontent length]);
//    close(fd);
//}
//
//- (NSString *) getRequest:(int)fd
//{
//    static char buffer[BUFSIZE+1];
//    ssize_t len = read(fd, buffer, BUFSIZE);
//    buffer[len] = '\0';
//    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
//}

@end
