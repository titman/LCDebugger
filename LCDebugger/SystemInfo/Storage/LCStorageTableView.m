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
#import "LCStorageTableView.h"
#import "LCDevice.h"
#import "LCUtils.h"
#import "LCStorageInfoController.h"

@interface LCStorageTableView () <UITableViewDataSource,UITableViewDelegate,LCStorageInfoControllerDelegate>

@property(nonatomic, strong) NSMutableArray * titles;
@property(nonatomic, strong) NSMutableArray * values;

@end

@implementation LCStorageTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        
        self.titles = [@[] mutableCopy];
        [self.titles addObject:@"Total Available"];
        [self.titles addObject:@"Free"];
        [self.titles addObject:@"Used"];
        [self.titles addObject:@"Number of Songs"];
        [self.titles addObject:@"Number of Pictures"];
        [self.titles addObject:@"Number of Videos"];

        LCStorageInfoController.LCS.delegate = self;
        
        [LCDevice.LCS refreshStorageInfo];
        
        [self updateInfoLabels];
    }
    
    return self;
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

-(void) updateInfoLabels
{
    self.values = [@[] mutableCopy];
    [self.values addObject:[LCUtils toNearestMetric:LCDevice.LCS.storageInfo.totalSapce desiredFraction:2]];
    [self.values addObject:[LCUtils toNearestMetric:LCDevice.LCS.storageInfo.freeSpace desiredFraction:2]];
    [self.values addObject:[LCUtils toNearestMetric:LCDevice.LCS.storageInfo.usedSpace desiredFraction:2]];
    [self.values addObject:[NSString stringWithFormat:@"%lu",(unsigned long)LCDevice.LCS.storageInfo.songCount]];
    [self.values addObject:[NSString stringWithFormat:@"%lu (%@)", (unsigned long)LCDevice.LCS.storageInfo.pictureCount, [LCUtils toNearestMetric:LCDevice.LCS.storageInfo.totalPictureSize desiredFraction:1]]];
    [self.values addObject:[NSString stringWithFormat:@"%lu (%@)", (unsigned long)LCDevice.LCS.storageInfo.videoCount, [LCUtils toNearestMetric:LCDevice.LCS.storageInfo.totalVideoSize desiredFraction:1]]];
    
    [self reloadData];
}

- (void)storageInfoUpdated
{
    [self updateInfoLabels];
}

@end
