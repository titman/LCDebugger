//
//  LCWebBackstageTableView.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/19.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCWebBackstageTableView.h"
#import "LCWebServer.h"
#import "LCDebuggerImport.h"
#import "UIDevice+Reachability.h"

@interface LCWebBackstageTableView () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation LCWebBackstageTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Switch"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Switch"];
            
            
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = cell.backgroundColor;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            UISwitch * switchControl = [[UISwitch alloc] init];
            [switchControl sizeToFit];
            switchControl.viewFrameX = LC_DEVICE_WIDTH - 10 - switchControl.viewFrameWidth;
            switchControl.viewFrameY = 22 - switchControl.viewMidHeight;
            switchControl.tag = 102;
            [switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchControl];
        }

        cell.textLabel.text = @"Web backstage switch";
        
        UISwitch * switchControl = (UISwitch *)[cell viewWithTag:102];
        switchControl.on = LCWebServer.LCS.isRunning;
    }
    else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Text"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Text"];
            
            
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = cell.backgroundColor;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            UILabel * label = [[UILabel alloc] init];
            label.frame = CGRectMake(LC_DEVICE_WIDTH / 2 - 30, 0, LC_DEVICE_WIDTH/2 - 20 + 30, 44);
            label.tag = 102;
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            label.textAlignment = NSTextAlignmentRight;
            label.adjustsFontSizeToFitWidth = YES;
            [cell addSubview:label];
        }

        cell.textLabel.text = @"Http address";
        
        UILabel * label = (UILabel *)[cell viewWithTag:102];
        label.text = [NSString stringWithFormat:@"http://%@:%@", [UIDevice localIPAddress], @(LCWebServer.LCS.port)];

    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void) switchAction:(UISwitch *)control
{
    if (control.on) {
        [LCWebServer.LCS start];
    }
    else{
        [LCWebServer.LCS stop];
    }
}

@end
