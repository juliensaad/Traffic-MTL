//
//  BridgeCell.h
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BridgeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *icon;
@property (weak, nonatomic) IBOutlet UILabel *bridgeName;
@property (weak, nonatomic) IBOutlet UILabel *delay;
@property (weak, nonatomic) IBOutlet UILabel *avecTraffic;
@property (weak, nonatomic) IBOutlet UILabel *normal;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *colorFilter;

@end
