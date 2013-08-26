//
//  AppDelegate.h
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
   Reachability *internetReach;
}

@property (strong, nonatomic) UITabBarController *tabBarController;


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *mainnavigation;

@property (strong, nonatomic) ViewController *viewController;


@end
