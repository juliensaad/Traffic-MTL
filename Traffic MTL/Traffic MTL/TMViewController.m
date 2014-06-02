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
    NSLog(@"Adding %d", addedShadowCount);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray*)_bridges[0]).count;
}

#define TMGRAY [UIColor colorWithRed:218.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:0.90]

#define TMBLUE [UIColor colorWithRed:106.0/255.0 green:205.0/255.0 blue:216.0/255.0 alpha:0.90]

#define GREEN [UIColor colorWithRed:102.0/255.0 green:188.0/255.0 blue:76.0/255.0 alpha:0.90]
#define ORANGE [UIColor colorWithRed:245.0/255.0 green:147.0/255.0 blue:49.0/255.0 alpha:0.90]
#define RED [UIColor colorWithRed:235.0/255.0 green:33.0/255.0 blue:46.0/255.0 alpha:0.90]

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
        }else{
            [cell.avecTraffic setBackgroundColor:RED];

        }
    
        cell.colorFilter.backgroundColor = [UIColor clearColor];
    
    
        cell.avecTraffic.text = [self formattedStringForDuration:bridge.realTime];
    
    if(bridge.realTime>1500){
        cell.avecTraffic.text = lUNAVAILABLE;
        cell.avecTraffic.adjustsFontSizeToFitWidth = YES;
    }
        cell.normal.text = [[NSString stringWithFormat:@"%@ %@",lNORMALTIME,[self formattedStringForDuration:bridge.time]] uppercaseString];
    

        switch (indexPath.row) {
            case 0:
                cell.backgroundImage.image = [[UIImage imageNamed:@"champlain@2x.jpg"] blurredImage:0.0];
                break;
            case 1:
                cell.backgroundImage.image = [[UIImage imageNamed:@"victoria@2x.jpg"] blurredImage:0.0];

                break;
            case 2:
                cell.backgroundImage.image = [[UIImage imageNamed:@"jacques@2x.jpg"] blurredImage:0.0];
                break;
            case 3:
                cell.backgroundImage.image = [[UIImage imageNamed:@"mercier@2x.jpg"] blurredImage:0.0];
            default:
                break;
        }
    //    cell.backgroundImage.image = [[UIImage alloc] init];
        cell.backgroundImage.tag = indexPath.row;
    
        cell.clipsToBounds = YES;
        cell.backgroundImage.clipsToBounds = YES;
    
    if(addedShadowCount != ((NSMutableArray*)_bridges[0]).count){
        [self addGradientToView:cell.backgroundImage];
        // [self addGradientToView:cell.backgroundImage];
    }
        return cell;
    //}
    //return 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 130;
    }
    return 130;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Parallax effect for BridgeCells
    /*float offset = _tableView.contentOffset.y / _tableView.frame.size.height;
    for(int i=0; i<((NSMutableArray*)_bridges[0]).count;i++){
        
        BridgeCell *cell = (BridgeCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGRect frame = CGRectMake(cell.backgroundImage.frame.origin.x, offset * 60-60, cell.backgroundImage.frame.size.width, cell.backgroundImage.frame.size.height);
        
        cell.backgroundImage.frame = frame;
    }*/
    
    // Allow only a bounce on the top of the scrollview
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    /*UIImageView *rcImageView =
    [[UIImageView alloc] initWithImage:
     [UIImage imageNamed: @"rien"]];
    [self.refreshControl insertSubview:rcImageView atIndex:0];*/
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
  
    
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
    //[sender setBackgroundColor:BLUECOLOR];
    //[_b2 setBackgroundColor:[UIColor whiteColor]];
    
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
    NSLog(@"Update");
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
