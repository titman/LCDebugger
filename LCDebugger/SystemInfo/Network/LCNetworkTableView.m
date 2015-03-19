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
#import "LCNetworkTableView.h"
#import "LCGLLineGraph.h"
#import "LCNetworkInfoController.h"
#import "LCDeviceSpecificUI.h"
#import "LCUtils.h"
#import "LCDevice.h"
#import <Foundation/Foundation.h>

enum {
    SECTION_NETWORK_INFORMATION=0
};

static const CGFloat kNetworkGraphMaxValue = MB_TO_B(100);

@interface LCNetworkTableView () <UITableViewDelegate,UITableViewDataSource,LCNetworkInfoControllerDelegate>

@property (nonatomic, strong) LCGLLineGraph * networkGraph;
@property (nonatomic, strong) GLKView * networkGLView;
@property (nonatomic, strong) LCNetworkBandwidth * bandwidh;

@property(nonatomic, strong) NSMutableArray * titles;
@property(nonatomic, strong) NSMutableArray * values;

@end

@implementation LCNetworkTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.titles = [@[] mutableCopy];
        [self.titles addObject:@"Network Type"];
        [self.titles addObject:@"External IP"];
        [self.titles addObject:@"Internal IP"];
        [self.titles addObject:@"Netmask"];
        [self.titles addObject:@"Broadcast IP"];
        [self.titles addObject:@"WiFi Download"];
        [self.titles addObject:@"WiFi Upload"];
        [self.titles addObject:@"Cellular Download"];
        [self.titles addObject:@"Cellular Upload"];

        
        self.networkGLView = [[GLKView alloc] initWithFrame:CGRectMake(0.0, 30.0, LCDeviceSpecificUI.LCS.GLdataLineGraphWidth, 200.0)];
        self.networkGLView.opaque = NO;
        self.networkGLView.backgroundColor = [UIColor clearColor];
        self.networkGraph = [[LCGLLineGraph alloc] initWithGLKView:self.networkGLView dataLineCount:2 fromValue:0.0 toValue:kNetworkGraphMaxValue topLegend:@" 0 B/s"];
        self.networkGraph.useClosestMetrics = YES;
        [self.networkGraph setDataLineLegendFraction:1];
        [self.networkGraph setDataLineLegendPostfix:@"/s"];
        self.networkGraph.preferredFramesPerSecond = 1;
        
        [LCNetworkInfoController.LCS setNetworkBandwidthHistorySize:[self.networkGraph requiredElementToFillGraph]];
        
        [self updateLabels:LCNetworkInfoController.LCS.networkBandwidthHistory.lastObject];
        [self updateGraphZoomLevel];

        [self show];
        
        self.tableHeaderView = self.networkGLView;
     
    }
    
    return self;
}

-(void) buildUI
{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

-(void) show
{
    // Make sure the labels are not empty.
    LCNetworkBandwidth *bandwidth = [LCNetworkInfoController.LCS.networkBandwidthHistory lastObject];
    
    if (bandwidth)
    {
        [self updateLabels:bandwidth];
    }
    
    NSMutableArray *bandwidthArray = [[NSMutableArray alloc] initWithCapacity:LCNetworkInfoController.LCS.networkBandwidthHistory.count];
    NSArray *bandwidthHistory = [NSArray arrayWithArray:LCNetworkInfoController.LCS.networkBandwidthHistory];
    
    for (NSUInteger i = 0; i < bandwidthHistory.count; ++i)
    {
        LCNetworkBandwidth *bandwidth = bandwidthHistory[i];
        NSNumber *upValue = @(bandwidth.sent);
        NSNumber *downValue = @(bandwidth.received);
        [bandwidthArray addObject:@[upValue, downValue]];
    }
    [self.networkGraph resetDataArray:bandwidthArray];
    
    LCNetworkInfoController.LCS.delegate = self;
    [LCNetworkInfoController.LCS startNetworkBandwidthUpdatesWithFrequency:1];
}


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

- (void)networkBandwidthUpdated:(LCNetworkBandwidth*)bandwidth
{
    [self updateLabels:bandwidth];
    
//    NSString *upValue = [NSString stringWithFormat:@"↑ %@",@(bandwidth.sent)];
//    NSString *downValue = [NSString stringWithFormat:@"↓ %@",@(bandwidth.received)];
    [self.networkGraph addDataValue:@[@(bandwidth.sent), @(bandwidth.received)]];
}

- (void)networkStatusUpdated
{
    [self updateLabels:nil];
}

- (void)networkExternalIPAddressUpdated
{
    [self updateLabels:nil];
}

- (void)networkMaxBandwidthUpdated
{
    [self updateGraphZoomLevel];
}

- (void)updateLabels:(LCNetworkBandwidth *)bandwidth
{
    if (bandwidth) {
        self.bandwidh = bandwidth;
    }
    
    self.values = [@[] mutableCopy];
    [self.values addObject:LCDevice.LCS.networkInfo.readableInterface];
    [self.values addObject:LCDevice.LCS.networkInfo.externalIPAddress];
    [self.values addObject:LCDevice.LCS.networkInfo.internalIPAddress];
    [self.values addObject:LCDevice.LCS.networkInfo.netmask];
    [self.values addObject:LCDevice.LCS.networkInfo.broadcastAddress];
    [self.values addObject:[LCUtils toNearestMetric:self.bandwidh.totalWiFiReceived desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:self.bandwidh.totalWiFiSent desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:self.bandwidh.totalWWANReceived desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:self.bandwidh.totalWWANSent desiredFraction:1]];
    
    [self reloadData];
}

- (void)updateGraphZoomLevel
{
    GLfloat zoomLevel = MAX(LCNetworkInfoController.LCS.currentMaxSentBandwidth, LCNetworkInfoController.LCS.currentMaxReceivedBandwidth) / kNetworkGraphMaxValue;
    zoomLevel = MAX(zoomLevel, FLT_MIN); // Make sure it's not 0
    GLfloat topValue = kNetworkGraphMaxValue * zoomLevel;
    [self.networkGraph setZoomLevel:zoomLevel];
    [self.networkGraph setGraphLegend:[NSString stringWithFormat:@"%@/s", [LCUtils toNearestMetric:topValue desiredFraction:0]]];
}


@end
