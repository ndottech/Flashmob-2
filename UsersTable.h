//
//  UsersTable.h
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <AWSRuntime/AWSRuntime.h>


@interface UsersTable : UIViewController
{
    BOOL _doneLoading;
    BOOL searching;
    BOOL letUserSelectRow;
 UIAlertView *Nodata;
    NSString *nextToken;
    AmazonSimpleDBClient *sdbClient;

}

@property (nonatomic, retain) NSMutableArray *objUsers,*search_arr;
@property (nonatomic, retain) UsersList *objUserList;
@property(nonatomic,retain) NSString *get_event_id;

@property(nonatomic,retain) NSString *get_event_address;

@property (nonatomic,retain) IBOutlet UITableView *user_tbl;

@property (nonatomic,retain) IBOutlet UIAlertView *Nodata;
@property (nonatomic, retain) NSString *nextToken;
 

@property(nonatomic,retain) NSString *Event_user_id;
@property(nonatomic,retain) NSString *Event_addr_str;
@property(nonatomic,retain) NSString *Event_lat;
@property(nonatomic,retain) NSString *Event_long;
@property(nonatomic,retain) NSString *Event_meeting;

@property(nonatomic,retain) NSString *get_val;
@property(nonatomic,retain)IBOutlet UISearchBar *Favourite_search;

@property(nonatomic,retain)IBOutlet UIView *alert_view;

-(IBAction)back:(id)sender;
-(IBAction)ok:(id)sender;


@end
