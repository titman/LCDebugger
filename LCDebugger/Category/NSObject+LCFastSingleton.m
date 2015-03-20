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

#import "NSObject+LCFastSingleton.h"
#import "LCLog.h"

static NSMutableDictionary * __instanceDatasource = nil;

@implementation NSObject (LCFastSingleton)

+(instancetype) LC_SINGLETON_CUSTOM_METHOD_NAME
{
    return [self LCSingleton];
}

+(instancetype) LCSingleton
{
    @synchronized(__instanceDatasource){
        
        NSMutableDictionary * datasource = self.shareInstanceDatasource;
        
        NSString * selfClass = [[self class] description];
        
        id __singleton__ = datasource[selfClass];
        
        if (datasource[selfClass]) {
            return __singleton__;
        }
        
        __singleton__ = [[self alloc] init];
        
        [self setObjectToInstanceDatasource:__singleton__];
        
        //INFO(@"[LCFastSingleton] %@ singleton inited.",[__singleton__ class]);
        
        return __singleton__;
        
    }
}

+(NSMutableDictionary *) shareInstanceDatasource
{
    @synchronized(__instanceDatasource){
        
        if (!__instanceDatasource) {
            __instanceDatasource = [[NSMutableDictionary alloc] init];
        }
    }
    
    return __instanceDatasource;
}

+(BOOL) setObjectToInstanceDatasource:(id)object
{
    NSString * objectClass = [[object class] description];
    
    if (!object) {
        ERROR(@"Instence init fail.");
        return NO;
    }
    
    if (!objectClass) {
        ERROR(@"Instence class error.");
        return NO;
    }
    
    self.shareInstanceDatasource[objectClass] = object;
    
    return YES;
}

-(NSString *) CMDSee:(NSString *)cmd
{
    NSDictionary * datasource = [[self class] shareInstanceDatasource];
    
    if (!datasource || datasource.allKeys.count == 0) {
        return @"No singleton, or not use NSObject+LCFastSingleton.";
    }
    
    NSMutableString * info = [NSMutableString stringWithFormat:@"   * count : %@\n", @(datasource.allKeys.count)];
    
    for (NSString * key in datasource.allKeys) {
        
        NSString * oneInfo = datasource[key];
        
        [info appendFormat:@"  * %@\n",[oneInfo class]];
    }
    
    return info;
}

@end
