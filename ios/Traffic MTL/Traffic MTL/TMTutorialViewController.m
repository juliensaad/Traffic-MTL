//
//  TMTutorialViewController.m
//  Trafic Montréal
//
//  Created by Julien Saad on 2014-06-25.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMTutorialViewController.h"
#import "TMAppDelegate.h"

@interface TMTutorialViewController ()

@property (nonatomic, strong) DemoMenuController *menuController;

@end

@implementation TMTutorialViewController


-(void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView{
    
    int index = _carousel.currentItemIndex;
    if(index==0){
        _crumbs.image = [UIImage imageNamed:@"crumb1.png"];
    }else if(index==1){
        _crumbs.image = [UIImage imageNamed:@"crumb2.png"];
    }else if(index==2){
        _crumbs.image = [UIImage imageNamed:@"crumb3.png"];
    }else{
        _crumbs.image = [UIImage imageNamed:@"crumb4.png"];
    }
    

}
-(UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UILabel *label = nil;
    UIImageView* phone = nil;
    
    UILabel * descriptionLabel = nil;
    
    UIButton* startBtn = nil;
    
    UIView* thirdView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 429.0f)];
        
        view.contentMode = UIViewContentModeCenter;
        
        //  ((UIImageView*)view).image = [UIImage imageNamed:@"whitebox.png"];
        UILabel* legend =[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 320, 40)];
        legend.text = ISFRENCH?@"Légende":@"Legend";
        legend.textColor = UIColorFromRGB(0xFFFFFF);
        legend.textAlignment = NSTextAlignmentLeft;
        legend.font = [UIFont fontWithName:@"Ubuntu-Light" size:17.0];
        legend.hidden = YES;
        [view addSubview:legend];
        legend.tag = 24;
        
        // Title label
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 320, 40)];
        label.backgroundColor = [UIColor clearColor];
        
        label.textColor = UIColorFromRGB(0x6acdd8);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Ubuntu-Medium" size:18.0];
        label.tag = 1;
        label.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label];
        
        // Description label
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 347, 200, 60)];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        
        descriptionLabel.textColor = UIColorFromRGB(0x546470);
        descriptionLabel.textAlignment = NSTextAlignmentCenter;
        descriptionLabel.font = [UIFont fontWithName:@"Ubuntu-Light" size:15.0f];
        descriptionLabel.tag = 3;
        descriptionLabel.numberOfLines = 11;
        descriptionLabel.adjustsFontSizeToFitWidth = YES;
        [view addSubview:descriptionLabel];
        
        
        // Phone image
        phone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcomeCard.png"]];
        [view addSubview:phone];
        phone.tag = 2;
        
        phone.frame = CGRectMake((320-260)/2, view.frame.origin.y, 260, 424);
        
       
        
        thirdView = [[UIView alloc] initWithFrame:view.frame];
        thirdView.tag = 11;
        
        // Fleches de temps
        UIImageView* temps = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temps.png"]];
        // if(ISIPHONE5)
        //    [thirdView addSubview:temps];
        CGRect fr = temps.frame;
        fr.origin.y += 280;
        fr.origin.x = view.frame.size.width/2-fr.size.width/2;
        temps.frame = fr;
        
        // Description au top
        int posY = 340;
        if(!ISIPHONE5)
            posY = 310;
        UILabel* title3 = [[UILabel alloc] initWithFrame:CGRectMake(45,posY, view.frame.size.width-90, 70)];
        title3.textAlignment = NSTextAlignmentCenter;
        title3.numberOfLines = 3;
        title3.font = [UIFont fontWithName:@"Ubuntu-Light" size:12.5f];
        title3.textColor = UIColorFromRGB(0x546470);
        title3.text = lEVALUATE;
        [thirdView addSubview:title3];
        
        for(int i = 0;i<4;i++){
            UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(63,75+28*i,18,18)];
            circleView.layer.cornerRadius = 2;
            
            UILabel* circleLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 70+28*i, 200, 30)];
            circleLabel.font = [UIFont fontWithName:@"Ubuntu-Medium" size:12.5f];
            circleLabel.textColor = UIColorFromRGB(0x546470);
            switch (i) {
                case 0:
                    circleView.backgroundColor = UIColorFromRGB(0x8ec549);
                    circleLabel.text = ISFRENCH?@"Rapide (>65%)":@"Fast (>65%)";
                    break;
                case 1:
                    circleView.backgroundColor = UIColorFromRGB(0xfdcc17);
                    circleLabel.text = ISFRENCH?@"Ralenti (36% - 65%)":@"Slow (36% - 65%)";
                    break;
                case 2:
                    circleView.backgroundColor = UIColorFromRGB(0xf60d1a);
                    circleLabel.text = @"Congestion (19% - 35%)";
                    break;
                case 3:
                    circleView.backgroundColor = UIColorFromRGB(0xb40610);
                    circleLabel.text = ISFRENCH?@"Congestion majeure (<19%)":@"Major congestion (<19%)";
                    break;
                    
                default:
                    break;
                    
            }
            
            [thirdView addSubview:circleLabel];
            
            [thirdView addSubview:circleView];
        }
        
        UILabel* percent = [[UILabel alloc] initWithFrame:CGRectMake(temps.frame.origin.x+3, 200, 205, 30)];
        percent.font = [UIFont fontWithName:@"Ubuntu" size:12.0f];
        percent.textColor = UIColorFromRGB(0x546470);
        percent.text = lWITHOUTTRAFFIC;
        
        [self addBold:percent withNum:4];

        UILabel* percent2 = [[UILabel alloc] initWithFrame:CGRectMake(temps.frame.origin.x+3, 216, 205, 30)];
        percent2.font = [UIFont fontWithName:@"Ubuntu" size:12.0f];
        percent2.textColor = UIColorFromRGB(0x546470);
        percent2.text = lWITHTRAFFIC;
        [self addBold:percent2 withNum:2];
        
        UILabel* plus = [[UILabel alloc] initWithFrame:CGRectMake(temps.frame.origin.x-0, 320, 205, 50)];
        plus.font = [UIFont fontWithName:@"Ubuntu" size:12.0f];
        plus.textColor = UIColorFromRGB(0x546470);
        plus.text = lPLUS;
        plus.numberOfLines = 2;
        plus.adjustsFontSizeToFitWidth = YES;
        [self addBold:plus withNum:4];
        [thirdView addSubview:percent];
        [thirdView addSubview:percent2];
        // [thirdView addSubview:plus];
        
        [view addSubview:thirdView];
        

        
        
        if(!ISIPHONE5){
            startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame = CGRectMake(42, 370, 233, _startBtn.frame.size.height);
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
        
                [view sendSubviewToBack:phone];
        [view bringSubviewToFront:label];
        [view bringSubviewToFront:descriptionLabel];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
        phone = (UIImageView*)[view viewWithTag:2];
        descriptionLabel = (UILabel*)[view viewWithTag:3];
        startBtn = (UIButton*)[view viewWithTag:4];
        
        
        thirdView = (UIView*)[view viewWithTag:11];

    }
    
    view.userInteractionEnabled = YES;
     CGRect fr = label.frame;
    switch (index) {
        case 0:
            fr.origin.y =210;
            label.frame = fr;

            descriptionLabel.frame = CGRectMake(60, 240, 200, 150);
            descriptionLabel.numberOfLines = 11;
            
            label.text = (ISFRENCH?@"BIENVENUE!":@"WELCOME!");
            descriptionLabel.text = lWELCOME;
            phone.image = [UIImage imageNamed:@"welcomeCard.png"];
            label.hidden = NO;
            phone.hidden = NO;
            startBtn.hidden = YES;
            
            descriptionLabel.hidden = NO;
            thirdView.hidden = YES;
            [(UILabel *)[view viewWithTag:24] setHidden:YES];
            break;
        case 1:
            fr.origin.y =310;
            label.frame = fr;
            

            descriptionLabel.frame = CGRectMake(45, 347, 230, 60);
            
            label.text = lOURMISSION;
            descriptionLabel.text = lMISSION;
            phone.image = [UIImage imageNamed:@"card3.png"];
            label.hidden = NO;
            phone.hidden = NO;
            startBtn.hidden = YES;
            [(UILabel *)[view viewWithTag:24] setHidden:YES];
            descriptionLabel.hidden = NO;
            thirdView.hidden = YES;
            break;
        case 2:
            fr.origin.y =310;
            label.frame = fr;
            
            descriptionLabel.frame =CGRectMake(45, 347, 230, 60);

            
            label.text = lOURSTRATEGY;
            descriptionLabel.text = lSTRATEGY;
            phone.image = [UIImage imageNamed:@"card2.png"];
            label.hidden = NO;
            phone.hidden = NO;
            [(UILabel *)[view viewWithTag:24] setHidden:YES];
            descriptionLabel.hidden = NO;
            startBtn.hidden = YES;
            thirdView.hidden = YES;
            break;
            
        case 3:
            [(UILabel *)[view viewWithTag:24] setHidden:NO];
            if(ISIPHONE5){
                label.hidden = NO;
                label.text = lOURDYNAMIC;
                
                fr.origin.y =325;
                label.frame = fr;
            }else{
                label.hidden = YES;
            }
            
            descriptionLabel.hidden = YES;
            phone.image = [UIImage imageNamed:@"legendCard.png"];

            thirdView.hidden = NO;
            if(!ISIPHONE5){
                startBtn.hidden = NO;
            }
            break;
        default:
            phone.image = [UIImage imageNamed:@"card1.png"];
            break;
    }
    
    return view;

}
-(NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return 4;
}

-(void)addBold:(UILabel*)l withNum:(int)num{

    
    NSMutableAttributedString *notifyingStr = [[NSMutableAttributedString alloc] initWithString:l.text];
    [notifyingStr beginEditing];
    [notifyingStr addAttribute:NSFontAttributeName
                         value:[UIFont fontWithName:@"Ubuntu-Medium" size:12.0f]
                         range:NSMakeRange(0,num)];
    [notifyingStr endEditing];
    l.text = @"";
    l.attributedText = notifyingStr;
    
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
    
    // Tutorial tracking
    self.screenName = @"Tutorial-iOS";
    
    [_startBtn addTarget:self action:@selector(exitTutorial:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setTitle:START forState:UIControlStateNormal];
    [[_startBtn titleLabel]setFont:[UIFont fontWithName:@"Ubuntu-Medium" size:15.0f]];
    // carousel setup
    
   
    _carousel.bounces = YES;
    _carousel.decelerationRate = 0.03;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)exitTutorial:(id)sender{
    //[self performSegueWithIdentifier:@"start" sender:self];
    _menuController = [[DemoMenuController alloc] initWithMenuWidth:MENU_WIDTH];
    //[[[UIApplication sharedApplication] keyWindow] setRootViewController:_menuController];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 1; i++)
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
    
        [viewControllers addObject:vc];
        
        [vc setSideMenu:_menuController];
    }
    
    [_menuController setViewControllers:viewControllers];

    
    [self.navigationController pushViewController:_menuController animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didCompleteTutorial"];
    
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
