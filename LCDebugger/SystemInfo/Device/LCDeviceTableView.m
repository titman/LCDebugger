//
//  LCDeviceTableView.m
//  LCDebuggerDemo
//
//  Created by Licheng Guo . http://nsobject.me/ on 15/3/13.
//  Copyright (c) 2015年 Licheng Guo . http://nsobject.me/. All rights reserved.
//

#import "LCDebuggerImport.h"
#import "LCDeviceTableView.h"
#import "LCDevice.h"

@interface LCDeviceTableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * values;
@property (nonatomic, strong) NSMutableArray * titles;

@end

@implementation LCDeviceTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

-(void) buildUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.titles = [@[] mutableCopy];
    [self.titles addObject:@"Device"];
    [self.titles addObject:@"Hostname"];
    [self.titles addObject:@"Screen Resolution"];
    [self.titles addObject:@"Screen Size"];
    [self.titles addObject:@"Retina"];
    [self.titles addObject:@"Retina HD"];
    [self.titles addObject:@"Pixel Density"];
    [self.titles addObject:@"Aspect Ratio"];
    [self.titles addObject:@"OS"];
    [self.titles addObject:@"OS Type"];
    [self.titles addObject:@"OS Version"];
    [self.titles addObject:@"OS Build"];
    [self.titles addObject:@"OS Revision"];
    [self.titles addObject:@"Kernel Info"];
    [self.titles addObject:@"Safe Boot"];
    [self.titles addObject:@"Boot Time"];
    [self.titles addObject:@"Uptime"];
    [self.titles addObject:@"Max Index Nodes"];
    [self.titles addObject:@"Max Processes"];
    [self.titles addObject:@"Max Files"];
    
    self.values = [@[] mutableCopy];
    [self.values addObject:[NSString stringWithFormat:@"Apple %@", LCDevice.LCS.deviceInfo.deviceName]];
    [self.values addObject:LCDevice.LCS.deviceInfo.hostName];
    [self.values addObject:LCDevice.LCS.deviceInfo.screenResolution];
    [self.values addObject:[NSString stringWithFormat:@"%.1f",LCDevice.LCS.deviceInfo.screenSize]];
    [self.values addObject:(LCDevice.LCS.deviceInfo.retina ? @"Yes" : @"No")];
    [self.values addObject:(LCDevice.LCS.deviceInfo.retinaHD ? @"Yes" : @"No")];
    [self.values addObject:[NSString stringWithFormat:@"%ld ppi", (long)LCDevice.LCS.deviceInfo.ppi]];
    [self.values addObject:LCDevice.LCS.deviceInfo.aspectRatio];
    [self.values addObject:LCDevice.LCS.deviceInfo.osName];
    [self.values addObject:LCDevice.LCS.deviceInfo.osType];
    [self.values addObject:LCDevice.LCS.deviceInfo.osVersion];
    [self.values addObject:LCDevice.LCS.deviceInfo.osBuild];
    [self.values addObject:[NSString stringWithFormat:@"%ld", (long)LCDevice.LCS.deviceInfo.osRevision]];
    [self.values addObject:LCDevice.LCS.deviceInfo.kernelInfo];
    [self.values addObject:(LCDevice.LCS.deviceInfo.safeBoot ? @"Yes" : @"No")];
    [self.values addObject:[self formatBootTime:LCDevice.LCS.deviceInfo.bootTime]];
    [self.values addObject:[self formatUptime:LCDevice.LCS.deviceInfo.bootTime]];
    [self.values addObject:[NSString stringWithFormat:@"%ld", (long)LCDevice.LCS.deviceInfo.maxVNodes]];
    [self.values addObject:[NSString stringWithFormat:@"%ld", (long)LCDevice.LCS.deviceInfo.maxProcesses]];
    [self.values addObject:[NSString stringWithFormat:@"%ld", (long)LCDevice.LCS.deviceInfo.maxFiles]];
    
    [self reloadData];
}

- (NSString*)formatBootTime:(time_t)time
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:date];
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %ld:%02ld:%02ld",
                            (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    return dateString;
}

- (NSString*)formatUptime:(time_t)bootTime
{
    NSDate *fromDate = [[NSDate alloc] initWithTimeIntervalSince1970:bootTime];
    
    NSDate *toDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:fromDate toDate:toDate options:0];
    NSString *dateString = [NSString stringWithFormat:@"%ld days %ld:%02ld:%02ld",
                            (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    return dateString;
}

#pragma mark -

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = cell.backgroundColor;
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2 - 20, 44);
        label.tag = 102;
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    }
    
    UILabel * label = (UILabel *)[cell viewWithTag:102];
    label.text = self.values[indexPath.row];
    
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}


@end
