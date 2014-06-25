//
//  TMTutorialViewController.h
//  Trafic Montréal
//
//  Created by Julien Saad on 2014-06-25.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iCarousel.h"

@interface TMTutorialViewController : UIViewController<iCarouselDataSource, iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIImageView *crumbs;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end
