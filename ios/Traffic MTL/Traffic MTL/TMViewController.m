//
//  TMViewController.m
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMViewController.h"

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

@property NSMutableArray* bridgeImagesSouth;
@property NSMutableArray* bridgeImagesNorth;

@property UILabel *l;

@property UIView* refreshContent;

@property NSMutableArray* rowOrder;
@property NSMutableArray* rowOrderNORD;

@end

@implementation TMViewController
BOOL direction;
int addedShadowCount;

int rightCounter;
int statusShowing;
BOOL shore;
BOOL sideMenuShown;
BOOL isLoading;


// Hide and show bottombar
int lastContentOffset;
float lastContentOffsetValue;
int bottomBarOffset;
BOOL _scrollDirection;
BOOL bottomBarHasBeenHidden;

#define MTL YES
#define BANLIEUE NO

#define PERCENTAGE 0
#define TIME 1

#define TMGRAY [UIColor colorWithRed:218.0/255.0 green:220.0/255.0 blue:221.0/255.0 alpha:0.90]
#define TMBLUE [UIColor colorWithRed:106.0/255.0 green:205.0/255.0 blue:216.0/255.0 alpha:0.90]

#pragma mark TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"shore"]==RIVE_SUD)
        return ((NSMutableArray*)_bridges[0]).count;
    else
        return ((NSMutableArray*)_bridges[2]).count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BridgeCell *cell;
    cell= [tableView dequeueReusableCellWithIdentifier:@"BridgeCell"];

    if ([[_bridges[direction+(shore?2:0)] objectAtIndex:indexPath.row] isKindOfClass:[NSString class]] &&
        [[_bridges[direction+(shore?2:0)] objectAtIndex:indexPath.row] isEqualToString:@"DUMMY"]) {
        cell.textLabel.text = @"";
        cell.hidden = YES;
        cell.contentView.hidden = YES;

    }else{
        TMBridgeInfo* bridge = _bridges[direction+(shore?2:0)][indexPath.row];
        
        cell.bridgeName.text = bridge.bridgeName;
        cell.bridgeName.adjustsFontSizeToFitWidth = YES;
        cell.bridgeName.font = [UIFont fontWithName:@"Ubuntu-Light" size:28.0f];
        cell.avecTraffic.backgroundColor = UIColorFromRGB(bridge.rgb);
        
        cell.contentView.hidden = NO;
        // detect touch on label to swap info
        cell.avecTraffic.userInteractionEnabled = YES;
        
        cell.colorFilter.backgroundColor = [UIColor clearColor];

        if(statusShowing==PERCENTAGE){
            cell.avecTraffic.text = [self getPercentageString:bridge];
        }else{
            cell.avecTraffic.text = [self getTimeString:bridge];
        }
        
        cell.avecTraffic.font = [UIFont fontWithName:@"Ubuntu-Light" size:16.0f];
        cell.normal.font = [UIFont fontWithName:@"Ubuntu-Medium" size:10.0f];
        cell.normal.text = [NSString stringWithFormat:@"CONDITION: %@",bridge.condition];
        
        @try {
            cell.backgroundImage.image = (shore?_bridgeImagesNorth:_bridgeImagesSouth)[indexPath.row];
            
            switch(bridge.bridgeId) {
                case 1:
                case 2:
                    cell.backgroundImage.image = [UIImage imageNamed:@"champlain.jpg"];
                    break;
                case 3:
                case 4:
                    cell.backgroundImage.image = [UIImage imageNamed:@"victoria.jpg"];
                    break;
                case 5:
                case 6:
                    cell.backgroundImage.image = [UIImage imageNamed:@"jacques.jpg"];
                    break;
                case 7:
                case 8:
                    cell.backgroundImage.image = [UIImage imageNamed:@"mercier.jpg"];
                    break;
                case 9:
                case 10:
                    cell.backgroundImage.image = [UIImage imageNamed:@"louis.jpg"];
                    break;
                case 14:
                case 45:
                    cell.backgroundImage.image = [UIImage imageNamed:@"louis-bisson.jpg"];
                    break;
                case 46:
                case 47:
                    cell.backgroundImage.image = [UIImage imageNamed:@"lachapelle.jpg"];
                    break;
                case 48:
                case 49:
                    cell.backgroundImage.image = [UIImage imageNamed:@"mederic-martin.jpg"];
                    break;
                case 50:
                case 51:
                    cell.backgroundImage.image = [UIImage imageNamed:@"viau.jpg"];
                    break;
                case 52:
                case 53:
                    cell.backgroundImage.image = [UIImage imageNamed:@"papineau.jpg"];
                    break;
                case 54:
                case 55:
                    cell.backgroundImage.image = [UIImage imageNamed:@"pie-ix.jpg"];
                    break;
                case 56:
                case 57:
                    cell.backgroundImage.image = [UIImage imageNamed:@"olivier.jpg"];
                    break;
                case 58:
                case 59:
                default:
                    cell.backgroundImage.image = [UIImage imageNamed:@"tourtes.jpg"];
                    break;
                case 60:
                case 61:
                    cell.backgroundImage.image = [UIImage imageNamed:@"charles.jpg"];
                    break;
			}
        }
        @catch (NSException *exception) {
            cell.backgroundImage.image = (shore?_bridgeImagesNorth:_bridgeImagesSouth)[0];
        }
        @finally {
            
        }
        
        cell.backgroundImage.tag = indexPath.row;
        
        cell.clipsToBounds = YES;
        cell.backgroundImage.clipsToBounds = YES;
        
        if(!cell.hasShadow){
            [self addGradientToView:cell.backgroundImage];
            cell.hasShadow = YES;
        }
        
        if(indexPath.row==0){
            UIButton* hamburger = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 50, 40)];
            [hamburger setImage:[UIImage imageNamed:@"hamburger.png"] forState:UIControlStateNormal];
            [cell addSubview: hamburger];
            
            hamburger.tag = 10;
            hamburger.hidden = YES;
            [hamburger addTarget:self action:@selector(changeShore:) forControlEvents:UIControlEventTouchUpInside];
            [cell setUserInteractionEnabled:YES];
        }
        
        if(indexPath.row!=0){
            [[cell viewWithTag:10] setHidden:YES];
        }else{
            [[cell viewWithTag:10] setHidden:NO];
        }
    }
    return cell;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self labelTap];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 125;
    }
    return 125;
}

#define DOWN YES
#define UP NO

#pragma mark ScrollViewDelegate
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
    
    // 57 432
    // 145 520
    float maxOffset = 0;
    if(ISIPHONE5){
        maxOffset = (shore==RIVE_SUD)?57.0:432.0;
    }else{
        maxOffset = (shore==RIVE_SUD)?145.0:520.0;
    }
   
    if(offset>=0 && offset<maxOffset){
        
        // Screen height
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        
        int bottomBarSize = _bottomBar.frame.size.height;
        int bottomBarPosY = _bottomBar.frame.origin.y;
        _scrollDirection = DOWN;
        
        int scrollViewOffset = (int)scrollView.contentOffset.y;
        // Detect the scroll direction
        if (lastContentOffset < scrollViewOffset) {
            _scrollDirection = DOWN;
            
            if(bottomBarPosY<screenHeight){
                CGRect fr = _bottomBar.frame;

                fr.origin.y += (offset-lastContentOffsetValue);
                
                if(fr.origin.y >screenHeight)
                    fr.origin.y = screenHeight;
                _bottomBar.frame = fr;
            }
           
        }else{
            _scrollDirection = UP;
            
            if(bottomBarPosY>(screenHeight-bottomBarSize)){
                CGRect fr = _bottomBar.frame;

                fr.origin.y += (offset-lastContentOffsetValue);
                
                if(fr.origin.y <(screenHeight-bottomBarSize))
                    fr.origin.y = screenHeight-bottomBarSize;
                _bottomBar.frame = fr;
            }
            
        }
        lastContentOffsetValue = scrollView.contentOffset.y;
        lastContentOffset = (int)scrollView.contentOffset.y;
    }
    if(offset>=maxOffset && !bottomBarHasBeenHidden){
        [self setBottomBarHidden:YES];
    }
    if(offset<0 && bottomBarHasBeenHidden){
        [self setBottomBarHidden:NO];
    }
    
    
    for(int i = 0; i<_statusBarImages.count;i++){
        
        CGRect im1Fr = ((UIImageView*)_statusBarImages[i]).frame;
        im1Fr.origin.y = -offset + i*125;
        ((UIImageView*)_statusBarImages[i]).frame = im1Fr;
        
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
 
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //  [self setBottomBarHidden:!_scrollDirection];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self setBottomBarHidden:_scrollDirection];
}


-(void)setBottomBarHidden:(BOOL)hidden{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    CGRect fr = _bottomBar.frame;
    // Screen height
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    if(hidden){
        fr.origin.y = screenHeight;
        
        bottomBarHasBeenHidden = YES;

    }else{
        fr.origin.y = screenHeight-fr.size.height;
    
        bottomBarHasBeenHidden = NO;
    }
    
    // [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    _bottomBar.frame = fr;
    
    [UIView commitAnimations];
}


-(void)labelTap{
    // Change label time
    for(int i = 0;i<[_tableView numberOfRowsInSection:0];i++){
        NSIndexPath* index = [NSIndexPath indexPathForItem:i inSection:0];
        BridgeCell* cell = (BridgeCell*)[_tableView cellForRowAtIndexPath:index];
        
        TMBridgeInfo* bridge = _bridges[direction+(shore?2:0)][index.row];
        
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

    if(bridge.percentage==-1)
        return ISFRENCH?@"N/D":@"N/A";
    return [NSString stringWithFormat:@"%d%%", bridge.percentage];
}
-(NSString*)getTimeString:(TMBridgeInfo*)bridge{
    
    if(bridge.percentage==-1)
        return ISFRENCH?@"N/D":@"N/A";
    
    if(bridge.realTime >= bridge.time){
        return [NSString stringWithFormat:@"+ %@",[self formattedStringForDuration:bridge.delay]];
    }
    return [NSString stringWithFormat:@"+ %@",[self formattedStringForDuration:0]];
}

-(void)viewDidLayoutSubviews{
    if(!ISIPHONE5){
        // Screen height
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        
        CGRect fr = _bottomBar.frame;
        fr.origin.y = screenHeight-_bottomBar.frame.size.height;
        _bottomBar.frame = fr;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Screen name
    self.screenName = @"Main-iOS";
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.hidden = NO;
    
    [self setBottomBarHidden:NO];
    _b1.titleLabel.font =  [UIFont fontWithName:@"Ubuntu-Medium" size:12.0f];
    _b2.titleLabel.font =  [UIFont fontWithName:@"Ubuntu-Medium" size:12.0f];

    // Preload data
    _results = [[NSMutableArray alloc] init];
    
    isLoading = NO;

    // Init fake data
    [[[NSURLConnection alloc] initWithRequest:[NSMutableURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]pathForResource:@"fakeData" ofType:@"json"]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10] delegate:self] start];

    
    sideMenuShown = NO;
    
 
    shore = [[NSUserDefaults standardUserDefaults] boolForKey:@"shore"];
    
    _rowOrder = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"rowOrder"] mutableCopy];
    _rowOrderNORD = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"rowOrderNORD"] mutableCopy];
    
    // Order the images depending on rowOrder
    [self prepareBridgeImages];
      // Pour la face de louis
    rightCounter = 0;
   
    
    _statusBarView.hidden = YES;
    
    CALayer* layer = _statusBarView.layer;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 0.5;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor colorWithWhite:1.0 alpha:0.2].CGColor];
    [layer addSublayer:bottomBorder];
    
    // White text nav bar
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Ubuntu-Light" size:20.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    

    
    
    addedShadowCount = 0;
    UIImageView* bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg.png"];
    bg.frame = self.view.frame;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];

    // default direction, set depending on time of the day or preference
    direction = MTL;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
  /*  UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    UISwipeGestureRecognizer *lSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [lSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    [[self view] addGestureRecognizer:lSwipeUpRecognizer];*/
    
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    

    _l = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, 320, 45)];
    
    _l.font = [UIFont fontWithName:@"Ubuntu-Light" size:14.0f];
    _l.textColor = [UIColor whiteColor];
    _l.textAlignment = NSTextAlignmentCenter;
    
    
    // Gif animation
    _gif = [[UIImageView alloc]init];
    
    _gif.contentMode = UIViewContentModeScaleToFill;
    _gif.frame = CGRectMake(145, 6, 28, 28);

    _refreshContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    [self.refreshControl insertSubview:_refreshContent atIndex:0];
    
    [_refreshContent addSubview:_gif];
    [_refreshContent addSubview:_l];
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"whiteanim" ofType:@"gif"];
    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
    _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    _gif.alpha = 0.7;
    
    [self listSubviewsOfView:self.refreshControl];
    
    // Pull refreshcontent down
   
    [self beginRefreshingTableView];
    
    // Detect when user reopens the application
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // Check for shore change
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"shore"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    // Check for language change
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"lang"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    [self localizeView];
    
    
}

-(void)prepareBridgeImages{
    // Fill the images array for the bridges
    _bridgeImagesSouth = [[NSMutableArray alloc] init];
    [_bridgeImagesSouth addObject:[UIImage imageNamed:@"champlain.jpg"]];
    [_bridgeImagesSouth addObject:[UIImage imageNamed:@"victoria.jpg"]];
    [_bridgeImagesSouth addObject:[UIImage imageNamed:@"jacques.jpg"]];
    [_bridgeImagesSouth addObject:[UIImage imageNamed:@"mercier.jpg"]];
    [_bridgeImagesSouth addObject:[UIImage imageNamed:@"louis.jpg"]];
    
    
    
    _bridgeImagesNorth = [[NSMutableArray alloc] init];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"louis-bisson.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"lachapelle.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"mederic-martin.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"viau.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"papineau.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"pie-ix.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"olivier.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"tourtes.jpg"]];
    [_bridgeImagesNorth addObject:[UIImage imageNamed:@"charles.jpg"]];

}

-(void)localizeView{
    [_b1 setTitle:lMTL forState:UIControlStateNormal];
    [_b2 setTitle:lBANLIEU forState:UIControlStateNormal];
    _l.text = lPULL;
    // Direction status
    statusShowing = TIME;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"shore"]){
        [self shoreChange];
    }
    
    if([keyPath isEqualToString:@"lang"]){
        [self localizeView];
        [self loadTimes];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadTimes];
}

- (void)didBecomeActive:(NSNotification *)notification;
{
    [self beginRefreshingTableView];
}
- (void)beginRefreshingTableView {
    
    [self.refreshControl beginRefreshing];
    _l.text = ISFRENCH?@"Chargement des données":@"Loading ...";
    //if (self.tableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            
            self.tableView.contentOffset = CGPointMake(0, -100);
            
        } completion:^(BOOL finished){
            [self loadTimes];

        }];
        
    // }
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
-(void)createFakeStatusBar{
    
    _statusBarImages = [[NSMutableArray alloc] init];
    
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    for(UIImage* im in shore?_bridgeImagesNorth:_bridgeImagesSouth){
        
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

    if(!isLoading){

        isLoading = YES;
        // Load all lon and lats
        _results = [[NSMutableArray alloc] init];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://thirdbridge.net/traffic_dev/traffic.php"]]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *postString = ISFRENCH?@"lang=1":@"lang=0";
        
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
            
        NSURLConnection* con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [con start];
        [_refreshControl beginRefreshing];
        
    }

}

#pragma mark Connection handling
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
    isLoading = NO;
    
    [_refreshControl endRefreshing];
    
    
    
    // Show the user that he does not have internet connection
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
                         CGRect fr = _noInternet.frame;
                         fr.origin.y=0;
                         _noInternet.frame = fr;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2
                                               delay:2.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              CGRect fr = _noInternet.frame;
                                              fr.origin.y=-20;
                                              _noInternet.frame = fr;
                                          }
                                          completion:^(BOOL finished){
                                              //      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
                                          }];
                     }];
    
    // Overlay status bar
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(hideBar:) userInfo:nil repeats:NO];

    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showBar:) userInfo:nil repeats:NO];
    
}
-(void)hideBar:(id)sender{
    [sender invalidate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

-(void)showBar:(id)sender{
    [sender invalidate];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    isLoading = NO;
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
    
    NSMutableArray* bridgesMTLNORD = [[NSMutableArray alloc] init];
    NSMutableArray* bridgesBanlieueNORD = [[NSMutableArray alloc] init];

    for(NSDictionary* dic in jsonDict){
        TMBridgeInfo* info = [[TMBridgeInfo alloc] init];
        
        info.bridgeName = [dic objectForKey:@"bridgeName"];
        info.direction = [[dic objectForKey:@"direction"] intValue];
        info.realTime = [[dic objectForKey:@"realTime"] intValue];
        info.time = [[dic objectForKey:@"time"] intValue];
        
        info.percentage = [[dic objectForKey:@"percentage"] intValue];
        info.delay = [[dic objectForKey:@"delay"] intValue];
        info.bridgeId = [[dic objectForKey:@"id"] intValue];
        info.condition = [dic objectForKey:@"cond"];
        
        // Scan hex value for color
        unsigned int outVal;
        NSScanner* scanner = [NSScanner scannerWithString:[dic objectForKey:@"color"]];
        [scanner scanHexInt:&outVal];
        info.rgb = outVal;
        
        info.ratio = 1.0-(float)info.time/(float)info.realTime;
        
        info.shore = [[dic objectForKey:@"shore"] intValue];
        
        if(info.shore == 0)
            [info.direction?bridgesBanlieue:bridgesMTL addObject:info];
        else
            [info.direction?bridgesBanlieueNORD:bridgesMTLNORD addObject:info];
    }
    
    [_bridges addObject:bridgesMTL];
    [_bridges addObject:bridgesBanlieue];
    [_bridges addObject:bridgesMTLNORD];
    [_bridges addObject:bridgesBanlieueNORD];
    
    [self reloadTableView];
    
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
        [self reloadTableView];
    }
    
    if(direction!=BANLIEUE){
        rightCounter=0;
    }
    
    rightCounter=0;
    if(rightCounter<10 && _gif.tag ==123){
        NSString *path=[[NSBundle mainBundle]pathForResource:@"whiteanim" ofType:@"gif"];
        NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
        _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
        _gif.alpha = 0.7;
        
        _gif.tag = 0;
        _gif.frame = CGRectMake(145, 6, 28, 28);
        _l.hidden = NO;
    }
    

    
}


- (IBAction)versBanlieueClick:(id)sender {

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
        [self reloadTableView];
        
    }
    
    if(direction==BANLIEUE){
        rightCounter++;
    }
    
    if(rightCounter>=10 && _gif.tag != 123){
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"gif2" ofType:@"gif"];
        NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
        _gif.image= [UIImage animatedImageWithAnimatedGIFURL:url];
        _gif.alpha = 0.9;
        
        _gif.tag = 123;
        _gif.frame = CGRectMake(0, -10, 50, 50);
        _gif.alpha = 1.0;
        _l.hidden = YES;
        
    }
}

-(void)shoreChange{

    shore = [[NSUserDefaults standardUserDefaults] boolForKey:@"shore"];
    
    [self createFakeStatusBar];
    [self reloadTableView];

 
}
- (IBAction)changeShore:(id)sender {
   /* if([[[sender titleLabel] text] isEqualToString:@"S"]){
        [sender setTitle:@"N" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"S" forState:UIControlStateNormal];
    }
    shore = !shore;
    
    [self createFakeStatusBar];
    [_tableView reloadData];*/

    [_sideMenu showMenu:[[_sideMenu paperFoldView] state]==PaperFoldStateLeftUnfolded?PaperFoldStateDefault:PaperFoldStateLeftUnfolded animated:YES];
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


#pragma Tableview reordering
// This method is called when the long press gesture is triggered starting the re-ording process.
// You insert a blank row object into your data source and return the object you want to save for
// later. This method is only called once.
- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [_bridges[direction+(shore?2:0)] objectAtIndex:indexPath.row];
    // Your dummy object can be something entirely different. It doesn't
    // have to be a string.
    [_bridges[direction+(shore?2:0)] replaceObjectAtIndex:indexPath.row withObject:@"DUMMY"];
    return object;
}

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process.
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    id object = [_bridges[direction+(shore?2:0)] objectAtIndex:fromIndexPath.row];
    [_bridges[direction+(shore?2:0)] removeObjectAtIndex:fromIndexPath.row];
    [_bridges[direction+(shore?2:0)] insertObject:object atIndex:toIndexPath.row];
    
    object = [(shore?_bridgeImagesNorth:_bridgeImagesSouth) objectAtIndex:fromIndexPath.row];
    [ (shore?_bridgeImagesNorth:_bridgeImagesSouth) removeObjectAtIndex:fromIndexPath.row];
    [ (shore?_bridgeImagesNorth:_bridgeImagesSouth) insertObject:object atIndex:toIndexPath.row];

}

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.
- (void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath; {
    [_bridges[direction+(shore?2:0)] replaceObjectAtIndex:indexPath.row withObject:object];
    
    [self saveRowReordering];
    // do any additional cleanup here
    [self createFakeStatusBar];
}

-(void)saveRowReordering{

    // Save new row order for both rows
    if(_rowOrder == nil){
        _rowOrder = [[NSMutableArray alloc] init];
        NSLog(@"Nil");
    }
    if(_rowOrderNORD == nil){
        _rowOrderNORD = [[NSMutableArray alloc] init];
        //    NSLog(@"Nil 2");
    }
    
    if(shore==RIVE_SUD)
        _rowOrder= [[NSMutableArray alloc] init];
    else
        _rowOrderNORD = [[NSMutableArray alloc] init];
    for(int i = 0;i<[_tableView numberOfRowsInSection:0];i++){
        NSIndexPath* index = [NSIndexPath indexPathForItem:i inSection:0];
        
        TMBridgeInfo* bridge = _bridges[direction+(shore?2:0)][index.row];
        
        [shore==RIVE_SUD?_rowOrder:_rowOrderNORD addObject:bridge.bridgeName];
        
    }
    // Save to user defaults
    [[NSUserDefaults standardUserDefaults] setObject:shore==RIVE_SUD?_rowOrder:_rowOrderNORD forKey:shore==RIVE_SUD?@"rowOrder":@"rowOrderNORD"];
    
    NSLog(@"saving %@", shore==RIVE_SUD?@"rowOrder":@"rowOrderNORD");
    NSLog(@"%@", [_rowOrder description]);
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
}

-(void)reorderRows{

    int nbBridges = ((NSMutableArray*)_bridges[direction+(shore?2:0)]).count;
    
    if(nbBridges!=(shore==RIVE_SUD?_rowOrder:_rowOrderNORD).count) return;
    
    NSMutableArray* newBridgeOrder1 = [[NSMutableArray alloc] init];
    NSMutableArray* newBridgeOrder2 = [[NSMutableArray alloc] init];
    
    
    int j = 0;
    while (j<nbBridges) {
        for(int i = 0;i<nbBridges;i++){
            if([shore==RIVE_SUD?_rowOrder[j]:_rowOrderNORD[j] isEqualToString:((TMBridgeInfo*)_bridges[direction+(shore?2:0)][i]).bridgeName]){
                [newBridgeOrder1 addObject:_bridges[direction+(shore?2:0)][i]];
            }
        }
        j++;
    }

    j = 0;
    while (j<nbBridges) {
        for(int i = 0;i<nbBridges;i++){
            if([shore==RIVE_SUD?_rowOrder[j]:_rowOrderNORD[j] isEqualToString:((TMBridgeInfo*)_bridges[!direction+(shore?2:0)][i]).bridgeName]){
                [newBridgeOrder2 addObject:_bridges[!direction+(shore?2:0)][i]];
             
            }
        }
        j++;

    }
    
    _bridges[direction+(shore?2:0)] = newBridgeOrder1;
    _bridges[!direction+(shore?2:0)] = newBridgeOrder2;

}

-(void)reloadTableView{
    [self reorderRows];
    [_tableView reloadData];
    
}

@end
