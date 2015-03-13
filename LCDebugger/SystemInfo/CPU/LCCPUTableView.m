//
//  CPUViewController.m
//  System Monitor
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013 Arvydas Sidorenko
//

#import "LCDebuggerImport.h"
#import <GLKit/GLKit.h>
#import "LCGLLineGraph.h"
#import "LCUtils.h"
#import "LCCPUInfoController.h"
#import "LCCPUTableView.h"
#import "LCDevice.h"
#import "LCDeviceSpecificUI.h"

@interface LCCPUTableView() <LCCPUInfoControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) GLKView       *cpuUsageGLView;
@property (nonatomic, strong) LCGLLineGraph   *glGraph;

@property (nonatomic, strong) NSMutableArray * values;
@property (nonatomic, strong) NSMutableArray * titles;

@end

@implementation LCCPUTableView

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

- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.titles = [@[] mutableCopy];
    [self.titles addObject:@"CPU Name"];
    [self.titles addObject:@"Architecture"];
    [self.titles addObject:@"Physical Cores"];
    [self.titles addObject:@"Logical Cores"];
    [self.titles addObject:@"Max Logical Cores"];
    [self.titles addObject:@"Frequency"];
    [self.titles addObject:@"L1 I cache"];
    [self.titles addObject:@"L1 D cache"];
    [self.titles addObject:@"L2 cache"];
    [self.titles addObject:@"Endianess"];

    self.values = [@[] mutableCopy];
    
    LCDevice * device = LCDevice.LCS;
    
    [self.values addObject:device.cpuInfo.cpuName];;
    [self.values addObject:device.cpuInfo.cpuSubtype];;
    [self.values addObject:[NSString stringWithFormat:@"%lu", (unsigned long)device.cpuInfo.physicalCPUCount]];;
    [self.values addObject:[NSString stringWithFormat:@"%lu", (unsigned long)device.cpuInfo.logicalCPUCount]];;
    [self.values addObject:[NSString stringWithFormat:@"%lu", (unsigned long)device.cpuInfo.logicalCPUMaxCount]];;
    [self.values addObject:[NSString stringWithFormat:@"%lu MHz", (unsigned long)device.cpuInfo.cpuFrequency]];;
    [self.values addObject:(device.cpuInfo.l1ICache == 0 ? @"-" : [LCUtils toNearestMetric:(uint64_t)device.cpuInfo.l1ICache desiredFraction:0])];
    [self.values addObject:(device.cpuInfo.l1DCache == 0 ? @"-" : [LCUtils toNearestMetric:(uint64_t)device.cpuInfo.l1DCache desiredFraction:0])];
    [self.values addObject:(device.cpuInfo.l2Cache == 0 ? @"-" : [LCUtils toNearestMetric:(uint64_t)device.cpuInfo.l2Cache desiredFraction:0])];
    [self.values addObject:device.cpuInfo.endianess];

    
    
    self.cpuUsageGLView = [[GLKView alloc] initWithFrame:CGRectMake(0.0, 0, LCDeviceSpecificUI.LCS.GLdataLineGraphWidth, 200)];
    self.cpuUsageGLView.opaque = NO;
    self.cpuUsageGLView.backgroundColor = [UIColor clearColor];
    
    self.glGraph = [[LCGLLineGraph alloc] initWithGLKView:self.cpuUsageGLView
                                          dataLineCount:1
                                              fromValue:0.0 toValue:100.0
                                                topLegend:@"100%"];
    [self.glGraph setDataLineLegendPostfix:@"%"];
    self.glGraph.preferredFramesPerSecond = kCpuLoadUpdateFrequency;
    
    
    self.tableHeaderView = self.cpuUsageGLView;
    
    [LCCPUInfoController.LCS setCPULoadHistorySize:[self.glGraph requiredElementToFillGraph]];
}

- (void)show
{
    NSArray *cpuLoadArray = [LCCPUInfoController.LCS cpuLoadHistory];
    NSMutableArray *graphData = [NSMutableArray arrayWithCapacity:cpuLoadArray.count];
    CGFloat avr;
    
    for (NSUInteger i = 0; i < cpuLoadArray.count; ++i)
    {
        NSArray *data = cpuLoadArray[i];
        avr = 0;
        
        for (NSUInteger j = 0; j < data.count; ++j)
        {
            LCCPULoad *load = data[j];
            avr += load.total;
        }
        avr /= data.count;
        
        [graphData addObject:@[ @((double)avr) ]];
    }
    
    [self.glGraph resetDataArray:graphData];
    
    LCCPUInfoController.LCS.delegate = self;
    [LCCPUInfoController.LCS startCPULoadUpdatesWithFrequency:2];
}

- (void)hide
{
    LCCPUInfoController.LCS.delegate = nil;
}

#pragma mark - Table view data source

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


#pragma mark - CPUInfoController delegate

- (void)cpuLoadUpdated:(NSArray *)loadArray
{
    CGFloat avr = 0;
    
    for (LCCPULoad *load in loadArray)
    {
        avr += load.total;
    }
    avr /= loadArray.count;
    
    [self.glGraph addDataValue:@[ @(avr) ]];
}

@end
