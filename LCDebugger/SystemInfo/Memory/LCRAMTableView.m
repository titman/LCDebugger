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
#import "LCRAMTableView.h"
#import "LCRAMInfoController.h"
#import "LCDevice.h"
#import "LCUtils.h"
#import "LCGLLineGraph.h"
#import "LCDeviceSpecificUI.h"

@interface LCRAMTableView ()<UITableViewDataSource,UITableViewDelegate,LCRAMInfoControllerDelegate>

@property (nonatomic, strong) GLKView       *ramUsageGLView;
@property (nonatomic, strong) LCGLLineGraph   *glGraph;

@property (nonatomic, strong) NSMutableArray * values;
@property (nonatomic, strong) NSMutableArray * titles;

@end

@implementation LCRAMTableView

-(void) dealloc
{
    [LCRAMInfoController LCS].delegate = nil;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildUI];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.ramUsageGLView = [[GLKView alloc] initWithFrame:CGRectMake(0.0, 30.0, LCDeviceSpecificUI.LCS.GLdataLineGraphWidth, 200.0)];
        self.ramUsageGLView.opaque = NO;
        self.ramUsageGLView.backgroundColor = [UIColor clearColor];
        
        self.glGraph = [[LCGLLineGraph alloc] initWithGLKView:self.ramUsageGLView
                                              dataLineCount:1
                                                  fromValue:0.0
                                                    toValue:LCDevice.LCS.ramInfo.totalRam
                                                  topLegend:[LCUtils toNearestMetric:(uint64_t)LCDevice.LCS.ramInfo.totalRam desiredFraction:0]];
        self.glGraph.useClosestMetrics = YES;
        self.glGraph.preferredFramesPerSecond = kRamUsageUpdateFrequency;
        
        self.tableHeaderView = self.ramUsageGLView;
        
        [LCRAMInfoController.LCS setRAMUsageHistorySize:[self.glGraph requiredElementToFillGraph]];
    }
    
    return self;
}

-(void) buildUI
{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titles = [@[] mutableCopy];
    [self.titles addObject:@"Total Memory"];
    [self.titles addObject:@"Memory Type"];
    [self.titles addObject:@"Wired Memory"];
    [self.titles addObject:@"Active Memory"];
    [self.titles addObject:@"Inactive Memory"];
    [self.titles addObject:@"Free Memory"];
    [self.titles addObject:@"Page Ins"];
    [self.titles addObject:@"Page Outs"];
    [self.titles addObject:@"Page Faults"];
    
    self.values = [@[] mutableCopy];
    
    [self show];
}

- (void)show
{
    [LCRAMInfoController.LCS startRAMUsageUpdatesWithFrequency:1];
    
    // Make sure the labels are not empty.
    LCRAMUsage * usage = [LCRAMInfoController.LCS.ramUsageHistory lastObject];
    
    if (usage)
    {
        [self updateUsageLabels:usage];
    }
    
    NSMutableArray *usageArray = [[NSMutableArray alloc] initWithCapacity:LCRAMInfoController.LCS.ramUsageHistory.count];
    
    NSArray *usageHistory = [NSArray arrayWithArray:LCRAMInfoController.LCS.ramUsageHistory];
    
    for (NSUInteger i = 0; i < usageHistory.count; ++i)
    {
        LCRAMUsage *usage = usageHistory[i];
        [usageArray addObject:@[ @(usage.usedRam) ]];
    }
    
    [self.glGraph resetDataArray:usageArray];
    
    
    LCRAMInfoController.LCS.delegate = self;
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

- (void)updateUsageLabels:(LCRAMUsage*)usage
{
    [self.glGraph addDataValue:@[ @(usage.usedRam) ]];

    self.values = [@[] mutableCopy];
    
    [self.values addObject:[LCUtils toNearestMetric:(uint64_t)LCDevice.LCS.ramInfo.totalRam desiredFraction:0]];
    [self.values addObject:LCDevice.LCS.ramInfo.ramType];
    [self.values addObject:[LCUtils toNearestMetric:usage.wiredRam desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:usage.activeRam desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:usage.inactiveRam desiredFraction:1]];
    [self.values addObject:[LCUtils toNearestMetric:usage.freeRam desiredFraction:1]];
    [self.values addObject:[NSString stringWithFormat:@"%lld", usage.pageIns]];
    [self.values addObject:[NSString stringWithFormat:@"%lld", usage.pageOuts]];
    [self.values addObject:[NSString stringWithFormat:@"%lld", usage.pageFaults]];
    
    [self reloadData];
}

-(void) ramUsageUpdated:(LCRAMUsage*)usage
{
    [self updateUsageLabels:usage];
}


@end
