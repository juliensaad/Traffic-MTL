//
//  TMAppDelegate.m
//  Traffic MTL
//
//  Created by Julien Saad on 2014-05-22.
//  Copyright (c) 2014 Développements Third Bridge Inc. All rights reserved.
//

#import "TMAppDelegate.h"
#import "DemoMenuController.h"
#import "TMViewController.h"


@interface TMAppDelegate ()

@property (nonatomic, strong) DemoMenuController *menuController;
@end


@implementation TMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
 
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // GOogle analytics
    // 1
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelNone];
    
    // 3
    [GAI sharedInstance].dispatchInterval = 20;
    
    // 4
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-52250247-1"];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"didCompleteTutorial"]){
        
        // Launch side menu and Main View
        _menuController = [[DemoMenuController alloc] initWithMenuWidth:MENU_WIDTH];
        NSMutableArray *viewControllers = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 1; i++)
        {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            TMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainController"];
            
            [viewControllers addObject:vc];
            
            [vc setSideMenu:_menuController];
        }
        
        [_menuController setViewControllers:viewControllers];
        
        [self.window setRootViewController:_menuController];
        
    }else{
        // Set default language from device
        [[NSUserDefaults standardUserDefaults] setBool:(![[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"] )forKey:@"lang"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    return YES;
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
