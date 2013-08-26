//
//  ViewController.h
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <AWSRuntime/AWSRuntime.h>
#import <CoreLocation/CoreLocation.h>

@class EventsTable;

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    AmazonSimpleDBClient *sdbClient;
    NSString             *nextToken;

    
    CLLocationManager *locationManager;
    CLLocation *startLocation;

}
@property (nonatomic, retain) NSString *nextToken;

@property (nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain) CLLocation *startLocation;
@property(nonatomic,retain)IBOutlet UITextField *first_Name;
@property(nonatomic,retain)IBOutlet UITextField *last_Name;
@property(nonatomic,retain)IBOutlet UITextField *email_ID;
@property(nonatomic,retain)IBOutlet UITextField *password_txt;

@property (nonatomic, strong) UITabBarController *tabController;

-(void)update_notify:(int)check;

-(IBAction)register_button:(id)sender;

-(IBAction)cancel_button:(id)sender;


@end
