//
//  LCHandleViewHighlightRequest.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/20.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCDebuggerImport.h"
#import "LCHandleViewHighlightRequest.h"

@interface LCHighlightView : UIView

@end

static LCHighlightView * __highlightView = nil;

@implementation LCHighlightView

- (NSMutableDictionary *)toDict
{
    return nil;
}

-(instancetype) init
{
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.layer.cornerRadius = self.superview.layer.cornerRadius;
}

@end


@implementation LCHandleViewHighlightRequest


-(NSDictionary *) handleRequestPath:(NSString *)path
{
    NSString * param = [path componentsSeparatedByString:@"?"].lastObject;
    
    NSInteger address = [[[param componentsSeparatedByString:@"="] lastObject] integerValue];
    
    UIView * view = [self view:[UIApplication sharedApplication] withAddress:address];
    
    if (view == nil) {
        return @{@"msg":@"can not find the view."};
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!__highlightView) {
            __highlightView = [[LCHighlightView alloc] init];
        }
        
        
        if (view != __highlightView) {
            
            if ([[view subviews] containsObject:__highlightView]) {
                
                [__highlightView removeFromSuperview];
            }
            else{
                
                __highlightView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                [view addSubview:__highlightView];
            }
        }        
    });
    
    return @{@"msg":@"highlight successfully."};
}

- (UIView *)view:(id)obj withAddress:(NSInteger)address
{
    if ([obj isKindOfClass:[UIView class]]) {
        
        UIView *view = (UIView *)obj;
        
        if ((NSInteger)view == address)
        {
            return view;
        }
        
        for (UIView *v in view.subviews)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    if ([obj isKindOfClass:[UIApplication class]]) {
        
        UIApplication *app = (UIApplication *)obj;
        
        for (UIView *v in app.windows)
        {
            UIView *target = [self view:v withAddress:address];
            if (target) {
                return target;
            }
        }
    }
    
    return nil;
}

@end
