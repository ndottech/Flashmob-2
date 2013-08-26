//
//  EventsTable.h
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsList.h"
#import <AWSSimpleDB/AWSSimpleDB.h>

@interface EventsTable : UIViewController<UITabBarDelegate>
{
    AmazonSimpleDBClient *sdbClient;
    NSString             *nextToken;

    BOOL _doneLoading;
}

@property (nonatomic, retain) NSString *nextToken;


@property (nonatomic, retain) NSMutableArray *array_events;
@property (nonatomic, retain) EventsList *objEventsList;
@property (nonatomic, assign) int sortMethod;

@property (nonatomic,retain) IBOutlet UITableView *events_tbl;
-(id)initWithSortMethod:(int)theSortMethod;
-(IBAction)addevent:(id)sender;

-(IBAction)settings_btn:(id)sender;

-(IBAction)aaa:(id)sender;

-(IBAction)event_btn:(id)senderl;
@property(nonatomic,retain) IBOutlet UILabel *no_lbl;
@property(nonatomic,retain) IBOutlet UILabel *event_name_lbl;
@property(nonatomic,retain)  NSString *lbl_str;
@property(nonatomic,retain) IBOutlet UITextField *event_name_txt;
@property (nonatomic, strong) UITabBarController *tabController;
@property(nonatomic, retain) UITabBarItem *item1;
@property(nonatomic, retain) UITabBarItem *item2;
@property(nonatomic, retain) IBOutlet UITabBar *tabBar;



-(IBAction)add_event:(id)sender;



@end
