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
@interface TMViewController ()

@property NSMutableData* responseData;
@property NSMutableDictionary* results;
@property NSMutableArray* connections;

@property NSArray* bridgesNames;
@end

@implementation TMViewController


#define BRIDGE1 @"Champlain"
#define BRIDGE2 @"Victoria"
#define BRIDGE3 @"Jacques-Cartier"

#define CHAMPLAIN 0
#define VICTORIA 1
#define JACQUESCARTIER 2
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.-73.551365,45.473284,-73.541365

    // Load all lon and lats
    _results = [[NSMutableDictionary alloc] init];
    _connections = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Locations" ofType:@"plist"];
    
    NSDictionary *bridges = [[NSDictionary alloc]
                          initWithContentsOfFile:path];
    
    NSLog(@"bridges %@",[bridges description]);
    
    _bridgesNames = [NSArray arrayWithObjects:BRIDGE1,BRIDGE2,BRIDGE3,nil];
    
    NSString* direction = @"SN";
    
    for(NSString* bridgeName in _bridgesNames){
        NSArray* aBridge = [bridges objectForKey:[NSString stringWithFormat:@"%@ %@",bridgeName, direction]];
        
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
    
    [_champlainLabel setText:@"Unable to fetch data"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    int i = 0;
    for(NSURLConnection* con in _connections){
        if(con==connection){
            NSLog(@"Succeeded! Received %d bytes of data",[_responseData
                                                           length]);
            NSError *error;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
            
            NSLog(@"%@", [jsonDict description]);
            
            TMDuration* duration = [[TMDuration alloc] init];
            int realTime = [[[jsonDict objectForKey:@"route"] objectForKey:@"realTime"] intValue];
            
            NSLog(@"%d REAL FUCKING TIME", realTime);
            int time = [[[jsonDict objectForKey:@"route"] objectForKey:@"time"] intValue];
            duration.text = [NSString stringWithFormat:@" %d ", realTime];
            
            //duration.seconds = [[[[[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"duration"] objectForKey:@"value"] intValue];
            
            
            switch (i) {
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
            }
            
        }
        i++;
    }

    //[_champlainLabel setText:[[[[[jsonDict objectForKey:@"routes"] objectAtIndex:0] objectForKey:@"legs"] objectForKey:@"duration"] objectForKey:@"text"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
