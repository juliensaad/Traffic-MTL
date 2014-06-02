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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSMutableArray*)_bridges[0]).count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BridgeCell *cell ;
    if(indexPath.row==0){
       cell= [tableView dequeueReusableCellWithIdentifier:@"FirstBridgeCell"];
    }else{
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];
    }
        cell.delay.adjustsFontSizeToFitWidth = YES;
        TMBridgeInfo* bridge = _bridges[direction][indexPath.row];
        
        cell.delay.text = bridge.bridgeName;
        
        if(bridge.ratio<=0.20){
            [cell.colorFilter setBackgroundColor:[UIColor greenColor]];
        }else if(bridge.ratio>0.20 && bridge.ratio<=0.45){
            [cell.colorFilter setBackgroundColor:[UIColor yellowColor]];
        }else{
            [cell.colorFilter setBackgroundColor:[UIColor redColor]];
        }
        cell.avecTraffic.text = [self formattedStringForDuration:bridge.realTime];
        cell.normal.text = [self formattedStringForDuration:bridge.time];
        
        

        switch (indexPath.row) {
            case 0:
                cell.backgroundImage.image = [[UIImage imageNamed:@"champlain@2x.jpg"] blurredImage:0.2];
                break;
            case 1:
                cell.backgroundImage.image = [[UIImage imageNamed:@"victoria@2x.jpg"] blurredImage:0.2];

                break;
            case 2:
                cell.backgroundImage.image = [[UIImage imageNamed:@"jacques@2x.jpg"] blurredImage:0.2];
                break;
            case 3:
                cell.backgroundImage.image = [[UIImage imageNamed:@"mercier@2x.jpg"] blurredImage:0.2];
            default:
                break;
        }
    
        cell.clipsToBounds = YES;
        cell.backgroundImage.clipsToBounds = YES;
        return cell;
    //}
    //return 0;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 142;
    }
    return 120;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    float offset = _tableView.contentOffset.y / _tableView.frame.size.height;
    for(int i=0; i<((NSMutableArray*)_bridges[0]).count;i++){
        
        BridgeCell *cell = (BridgeCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        CGRect frame = CGRectMake(cell.backgroundImage.frame.origin.x, offset * 60-30, cell.backgroundImage.frame.size.width, cell.backgroundImage.frame.size.height);
        
        cell.backgroundImage.frame = frame;
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView* bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg.png"];
    
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
    
    /*NSLog(@"%@ %@",[[jsonDict objectForKey:@"route"] objectForKey:@"realTime"], [[jsonDict objectForKey:@"route"] objectForKey:@"time"]);
    
    TMDuration* duration = [[TMDuration alloc] init];
    int realTime = [[[jsonDict objectForKey:@"route"] objectForKey:@"realTime"] intValue];
    

    int time = [[[jsonDict objectForKey:@"route"] objectForKey:@"time"] intValue];
    
    
    
    duration.realTime = [NSString stringWithFormat:@"Temps actuel: %@",[self formattedStringForDuration:realTime]];
    duration.time = [NSString stringWithFormat:@"Temps normal: %@", [self formattedStringForDuration:time]];
    
    duration.ratio = 1.0-(float)time/(float)realTime;

    
    [_results addObject:duration];
    
    
    [_tableView reloadData];*/

}
    
    /*
     //Put this code where you want to reload your table view
     dispatch_async(dispatch_get_main_queue(), ^{
     [UIView transitionWithView:<"TableName">
     duration:0.1f
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
     [<"TableName"> reloadData];
     } completion:NULL];
     });*/


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
    direction = MTL;
    [_tableView reloadData];
}

-(void)updateContent{
    [self loadTimes];
    NSLog(@"Update");
}

- (IBAction)versBanlieueClick:(id)sender {
    // [sender setBackgroundColor:BLUECOLOR];
    // [_b1 setBackgroundColor:[UIColor whiteColor]];
    
    
    direction = BANLIEUE;
    [_tableView reloadData];
    //[self loadTimes];
}
@end
