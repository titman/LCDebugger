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
#import <GLKit/GLKit.h>

@interface LCGLLineGraph : GLKViewController
@property (nonatomic, strong) GLKBaseEffect *effect;
/* Graph boundaries determined based on projection and viewport. */
@property (nonatomic, assign) GLfloat       graphBottom;
@property (nonatomic, assign) GLfloat       graphTop;
@property (nonatomic, assign) GLfloat       graphRight;
@property (nonatomic, assign) GLfloat       graphLeft;

@property (assign, nonatomic) BOOL          useClosestMetrics;

- (id)initWithGLKView:(GLKView*)aGLView
        dataLineCount:(NSUInteger)count
            fromValue:(double)from
              toValue:(double)to
              topLegend:(NSString*)aLegend;

- (void)setDataLineLegendPostfix:(NSString*)postfix;
- (void)setDataLineLegendFraction:(NSUInteger)desiredFraction;
- (void)setDataLineLegendIcon:(UIImage*)image forLineIndex:(NSUInteger)lineIndex;

- (void)addDataValue:(NSArray*)data;
- (void)setGraphLegend:(NSString*)aLegend;
- (void)setZoomLevel:(GLfloat)value;
- (void)resetDataArray:(NSArray*)dataArray;
- (NSUInteger)requiredElementToFillGraph;
@end
