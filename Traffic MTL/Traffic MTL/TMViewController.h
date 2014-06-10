//
//  TMViewController.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *champlainLabel;
@property (weak, nonatomic) IBOutlet UILabel *victoriaLabel;
@property (weak, nonatomic) IBOutlet UILabel *jcLabel;
@property (weak, nonatomic) IBOutlet UIView *b1Frame;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)versMtlClick:(id)sender;
- (IBAction)versBanlieueClick:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *colorFilter;
@property (weak, nonatomic) IBOutlet UIButton *b1;

@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIView *montrealBar;
@property (weak, nonatomic) IBOutlet UIView *banlieuBar;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property NSMutableArray* statusBarImages;

@end
