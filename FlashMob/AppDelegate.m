//
//  AppDelegate.m
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import <AWSRuntime/AWSRuntime.h>
#import "Reachability.h"
#import "EventsTable.h"
#import "Settings.h"

@implementation AppDelegate
//@synthesize locationManager,startLocation;
int bgTask;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    
     
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.mainnavigation = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.mainnavigation.navigationBarHidden = YES;
       
    self.window.rootViewController = self.mainnavigation;
    
    

#ifdef DEBUG
        
    //[AmazonLogger verboseLogging];
    [AmazonLogger turnLoggingOff];
#else
    [AmazonLogger turnLoggingOff];
#endif
    
    [AmazonErrorHandler shouldNotThrowExceptions];
    
    
                
        //}
    
    [self.window makeKeyAndVisible];
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    switch (netStatus){
        case ReachableViaWWAN:{
            break;
        }
        case ReachableViaWiFi:{
            break;
        }
        case NotReachable:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please connect to a WIFI network before starting the application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
