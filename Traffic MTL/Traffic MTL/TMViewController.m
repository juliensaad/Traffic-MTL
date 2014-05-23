//
//  TMViewController.m
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMViewController.h"
#import "TMDuration.h"
#import <MapKit/MapKit.h>
#import "BridgeCell.h"
#import <POP/POP.h>


@interface TMViewController ()

@property NSMutableData* responseData;
@property NSMutableArray* results;
@property NSMutableArray* connections;




@property NSArray* bridgesNames;
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
    return _bridgesNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BridgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];
    
    
    if([_results count]>indexPath.row){

        cell.delay.adjustsFontSizeToFitWidth = YES;
        TMDuration* duration = _results[indexPath.row];
        
        cell.delay.text = duration.bridgeName;
        
        if(duration.ratio<=0.1){
            [cell.avecTraffic setTextColor:[UIColor greenColor]];
        }else if(duration.ratio>0.1 && duration.ratio<=0.35){
            [cell.avecTraffic setTextColor:[UIColor yellowColor]];
        }else{
            [cell.avecTraffic setTextColor:[UIColor redColor]];
        }
        cell.avecTraffic.text = duration.realTime;
        cell.normal.text = duration.time;

    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // default direction, set depending on time of the day or preference
    direction = MTL;
    
}
-(void)loadTimes{
    // Load all lon and lats
    _results = [[NSMutableArray alloc] init];
    _connections = [[NSMutableArray alloc] init];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
    
    NSDictionary *bridges = [[NSDictionary alloc]
                             initWithContentsOfFile:path];
    _bridgesNames = [NSArray arrayWithObjects:BRIDGE1,BRIDGE2,BRIDGE3,BRIDGE4,BRIDGE5,nil];
    
    NSString* directionKey = direction?@"SN":@"NS";
    
    for(NSString* bridgeName in _bridgesNames){
        NSArray* aBridge = [bridges objectForKey:[NSString stringWithFormat:@"%@ %@",bridgeName, directionKey]];
        
        NSString* start = [aBridge objectAtIndex:0];
        NSString* end = [aBridge objectAtIndex:1];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mapquestapi.com/directions/v2/route?key=%@&from=%@&to=%@&",MAPS_API_KEY, start, end]]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        [request setHTTPMethod: @"GET"];
        
        NSURLConnection* con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [_connections addObject:con];
        
    }

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
    NSString* failBridge;
    int i = 0;
    for(NSURLConnection* con in _connections){
        if(con==connection){
            TMDuration* duration = [[TMDuration alloc] init];
            
            failBridge = _bridgesNames[i];
            NSLog(@"%@ %d", failBridge, i);
            duration.text = [NSString stringWithFormat:@"%@ semble être fermé",failBridge];
            [_results addObject:duration];
        }
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    int i = 0;
    for(NSURLConnection* con in _connections){
        if(con==connection){
        
            NSError *error;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
            
            NSLog(@"%@ %@",[[jsonDict objectForKey:@"route"] objectForKey:@"realTime"], [[jsonDict objectForKey:@"route"] objectForKey:@"time"]);
            
            TMDuration* duration = [[TMDuration alloc] init];
            int realTime = [[[jsonDict objectForKey:@"route"] objectForKey:@"realTime"] intValue];
            

            int time = [[[jsonDict objectForKey:@"route"] objectForKey:@"time"] intValue];
            
            
            
            duration.realTime = [NSString stringWithFormat:@"Temps actuel: %@",[self formattedStringForDuration:realTime]];
            duration.time = [NSString stringWithFormat:@"Temps normal: %@", [self formattedStringForDuration:time]];
            
            duration.ratio = 1.0-(float)time/(float)realTime;
            //duration.seconds = [[[[[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"value"] intValue];
            //duration.text = [NSString stringWithFormat:@"Delai %@: %.0f%% du temps habituel", _bridgesNames[i], (2-(time/realTime))*100];
            duration.bridgeName = _bridgesNames[i];
            
            [_results addObject:duration];
            
            /*switch (i) {
                case CHAMPLAIN:
                    _champlainLabel.text = [duration.text stringByAppendingString:_bridgesNames[i]];
                    break;
                case VICTORIA:
                    _victoriaLabel.text = [duration.text stringByAppendingString:_bridgesNames[i]];
                    break;
                case JACQUESCARTIER:
                    _jcLabel.text = [duration.text stringByAppendingString:_bridgesNames[i]];
                    break;
                default:
                    break;
            }*/
            
            [_tableView reloadData];
            
        }
        i++;
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
    [sender setBackgroundColor:BLUECOLOR];
    [_b2 setBackgroundColor:[UIColor whiteColor]];
    direction = MTL;
    [self loadTimes];
}

- (IBAction)versBanlieueClick:(id)sender {
    [sender setBackgroundColor:BLUECOLOR];
    [_b1 setBackgroundColor:[UIColor whiteColor]];
    
    
    direction = BANLIEUE;
    [self loadTimes];
}
@end
