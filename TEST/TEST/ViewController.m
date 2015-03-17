//
//  ViewController.m
//  TEST
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/13.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [NSThread detachNewThreadSelector:@selector(test) toTarget:self withObject:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) test
{
        for (int i = 0; i< 100000; i++) {
            
            NSString * string = @"AbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbcAbc";
            string = [string lowercaseString];
            string = [string stringByAppendingString:@"xyz"];
            
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
