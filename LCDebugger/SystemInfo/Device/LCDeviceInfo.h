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

@interface LCDeviceInfo : NSObject
@property (nonatomic, copy)   const NSString    *deviceName;
@property (nonatomic, copy)   NSString          *hostName;
@property (nonatomic, copy)   NSString          *osName;
@property (nonatomic, copy)   NSString          *osType;
@property (nonatomic, copy)   NSString          *osVersion;
@property (nonatomic, copy)   NSString          *osBuild;
@property (nonatomic, assign) NSInteger         osRevision;
@property (nonatomic, copy)   NSString          *kernelInfo;
@property (nonatomic, assign) NSUInteger        maxVNodes;
@property (nonatomic, assign) NSUInteger        maxProcesses;
@property (nonatomic, assign) NSUInteger        maxFiles;
@property (nonatomic, assign) NSUInteger        tickFrequency;
@property (nonatomic, assign) NSUInteger        numberOfGroups;
@property (nonatomic, assign) time_t            bootTime;
@property (nonatomic, assign) BOOL              safeBoot;

@property (nonatomic, copy)   NSString          *screenResolution;
@property (nonatomic, assign) CGFloat           screenSize;
@property (nonatomic, assign) BOOL              retina;
@property (nonatomic, assign) BOOL              retinaHD;
@property (nonatomic, assign) NSUInteger        ppi;
@property (nonatomic, copy)   NSString          *aspectRatio;
@end
