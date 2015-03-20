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
