//
//  TMTutorialViewController.m
//  Trafic Montréal
//
//  Created by Julien Saad on 2014-06-25.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMTutorialViewController.h"

@interface TMTutorialViewController ()

@end

@implementation TMTutorialViewController


-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
    int index = carousel.currentItemIndex;
    if(index==0){
        _crumbs.image = [UIImage imageNamed:@"crumb1.png"];
    }else if(index==1){
        _crumbs.image = [UIImage imageNamed:@"crumb2.png"];
    }else if(index==2){
        _crumbs.image = [UIImage imageNamed:@"crumb3.png"];
    }
    
    NSLog(@"index: %d", index);
    
    
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    UIImageView* phone = nil;
    
    UIImageView* slide3 = nil;
    
    UILabel * descriptionLabel = nil;
    
    UIButton* startBtn = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 263.0f, 429.0f)];
       
        view.contentMode = UIViewContentModeCenter;
        
        ((UIImageView*)view).image = [UIImage imageNamed:@"whitebox.png"];
     
        
        // Title label
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 263, 40)];
        label.backgroundColor = [UIColor clearColor];
        
        label.textColor = UIColorFromRGB(0x6acdd8);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Ubuntu-Medium" size:18];
        label.tag = 1;
        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];
        
        // Description label
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 351, 203, 40)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        
        descriptionLabel.textColor = UIColorFromRGB(0x546470);
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont fontWithName:@"Ubuntu-Light" size:13.0f];
        descriptionLabel.tag = 3;
        descriptionLabel.numberOfLines = 2;
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
        [view addSubview:descriptionLabel];
        
        
        // Phone image
        phone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone2.png"]];
        [view addSubview:phone];
        phone.tag = 2;
        
        float phoneWidth = phone.frame.size.width;
        float phoneHeight = phone.frame.size.height;
        float viewWidth = view.frame.size.width;

        phone.frame = CGRectMake(viewWidth/2-phoneWidth/2, 30, phoneWidth, phoneHeight);
        
        
        slide3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide3Content.png"]];
        
        slide3.frame = CGRectMake(viewWidth/2-slide3.frame.size.width/2, 42, slide3.frame.size.width, slide3.frame.size.height);
        slide3.hidden = YES;
        [view addSubview: slide3];
       
        if(!ISIPHONE5){
            startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame = CGRectMake(15, 370, view.frame.size.width-30, _startBtn.frame.size.height);
            [startBtn setBackgroundImage:[UIImage imageNamed:@"start-btn.png"] forState:UIControlStateNormal];
            [startBtn setTitle:[START uppercaseString] forState:UIControlStateNormal];
            startBtn.tag = 4;
            startBtn.titleLabel.font = [UIFont fontWithName:@"Ubuntu-Medium" size:15.0f];
            startBtn.hidden = YES;
            [view addSubview: startBtn];
            startBtn.enabled = YES;
            view.clipsToBounds = YES;
            [startBtn addTarget:self action:@selector(exitTutorial:) forControlEvents:UIControlEventTouchUpInside];
          
            
            [view bringSubviewToFront:startBtn];
        }
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        phone = (UIImageView*)[view viewWithTag:2];
        descriptionLabel = (UILabel*)[view viewWithTag:3];
        startBtn = (UIButton*)[view viewWithTag:4];

    }
    
    view.userInteractionEnabled = YES;
    descriptionLabel.text = @" GJRIOEGJRIOEGJRIEOJGIORE jgerklg rejklg jrekl grejkl ";
    switch (index) {
        case 0:
            label.text = @"Notre Mission";
            break;
        case 1:
            
            phone.image = [UIImage imageNamed:@"iphone1.png"];
            [view addSubview: phone];
            label.text = @"Notre Mission";
            break;
        
        default:
            slide3.hidden = NO;
            descriptionLabel.hidden = YES;
            phone.hidden = YES;
            
            if(!ISIPHONE5){
                startBtn.hidden = NO;
            }
            break;
    }
   
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.4f;
    }
    return value;
}


-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 3;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    if(!ISIPHONE5){
        CGRect fr =  _crumbs.frame;
        fr.origin.y -=14;
        _crumbs.frame = fr;
        // _startBtn.frame = fr;
        //_startBtn.hidden = YES;
        
        // [_carousel addSubview:_startBtn];
        //[_carousel bringSubviewToFront:_startBtn];
        
    }
    [self.view layoutIfNeeded];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_startBtn addTarget:self action:@selector(exitTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setTitle:START forState:UIControlStateNormal];
    [[_startBtn titleLabel]setFont:[UIFont fontWithName:@"Ubuntu-Medium" size:15.0f]];
    // carousel setup
    
   
    _carousel.bounces = YES;
    _carousel.decelerationRate = 0.05;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)exitTutorial:(id)sender{
    [self performSegueWithIdentifier:@"start" sender:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
