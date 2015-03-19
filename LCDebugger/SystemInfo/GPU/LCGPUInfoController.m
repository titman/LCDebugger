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

#import <GLKit/GLKit.h>
#import "LCLog.h"
#import "LCGPUInfo.h"
#import "LCGPUInfoController.h"

@interface LCGPUInfoController()
@property (nonatomic, strong) LCGPUInfo *gpuInfo;
@end

@implementation LCGPUInfoController
@synthesize gpuInfo;

/*
 * TIP: that's how we should fetch info about GPU.
 
 NSString *extensionStr = [NSString stringWithCString:glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
 NSArray *arr = [extensionStr componentsSeparatedByString:@" "];
 */

- (LCGPUInfo*)getGPUInfo
{
    if (!gpuInfo)
    {
        // TODO: this needs to go elsewhere.
        // Maybe when we will start to utilize OpenGL for our drawings.
        EAGLContext *ctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:ctx];
        
        self.gpuInfo = [[LCGPUInfo alloc] init];
        self.gpuInfo.gpuName = [NSString stringWithCString:(const char*)glGetString(GL_RENDERER) encoding:NSASCIIStringEncoding];
        self.gpuInfo.openGLVendor = [NSString stringWithCString:(const char*)glGetString(GL_VENDOR) encoding:NSASCIIStringEncoding];
        self.gpuInfo.openGLVersion = [NSString stringWithCString:(const char*)glGetString(GL_VERSION) encoding:NSASCIIStringEncoding];
        
        NSString *extensions = [NSString stringWithCString:(const char*)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
        NSMutableArray *extArray = [NSMutableArray arrayWithArray:[extensions componentsSeparatedByString:@" "]];
        // Last object is always empty because of trailing space.
        [extArray removeLastObject];
        [extArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        self.gpuInfo.openGLExtensions = extArray;
    
        GLenum glError = glGetError();
        if (glError != GL_NO_ERROR)
        {
            ERROR(@"glGetError() == %d", glError);
        }
    }
    
    return gpuInfo;
}

@end
