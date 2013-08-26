//
//  infoview.h
//  FlashMob
//
//  Created by APPLE on 7/30/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainEvents.h"
#import "MainEventsList.h"
#import <MapKit/MapKit.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <AWSRuntime/AWSRuntime.h>
#import <CoreLocation/CoreLocation.h>




@interface infoview : UIViewController<MKMapViewDelegate,UITabBarDelegate>
{
    AmazonSimpleDBClient *sdbClient;
    BOOL _doneLoading;
    
      NSString             *nextToken;
   
   
}

@property (nonatomic, retain) NSString *nextToken;
@property (nonatomic, retain) NSMutableArray *objUsers;
@property (nonatomic, retain) MainEventsList *objUserList;
@property(nonatomic,retain) NSString *get_event_id;

@property (nonatomic,retain) IBOutlet UITableView *user_tbl;
@property(weak, nonatomic) IBOutlet MKMapView * mapView;

@property(nonatomic,retain) NSString *Event_addr_str;
@property(nonatomic,retain) NSString *Event_lat;
@property(nonatomic,retain) NSString *Event_long;
@property(nonatomic,retain) NSString *Event_meeting;

@property (nonatomic, strong) UITabBar *tabController;

@property(nonatomic, retain) UITabBarItem *item1;
@property(nonatomic, retain) UITabBarItem *item2;

@property(nonatomic,retain) IBOutlet UILabel *event_tile;

@property (nonatomic, strong) IBOutlet  UITabBar *tabBar;


-(IBAction)setting_btn:(id)sender;

-(IBAction)zoom_event:(id)sender;
-(IBAction)event_btn:(id)sender;



-(IBAction)back:(id)sender;



-(IBAction)moreuser:(id)sender;




@end
