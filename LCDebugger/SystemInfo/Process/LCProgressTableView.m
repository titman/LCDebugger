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
#import "LCProgressTableView.h"
#import "LCDevice.h"
#import "LCProcessInfo.h"

@interface LCProgressTableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray * values;

@end

@implementation LCProgressTableView

-(instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [LCDevice.LCS refreshProcesses];
        
        self.values = [NSArray arrayWithArray:LCDevice.LCS.processes];

        
        [self buildUI];
        
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor whiteColor];
    }
    
    return self;
}

-(void) buildUI
{
    self.backgroundColor = [UIColor clearColor];
    
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    enum {
        TAG_ICON_VIEW=1,
        TAG_NAME_LABEL=2,
        TAG_STATUS_LABEL=3,
        TAG_START_TIME_LABEL=4,
        TAG_PID_LABEL=5,
        TAG_PRIORITY_LABEL=6,
        TAG_COMMAND_LINE_LABEL=7
    };
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = cell.backgroundColor;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    
    LCProcessInfo * process = self.values[indexPath.row];

    cell.imageView.image = process.icon;
    
    NSString * id = [NSString stringWithFormat:@"ID: %@\n",@(process.pid)];
    NSString * name = [NSString stringWithFormat:@"Name: %@\n",process.name];
    NSString * priority = [NSString stringWithFormat:@"Priority: %@\n",@(process.priority)];
    NSString * startTime = [NSString stringWithFormat:@"Start time: %@\n",[self formatStartTime:process.startTime]];
    NSString * command = [NSString stringWithFormat:@"Command: %@\n",process.commandLine];

    NSMutableString * string = [NSMutableString string];
    [string appendString:id];
    [string appendString:name];
    [string appendString:priority];
    [string appendString:startTime];
    [string appendString:command];
    
    cell.textLabel.text = string;
    
    cell.imageView.viewFrameX = 10;
    cell.imageView.viewFrameY = 10;
    cell.imageView.viewFrameWidth = 70;
    cell.imageView.viewFrameHeight = 70;
    cell.imageView.layer.cornerRadius = 6;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.backgroundColor = [UIColor whiteColor];

    return cell;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.values.count;
}

- (NSString*)formatStartTime:(time_t)unixTime
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:unixTime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:date];
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %ld:%02ld:%02ld",
                            (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    return dateString;
}


@end
