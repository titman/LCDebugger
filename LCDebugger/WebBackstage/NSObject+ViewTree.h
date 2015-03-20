//
//  NSObject+ViewTree.h
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-6-25.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ViewTree)

- (NSMutableDictionary *)toDict;

- (void)fromDict:(NSDictionary *)dict;

@end
