//
//  TMViewController.m
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMViewController.h"
#import "TMDuration.h"

#import "TMBridgeInfo.h"

#import <MapKit/MapKit.h>
#import "BridgeCell.h"
#import <POP/POP.h>
#import "UIImage+Blur.h"



@interface TMViewController ()

@property NSMutableData* responseData;
@property NSMutableArray* results;
@property NSMutableArray* connections;

@property UIRefreshControl* refreshControl;
@property NSMutableArray* bridges;

@property NSMutableArray* bridgeImages;
@end

@implementation TMViewController
BOOL direction;
int addedShadowCount;

#define MTL YES
#define BANLIEUE NO

#define BRIDGE1 @"Champlain"
#define BRIDGE2 @"Victoria"
#define BRIDGE3 @"Jacques-Cartier"
#define BRIDGE4 @"Mercier"
#define BRIDGE5 @"Louis-Hippolyte-La Fontaine"

#define CHAMPLAIN 0
#define VICTORIA 1
#define JACQUESCARTIER 2
#define MERCIER 3
#define LOUIS 4


- (void)addGradientToView:(UIView *)view
{
    if(view.tag==0){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];
        addedShadowCount++;
        
    }else{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];
        addedShadowCount++;
    }
}

- (void)addGradient:(UIView *)view
{
    if(view.tag==0){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];

        
    }else{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];

    }
}

-(void)viewWillLayoutSubviews{
    
   /* if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.view.clipsToBounds = YES;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = 0.0;
        if(UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            screenHeight = screenRect.size.height;
        else
            screenHeight = screenRect.size.width;
        CGRect screenFrame = CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
        CGRect viewFrame1 = [self.view convertRect:self.view.frame toView:nil];
        if (!CGRectEqualToRect(screenFrame, viewFrame1))
        {
            self.view.frame = screenFrame;
            self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }*/
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray*)_bridges[0]).count;
}

#define TMGRAY [UIColor colorWithRed:218.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:0.90]

#define TMBLUE [UIColor colorWithRed:106.0/255.0 green:205.0/255.0 blue:216.0/255.0 alpha:0.90]

#define GREEN [UIColor colorWithRed:102.0/255.0 green:188.0/255.0 blue:76.0/255.0 alpha:0.90]
#define ORANGE [UIColor colorWithRed:245.0/255.0 green:147.0/255.0 blue:49.0/255.0 alpha:0.90]
#define RED [UIColor colorWithRed:249.0/255.0 green:1.0/255.0 blue:0.0/255.0 alpha:0.90]
#define DARKRED [UIColor colorWithRed:182.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.90]

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BridgeCell *cell ;
    //if(indexPath.row==0){
    cell= [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];
    //}else{
    
    //    cell = [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];
    //}
    

    cell.bridgeName.adjustsFontSizeToFitWidth = YES;
    TMBridgeInfo* bridge = _bridges[direction][indexPath.row];
    
    cell.bridgeName.text = bridge.bridgeName;
    cell.bridgeName.adjustsFontSizeToFitWidth = YES;

    if(bridge.ratio<=0.20){
        [cell.avecTraffic setBackgroundColor:GREEN];
    }else if(bridge.ratio>0.20 && bridge.ratio<=0.45){
        [cell.avecTraffic setBackgroundColor:ORANGE];
    }else if(bridge.ratio>0.45 && bridge.ratio<=0.6){
        [cell.avecTraffic setBackgroundColor:RED];
    }else{
        [cell.avecTraffic setBackgroundColor:DARKRED];
    }

    cell.colorFilter.backgroundColor = [UIColor clearColor];

    float ratio = 100-(bridge.ratio*100);
    
    if(ratio>=100){
        ratio = 100;
    }
    cell.avecTraffic.text = [NSString stringWithFormat:@"%0.0f%%", ratio];//[self formattedStringForDuration:bridge.realTime];
    
    
    if([bridge.bridgeName isEqualToString:@"Victoria"]){
        //Get current time
        NSDate* now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
        NSInteger hour = [dateComponents hour];
        
        switch(hour){
            case 6:
            case 7:
            case 8:
                if(bridge.direction==0){
                    bridge.realTime = 200000;
                    [cell.avecTraffic setBackgroundColor:RED];
                }
                break;
            case 15:
            case 16:
            case 17:
            case 18:
                if(bridge.direction ==1){
                    bridge.realTime = 200000;
                    [cell.avecTraffic setBackgroundColor:RED];
                }
                break;
        }
        
        NSLog(@"%d", hour);
    }
    if(bridge.realTime>150000){
        cell.avecTraffic.text = lUNAVAILABLE;
        cell.avecTraffic.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.normal.text = [[NSString stringWithFormat:@"%@ %@",lNORMALTIME,[self formattedStringForDuration:bridge.time]] uppercaseString];
    
    cell.backgroundImage.image = _bridgeImages[indexPath.row];
    cell.backgroundImage.tag = indexPath.row;
    
    cell.clipsToBounds = YES;
    cell.backgroundImage.clipsToBounds = YES;
    
    if(addedShadowCount != ((NSMutableArray*)_bridges[0]).count){
        [self addGradientToView:cell.backgroundImage];
    }
        return cell;
    //}
    //return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 130;
    }
    return 130;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    float offset = _tableView.contentOffset.y;
    
    if(offset<=0){
        _statusBarView.hidden = YES;
    }else{
        _statusBarView.hidden = NO;
    }
    
    
    for(int i = 0; i<_statusBarImages.count;i++){
        
        CGRect im1Fr = ((UIImageView*)_statusBarImages[i]).frame;
        im1Fr.origin.y = -offset + i*130;
        
        ((UIImageView*)_statusBarImages[i]).frame = im1Fr;
        
    }
    
    // _statusBarImage.
    // Parallax effect for BridgeCells
   /* float offset = _tableView.contentOffset.y / _tableView.frame.size.height;
    for(int i=0; i<((NSMutableArray*)_bridges[0]).count;i++){
        
        BridgeCell *cell = (BridgeCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGRect frame = CGRectMake(cell.backgroundImage.frame.origin.x, offset * 60, cell.backgroundImage.frame.size.width, cell.backgroundImage.frame.size.height);
        
        cell.backgroundImage.frame = frame;
    }*/
    
    // Allow only a bounce on the top of the scrollview
    /*if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
    }*/
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _statusBarView.hidden = YES;
    _statusBarView.layer.borderWidth = 0.5;
    _statusBarView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
    
    // White text nav bar
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Ubuntu-Light" size:20.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    // Fill the images array for the bridges
    _bridgeImages = [[NSMutableArray alloc] init];
    [_bridgeImages addObject:[UIImage imageNamed:@"champlain.jpg"]];
    [_bridgeImages addObject:[UIImage imageNamed:@"victoria.jpg"]];
    [_bridgeImages addObject:[UIImage imageNamed:@"jacques.jpg"]];
    [_bridgeImages addObject:[UIImage imageNamed:@"mercier.jpg"]];
    [_bridgeImages addObject:[UIImage imageNamed:@"victoria.jpg"]];
    
    
    addedShadowCount = 0;
    UIImageView* bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"splash_fr.png"];
    
    bg.frame = self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];

    // default direction, set depending on time of the day or preference
    direction = MTL;
    [self updateContent];
    [NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(updateContent)
                                   userInfo:nil
                                    repeats:YES];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setOpaque:YES];
    [self.navigationController.navigationBar setBackgroundColor:BLUECOLOR];
    [self.navigationController.navigationBar setBarTintColor:BLUECOLOR];
    
    
  

    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(versBanlieueClick:)];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer *lSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(versMtlClick:)];
    [lSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    [[self view] addGestureRecognizer:lSwipeUpRecognizer];
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    
    UIImageView *im  =[[UIImageView alloc] initWithFrame:CGRectMake(67, 60, 9, 12)];
    im.image = [UIImage imageNamed:@"upArrow.png"];
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 320, 45)];
    l.text = lRELEASE;
    l.font = [UIFont fontWithName:@"Ubuntu-Light" size:20.0f];
    l.textColor = [UIColor whiteColor];
    l.textAlignment = NSTextAlignmentCenter;
    
    [tableViewController.refreshControl insertSubview:l atIndex:0];
    if(!ISFRENCH){
        [tableViewController.refreshControl insertSubview:im atIndex:0];
    }
    
}

-(void)createFakeStatusBar{
    
    _statusBarImages = [[NSMutableArray alloc] init];
    
    for(UIImage* im in _bridgeImages){
        
        
        
        UIImageView* i = [[UIImageView alloc] initWithImage:im];
        i.clipsToBounds = YES;
        [i setContentMode:UIViewContentModeScaleAspectFill];
        [i setFrame:CGRectMake(1, 1, 320, 130)];
        [self addGradient:i];
        
        [_statusBarView addSubview:i];
        [_statusBarImages addObject:i];
    }
}

-(void)handleRefresh:(id)sender{
    /*if(!direction){
        [self versBanlieueClick:self];
    }else{
        [self versMtlClick:self];
    }
    
    direction = !direction;*/
    [self loadTimes];
    
    [_refreshControl endRefreshing];
}

-(void)loadTimes{
    // Load all lon and lats
    _results = [[NSMutableArray alloc] init];
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://t-b.ca/dev/traffic.php"]]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
        
    NSURLConnection* con = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
   _bridges = [[NSMutableArray alloc] init];
    
    NSMutableArray* bridgesMTL = [[NSMutableArray alloc] init];
    NSMutableArray* bridgesBanlieue = [[NSMutableArray alloc] init];
    
    for(NSDictionary* dic in jsonDict){
        TMBridgeInfo* info = [[TMBridgeInfo alloc] init];
        
        info.bridgeName = [dic objectForKey:@"bridgeName"];
        info.direction = [[dic objectForKey:@"direction"] integerValue];
        info.realTime = [[dic objectForKey:@"realTime"] integerValue];
        info.time = [[dic objectForKey:@"time"] integerValue];
        
        info.ratio = 1.0-(float)info.time/(float)info.realTime;
        
        NSLog(@"%@", [dic description]);
        [info.direction?bridgesBanlieue:bridgesMTL addObject:info];
    }
    
    [_bridges addObject:bridgesMTL];
    [_bridges addObject:bridgesBanlieue];
    
    [_tableView reloadData];
    
    [self createFakeStatusBar];
    
}



- (NSString*)formattedStringForDuration:(int)duration
{
    NSInteger minutes = floor(duration/60);
    NSInteger seconds = round(duration - minutes * 60);
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)versMtlClick:(id)sender {
    
    _montrealBar.backgroundColor = TMBLUE;
    _banlieuBar.backgroundColor = TMGRAY;
    
    if(direction!= MTL){
        direction = MTL;
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeBoth;
        transition.duration = 0.3;
        transition.subtype = kCATransitionFromLeft;
        
        [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
        [self.tableView reloadData];
    }
    
}

-(void)updateContent{
    [self loadTimes];
}

- (IBAction)versBanlieueClick:(id)sender {
    // [sender setBackgroundColor:BLUECOLOR];
    // [_b1 setBackgroundColor:[UIColor whiteColor]];
    _montrealBar.backgroundColor = TMGRAY;
    _banlieuBar.backgroundColor = TMBLUE;
    if(direction!=BANLIEUE){
        direction = BANLIEUE;
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.fillMode = kCAFillModeBoth;
        transition.duration = 0.3;
        transition.subtype = kCATransitionFromRight;
        
        [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
        [self.tableView reloadData];
        
    }
    

    //[self loadTimes];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
    CGFloat dir = direction?-1:1;
        cell.transform = CGAffineTransformMakeTranslation(cell.bounds.size.width * dir*(indexPath.row+1)*1.5, 0);
        [UIView animateWithDuration:0.25 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    */
}

@end
