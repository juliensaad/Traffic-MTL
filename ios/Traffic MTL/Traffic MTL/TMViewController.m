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
#import "UIImage+animatedGIF.h"



@interface TMViewController ()

@property NSMutableData* responseData;
@property NSMutableArray* results;
@property NSMutableArray* connections;

@property UIRefreshControl* refreshControl;
@property NSMutableArray* bridges;

@property NSMutableArray* bridgeImages;

@property UILabel *l;

@property UIView* refreshContent;
@end

@implementation TMViewController
BOOL direction;
int addedShadowCount;

int rightCounter;
int statusShowing;

#define MTL YES
#define BANLIEUE NO


#define CHAMPLAIN 0
#define VICTORIA 1
#define JACQUESCARTIER 2
#define MERCIER 3
#define LOUIS 4

#define PERCENTAGE 0
#define TIME 1



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray*)_bridges[0]).count;
}

#define TMGRAY [UIColor colorWithRed:218.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:0.90]

#define TMBLUE [UIColor colorWithRed:106.0/255.0 green:205.0/255.0 blue:216.0/255.0 alpha:0.90]

#define RED [UIColor colorWithRed:249.0/255.0 green:1.0/255.0 blue:0.0/255.0 alpha:0.90]

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BridgeCell *cell ;
    cell= [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];

    TMBridgeInfo* bridge = _bridges[direction][indexPath.row];
    
    cell.bridgeName.text = bridge.bridgeName;
    cell.bridgeName.adjustsFontSizeToFitWidth = YES;

    cell.avecTraffic.backgroundColor = UIColorFromRGB(bridge.rgb);
    
    // detect touch on label to swap info
    cell.avecTraffic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [cell.avecTraffic addGestureRecognizer:tapGesture];

    cell.colorFilter.backgroundColor = [UIColor clearColor];

    if(statusShowing==PERCENTAGE){
        cell.avecTraffic.text = [self getPercentageString:bridge];
    }else{
        cell.avecTraffic.text = [self getTimeString:bridge];
    }
    
    
    
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

-(void)labelTap{
    // Change label time
    for(int i = 0;i<[_tableView numberOfRowsInSection:0];i++){
        NSIndexPath* index = [NSIndexPath indexPathForItem:i inSection:0];
        BridgeCell* cell = (BridgeCell*)[_tableView cellForRowAtIndexPath:index];
        
        TMBridgeInfo* bridge = _bridges[direction][index.row];
        
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = 0.65;
        [cell.avecTraffic.layer addAnimation:animation forKey:@"kCATransitionFade"];
        if(statusShowing==PERCENTAGE){
            cell.avecTraffic.text = [self getTimeString:bridge];
        }else{
            cell.avecTraffic.text = [self getPercentageString:bridge];
        }
    }
    
    statusShowing = (statusShowing==PERCENTAGE)?TIME:PERCENTAGE;
}

-(NSString*)getPercentageString:(TMBridgeInfo*)bridge{

    return [NSString stringWithFormat:@"%d%%", bridge.percentage];
}
-(NSString*)getTimeString:(TMBridgeInfo*)bridge{
    
    if(bridge.realTime >= bridge.time){
        return [NSString stringWithFormat:@"+ %@",[self formattedStringForDuration:bridge.delay]];
    }
    return [NSString stringWithFormat:@"+ %@",[self formattedStringForDuration:0]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 125;
    }
    return 125;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offset = _tableView.contentOffset.y;
    
    if(offset<=0){
        _statusBarView.hidden = YES;
        _statusBarView.backgroundColor = [UIColor clearColor];
        
        CGRect fr = _refreshContent.frame;
        fr.origin.y = -offset/4-5;
        _refreshContent.frame = fr;
        if(offset==0){
            _l.text = lPULL;
        }
        
        if(offset<-80 && offset > -110){
            if(![_l.text isEqualToString:lKEEP] && ![_l.text isEqualToString:lRELEASE]){
                //_l.text = lKEEP;
            }
        }else if(offset<=-110){
            if(![_l.text isEqualToString:lRELEASE]){
                _l.text = lRELEASE;
            }
        }
        
        // For louis
        if(_gif.tag==123){
            int posX = 320/2-(50-offset/2)/2;
            _gif.frame = CGRectMake(posX, -10, 50-offset/2, 50-offset/2);
        }
        
    }else if([_tableView numberOfRowsInSection:0]>0){
        _refreshContent.frame = CGRectMake(0, 0, 320, 70);
        _statusBarView.hidden = NO;
        
    }
    
    
    for(int i = 0; i<_statusBarImages.count;i++){
        
        CGRect im1Fr = ((UIImageView*)_statusBarImages[i]).frame;
        im1Fr.origin.y = -offset + i*125;
        
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
    
    // Pour la face de louis
    rightCounter = 0;
    
    // Direction status
    statusShowing = TIME;
    
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
    [_bridgeImages addObject:[UIImage imageNamed:@"louis.jpg"]];
    
    
    addedShadowCount = 0;
    UIImageView* bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg.png"];
    
    bg.frame = self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];

    // default direction, set depending on time of the day or preference
    direction = MTL;
    [self updateContent];
    
    // Timer to update periodically
    /*[NSTimer scheduledTimerWithTimeInterval:30.0
                                     target:self
                                   selector:@selector(updateContent)
                                   userInfo:nil
                                    repeats:YES];*/
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setOpaque:YES];
    [self.navigationController.navigationBar setBackgroundColor:BLUECOLOR];
    [self.navigationController.navigationBar setBarTintColor:BLUECOLOR];
    
    
  

    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer *lSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [lSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    [[self view] addGestureRecognizer:lSwipeUpRecognizer];
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    /*
    UIImageView *im  =[[UIImageView alloc] initWithFrame:CGRectMake(67, 60, 9, 12)];
    im.image = [UIImage imageNamed:@"upArrow.png"];
    */
    _l = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 320, 45)];
    _l.text = lPULL;
    _l.font = [UIFont fontWithName:@"Ubuntu-Light" size:14.0f];
    _l.textColor = [UIColor whiteColor];
    _l.textAlignment = NSTextAlignmentCenter;
    
    // [tableViewController.refreshControl insertSubview:_l atIndex:0];
    if(!ISFRENCH){
        // [tableViewController.refreshControl insertSubview:im atIndex:0];
    }
    
    
    // Gif animation
    _gif = [[UIImageView alloc]init];
    
    _gif.contentMode = UIViewContentModeScaleToFill;
    _gif.frame = CGRectMake(145, 6, 28, 28);
    // [self.refreshControl insertSubview:_gif atIndex:0];
    
    

    _refreshContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [self.refreshControl insertSubview:_refreshContent atIndex:0];
    
    [_refreshContent addSubview:_gif];
    [_refreshContent addSubview:_l];
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"whiteanim" ofType:@"gif"];
    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    _gif.alpha = 0.7;
    
    // [tableViewController.refreshControl insertSubview:_gif atIndex:0];
    
    [self listSubviewsOfView:self.refreshControl];
    
}

- (void)listSubviewsOfView:(UIView *)view {
    
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    
    for (UIView *subview in subviews) {
        
        // Do what you want to do with the subview
        if(subview.frame.size.width==320 && subview.frame.size.height==60){
            //subview.hidden = YES;
            //[view sendSubviewToBack:subview];
            [subview removeFromSuperview];
        }
        // List the subviews of subview
        [self listSubviewsOfView:subview];
        
    }
}

-(void)viewDidLayoutSubviews{
}
-(void)createFakeStatusBar{
    
    _statusBarImages = [[NSMutableArray alloc] init];
    
    for(UIImage* im in _bridgeImages){
        
        UIImageView* i = [[UIImageView alloc] initWithImage:im];
        i.clipsToBounds = YES;
        [i setContentMode:UIViewContentModeScaleAspectFill];
        [i setFrame:CGRectMake(1, 1, 320, 125)];
        [self addGradient:i];
        
        [_statusBarView addSubview:i];
        [_statusBarImages addObject:i];
    }
}

-(void)handleRefresh:(id)sender{
    
    _l.text = lRELEASE;
    
    [self loadTimes];
}

-(void)loadTimes{
    // Load all lon and lats
    _results = [[NSMutableArray alloc] init];
        
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://thirdbridge.net/traffic/traffic.php"]]
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
    
    [_refreshControl endRefreshing];
    
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    
    // In case there is an error in the return value
    if([jsonDict isKindOfClass:[NSNull class]] || jsonDict==nil){
        [_refreshControl endRefreshing];
        return ;
    }
   _bridges = [[NSMutableArray alloc] init];
    
    NSMutableArray* bridgesMTL = [[NSMutableArray alloc] init];
    NSMutableArray* bridgesBanlieue = [[NSMutableArray alloc] init];

    for(NSDictionary* dic in jsonDict){
        TMBridgeInfo* info = [[TMBridgeInfo alloc] init];
        
        info.bridgeName = [dic objectForKey:@"bridgeName"];
        info.direction = [[dic objectForKey:@"direction"] integerValue];
        info.realTime = [[dic objectForKey:@"realTime"] integerValue];
        info.time = [[dic objectForKey:@"time"] integerValue];
        
        info.percentage = [[dic objectForKey:@"percentage"] integerValue];
        info.delay = [[dic objectForKey:@"delay"] integerValue];
        
        // Scan hex value for color
        unsigned int outVal;
        NSScanner* scanner = [NSScanner scannerWithString:[dic objectForKey:@"color"]];
        [scanner scanHexInt:&outVal];
        info.rgb = outVal;
        
        info.ratio = 1.0-(float)info.time/(float)info.realTime;
        
        [info.direction?bridgesBanlieue:bridgesMTL addObject:info];
    }
    
    [_bridges addObject:bridgesMTL];
    [_bridges addObject:bridgesBanlieue];
    
    [_tableView reloadData];
    
    [_refreshControl endRefreshing];
    

    
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
        rightCounter = 0;
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
        rightCounter = 0;
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

-(void)swipeLeft{
    if(direction==BANLIEUE){
        rightCounter++;
    }
    
    if(rightCounter>=4 && _gif.tag != 123){
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"gif2" ofType:@"gif"];
        NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
        _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
        _gif.alpha = 0.9;

        _gif.tag = 123;
        _gif.frame = CGRectMake(0, -10, 50, 50);
        _gif.alpha = 1.0;
        _l.hidden = YES;

    }

    [self versBanlieueClick:self];
}

-(void)swipeRight{
    if(direction!=BANLIEUE){
        rightCounter=0;
    }
    
            rightCounter=0;
    if(rightCounter<4 && _gif.tag ==123){
        NSString *path=[[NSBundle mainBundle]pathForResource:@"whiteanim" ofType:@"gif"];
        NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
        _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
        _gif.alpha = 0.7;
        
        _gif.tag = 0;
        _gif.frame = CGRectMake(145, 6, 28, 28);
        _l.hidden = NO;
    }

    
       [self versMtlClick:self];
}


- (void)addGradientToView:(UIView *)view
{
    if(view.tag==0){
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];
        addedShadowCount++;
        
    }else{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor],
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
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];
        
        
    }else{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = view.bounds;
        gradient.colors = @[(id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0   alpha:0.0] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] CGColor],
                            (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] CGColor]
                            ];
        [view.layer insertSublayer:gradient atIndex:0];
        
    }
}


@end
