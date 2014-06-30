//
//  DemoMenuController.m
//  Demo
//
//  Created by honcheng on 26/10/12.
//  Copyright (c) 2012 Hon Cheng Muh. All rights reserved.
//
//
#import "DemoMenuController.h"

@interface DemoMenuController ()

@end

@implementation DemoMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setOnlyAllowEdgeDrag:NO];
       
    UIView *tableBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [tableBgView setBackgroundColor:BLUECOLOR];
    [self.menuTableView setBackgroundView:tableBgView];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self reloadMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.menuTableView)
    {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [[cell textLabel] setTextColor:[UIColor whiteColor]];
            [[cell textLabel] setHighlightedTextColor:[UIColor whiteColor]];
            [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *sBgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cellBg.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
            [cell setSelectedBackgroundView:sBgView];
            
            cell.backgroundColor = [UIColor clearColor];
        
        }
        
        if(indexPath.row ==1){
            [cell setSelected:YES];
        }
        //UIViewController *viewController = self.viewControllers[indexPath.row];
        
        [cell.textLabel setText:@"Rive Sud"];
        cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Light" size:15.0f];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        switch (indexPath.row) {
            case 0:
                [cell.textLabel setText:@""];
                cell.hidden = YES;
                break;
            case 1:
                [cell.textLabel setText:@"Rive Sud"];
                break;
            case 2:
                [cell.textLabel setText:@"Rive Nord"];
            case 3:
                [cell.textLabel setText:(ISFRENCH?@"English":@"Français")];
            default:
                break;
        }
        
        if (indexPath.row == self.selectedIndex)
        {
            //[tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            NSLog(@"SELECTED");
        }
       
        
        return cell;
    }
    else
    {
        return nil;
    }
}


@end
