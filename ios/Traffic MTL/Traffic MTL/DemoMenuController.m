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
    
    [self.menuTableView setContentInset:UIEdgeInsetsMake(20,0,0,0)];
    [self.menuTableView scrollRectToVisible:CGRectMake(0, 0, 320, 20) animated:NO];
    
    [self reloadMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel* textLabel;
    UIImageView* btn;
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
            
            textLabel = [[UILabel alloc] initWithFrame:cell.textLabel.frame];
            
            CGRect textFrame = textLabel.frame;
            textFrame.origin.y += 57;
            textFrame.size.width = 100;
            textFrame.size.height = 30;
            textLabel.frame = textFrame;
            textLabel.textColor = [UIColor whiteColor];
            
            
            
            textLabel.font = [UIFont fontWithName:@"Ubuntu-Medium" size:10.0f];
            textLabel.numberOfLines = 2;
            textLabel.adjustsFontSizeToFitWidth = YES;
            textLabel.textAlignment = NSTextAlignmentCenter;
            
            btn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"riveNord.png"]];
            [cell addSubview:btn];
            
            btn.frame = CGRectMake(27,20, btn.frame.size.width,btn.frame.size.height);
            
            [btn setTag:13];
            [cell addSubview:textLabel];
            [textLabel setTag:12];

        
        }else{
            btn = (UIImageView*)[cell viewWithTag:13];
            textLabel = (UILabel*)[cell viewWithTag:12];
        }
        
        //UIViewController *viewController = self.viewControllers[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                [textLabel setText:[lRIVE_NORD uppercaseString]];
                btn.image = [UIImage imageNamed:@"riveNord.png"];
                break;
            case 1:
                [textLabel setText:[lRIVE_SUD uppercaseString]];
                btn.image = [UIImage imageNamed:@"riveSud.png"];
                break;
            case 2:
                [textLabel setText:[lHELP uppercaseString]];
                btn.image = [UIImage imageNamed:@"info.png"];
                
                break;
            case 3:
            case 4:
                btn.hidden = YES;
                cell.userInteractionEnabled = NO;
                break;
            case 5:
               
                [textLabel setText:[(ISFRENCH?@"English":@"Français") uppercaseString]];
                if(ISFRENCH){
                    btn.image = [UIImage imageNamed:@"english.png"];
                }else{
                    btn.image = [UIImage imageNamed:@"francais.png"];
                }
                break;
                
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
