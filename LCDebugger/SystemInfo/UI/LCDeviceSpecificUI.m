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
#import "LCDeviceSpecificUI.h"
#import "LCLog.h"
#import "LCUtils.h"
#import "LCDeviceInfo.h"
#import "LCDeviceInfoController.h"

@implementation LCDeviceSpecificUI

@synthesize pickViewY;

@synthesize GLdataLineGraphWidth;
@synthesize GLdataLineWidth;

@synthesize GLtubeTextureSheetW;
@synthesize GLtubeTextureSheetH;
@synthesize GLtubeTextureY;
@synthesize GLtubeTextureH;
@synthesize GLtubeTextureLeftX;
@synthesize GLtubeTextureLeftW;
@synthesize GLtubeTextureRightX;
@synthesize GLtubeTextureRightW;
@synthesize GLtubeTextureLiquidX;
@synthesize GLtubeTextureLiquidW;
@synthesize GLtubeTextureLiquidTopX;
@synthesize GLtubeTextureLiquidTopW;
@synthesize GLtubeTextureGlassX;
@synthesize GLtubeTextureGlassW;
@synthesize GLtubeGlowH;
@synthesize GLtubeLiquidTopGlowL;
@synthesize GLtubeGLKViewFrame;


- (id)init
{
    if (self = [super init])
    {
        LCDeviceInfo *deviceInfo = LCDeviceInfoController.LCS.getDeviceInfo;
        LCAssert(deviceInfo != nil, @"deviceInfo == nil");
        
        
        self.pickViewY = [UIScreen mainScreen].bounds.size.height - 276.0;
        
        self.GLdataLineGraphWidth = ([LCUtils isIPhone] ? [UIScreen mainScreen].bounds.size.width : 703.0);
        self.GLdataLineWidth = (deviceInfo.retinaHD ? 4.0 : deviceInfo.retina ? 3.0 : 2.0);
        
        self.GLtubeTextureSheetW = (deviceInfo.retinaHD ? 256.0 : 128.0);
        self.GLtubeTextureSheetH = (deviceInfo.retina ? 256.0 : 128.0);
        self.GLtubeTextureY = (deviceInfo.retinaHD ? 210.0 : deviceInfo.retina ? 140.0 : 93.0);
        self.GLtubeTextureH = (deviceInfo.retinaHD ? 210.0 : deviceInfo.retina ? 140.0 : 93.0);
        self.GLtubeTextureLeftX = 0.0;
        self.GLtubeTextureLeftW = (deviceInfo.retinaHD ? 42.0 : deviceInfo.retina ? 28.0: 21.0);
        self.GLtubeTextureRightX = (deviceInfo.retinaHD ? 42.0 : deviceInfo.retina ? 28.0 : 21.0);
        self.GLtubeTextureRightW = (deviceInfo.retinaHD ? 42.0 : deviceInfo.retina ? 28.0 : 20.0);
        self.GLtubeTextureLiquidX = (deviceInfo.retinaHD ? 86.0 : deviceInfo.retina ? 57.0 : 43.0);
        self.GLtubeTextureLiquidW = 1.0;
        self.GLtubeTextureLiquidTopX = (deviceInfo.retinaHD ? 87.0 : deviceInfo.retina ? 58.0 : 44.0);
        self.GLtubeTextureLiquidTopW = (deviceInfo.retinaHD ? 78.0 : deviceInfo.retina ? 52.0 : 38.0);
        self.GLtubeTextureGlassX = (deviceInfo.retinaHD ? 84.0 : deviceInfo.retina ? 56.0 : 42.0);
        self.GLtubeTextureGlassW = (deviceInfo.retinaHD ? 2.0 : 1.0);
        self.GLtubeGlowH = (deviceInfo.retinaHD ? 40.0 : deviceInfo.retina ? 27.0 : 17.0);
        self.GLtubeLiquidTopGlowL = (deviceInfo.retina ? 5.0 : 0.0);
        self.GLtubeGLKViewFrame = CGRectMake(5.0,
                                             (deviceInfo.retina ? 16.0 : 12.0),
                                             ([LCUtils isIPhone] ? [UIScreen mainScreen].bounds.size.width - 10.0 : 693.0),
                                             self.GLtubeTextureH / [UIScreen mainScreen].scale);
    }
    return self;
}


@end

