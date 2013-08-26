//
//  EventsTable.m
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//


#import "EventsTable.h"
#import "Events.h"

#import "eventcell.h"
#import "UsersTable.h"
#import "infoview.h"
#import "Settings.h"
#import "Reachability.h"


#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"
#define SECRET_KEY             @"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"
#define EVENT_DOMAIN    @"Events"
#define EVENT_COUNT_QUERY          @"select count(*) from Events"



@interface EventsTable ()
@end

@implementation EventsTable
Events *highScore ;

NSTimer *myTimer;
@synthesize events_tbl;
@synthesize nextToken;
@synthesize  array_events = _events;
@synthesize objEventsList = _objEventList;
int indexval;
UIActivityIndicatorView *activitidicator;
@synthesize no_lbl;
@synthesize lbl_str;
@synthesize event_name_txt;
NSString  *Userid_str;
NSString  *primarykey_count;
NSString *USER_ID1;
NSString *currentDate;
@synthesize event_name_lbl;
@synthesize tabController;
NSMutableArray* reversedArray;
@synthesize item1,item2;
@synthesize tabBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
          
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.events_tbl reloadData];
          
            
            
        });
        
    });

    
       

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _objEventList = [[EventsList alloc] init];
        _doneLoading = NO;
       
    }
    
    
    sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
    
    
    
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:EVENT_COUNT_QUERY];
    selectRequest.consistentRead = YES;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
    // NSLog(@"Error.......: %@", selectResponse);
    
    
    
    if(selectResponse.error != nil)
    {
        // NSLog(@"Error: %@", selectResponse.error);
        
    }
    
    SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
    primarykey_count=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
    
    return self;
}


-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return [attribute.value intValue];
        }
    }
    
    return 0;
}


- (void)viewDidLoad
{
          
    self.title = NSLocalizedString(@"Events ", @"Settings");
    
   
    item1 = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"listtab.png"] tag:0];
    item2  = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"set_icon.png"] tag:1];
    
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    [tabBar setItems:items animated:NO];
    [tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
    
   // [tabBar setSelectedItem:nil];
    tabBar.delegate=self;
    
    [self.view addSubview:tabBar];
    

    
    
     event_name_lbl.hidden=YES;
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    currentDate = [formatter stringFromDate:date];

            
 
    
       
    
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.ndot.in"];
	
    NetworkStatus internetStatus=[reach currentReachabilityStatus];
	
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
		
	{
		
		// *** ActivityIndicator Stop Animation *** //
		
		
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Unreach"
                                                            message:@"Check your network Connection" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
             
        
    }
    
    else
    {
    
    
             
    
       // Do any additional setup after loading the view from its nib.
    self.array_events =[[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
     
        [self.array_events addObjectsFromArray:[self.objEventsList getHighScores]];
        
     
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
                    
         [self.events_tbl reloadData];
         
        });
    });
      
}
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
                
        
    }
    else
    {
        Settings *addItemToListViewController = [[Settings alloc] initWithNibName: @"Settings" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
        [self presentModalViewController: navController animated: NO];
        
        
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(void)calladdevent

{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
      
        
        
        NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
        
        
        Userid_str =[Device_lan1 objectForKey:@"USERID"];
        
              
        Events *objEvents=[[Events alloc]initWithEvent:event_name_txt.text  EventItemName:USER_ID1  Createddate:currentDate userid:Userid_str ];
        
        
        EventsList *objEventsList = [[EventsList alloc] init];
        [objEventsList addEvents:objEvents];
        
        NSLog(@"....objusersList..%@",objEventsList);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [self viewDidLoad];
            
             [self.events_tbl reloadData ];
            
            
         
            
                  });
    });
    
  
    
    [event_name_txt resignFirstResponder];
    [activitidicator stopAnimating];
    event_name_txt.text=@"";
    
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        // indexval=indexPath.row;
    
    
    
  highScore = [reversedArray objectAtIndex:indexPath.row];

    
    activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
    [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activitidicator setColor:[UIColor blackColor]];
    [self.view addSubview:activitidicator];
    [activitidicator startAnimating];
    [self performSelector:@selector(callinfoview) withObject:activitidicator afterDelay:0.0];
}


-(IBAction)settings_btn:(id)sender
{
    
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.ndot.in"];
	
    NetworkStatus internetStatus=[reach currentReachabilityStatus];
	
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
		
	{
		
		// *** ActivityIndicator Stop Animation *** //
		
		
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Unreach"
                                                            message:@"Check your network Connection" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
               
        
        
    }
    
    else
    {

    activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
    [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activitidicator setColor:[UIColor blackColor]];
    [self.view addSubview:activitidicator];
    [activitidicator startAnimating];
    [self performSelector:@selector(callserrt) withObject:activitidicator afterDelay:0.0];

    
    
    }
}
-(void)callserrt
{
    Settings *nxtp = [[Settings alloc]initWithNibName:@"Settings" bundle:nil]
    ;
    [self.navigationController pushViewController:nxtp animated:NO];
    [activitidicator stopAnimating];

}


-(IBAction)aaa:(id)sender
{
    infoview *help = [[infoview alloc] initWithNibName:@"infoview" bundle:nil];
    [self.navigationController pushViewController:help animated:NO];

}

-(void)callinfoview
{
   
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    [Device_lan1 setObject:highScore.eventsItemName forKey:@"KEY"];

    
    infoview *addItemToListViewController = [[infoview alloc] initWithNibName: @"infoview" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
    
    [Device_lan1 setObject:highScore.eventsItemName forKey:@"EVENTID"];
    
    addItemToListViewController.Event_addr_str=@"";
    addItemToListViewController.Event_lat=@"";
    addItemToListViewController.Event_long=@"";
    addItemToListViewController.Event_meeting=highScore.eventName;
    addItemToListViewController.get_event_id=highScore.eventsItemName;
    [self presentModalViewController: navController animated: NO];
    
    
    
     
    
    
    [activitidicator stopAnimating];
    

}





-(IBAction)back_button:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
          
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
        
    return [self.array_events count];
    
    
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    
    if (indexPath.row == [self.array_events count] - 1
        && _doneLoading == NO) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });
            
           NSArray *newScores = [self.objEventsList getNextPageOfScores];
            if(newScores == nil || [newScores count] == 0)
            {
                _doneLoading = YES;
            }
            else
            {
                [self.array_events addObjectsFromArray:newScores];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self.events_tbl reloadData];
            });
        });
    }

    static NSString *CellIdentifier = @"Cell";
    
    eventcell *cell = (eventcell *)[events_tbl dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"eventcell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
         cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        

    }

      
    reversedArray = [[NSMutableArray alloc] initWithArray:[[[[NSArray alloc] initWithArray: self.array_events] reverseObjectEnumerator] allObjects]];
   
    
        Events *highScore = [reversedArray objectAtIndex:indexPath.row];
                     
        cell.titleLable.text =[NSString stringWithFormat:@"%@",highScore.eventName];
              
        
         
    return cell;
   
}




-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
      
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });
            
         
            
            
             [self.array_events removeObjectAtIndex:indexPath.row];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
                [events_tbl beginUpdates];
                [events_tbl deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [events_tbl endUpdates];
            });
        });
    }
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    
    
    
    if(textField==event_name_txt)
        
    {
        if (event_name_txt.text.length==0)
        {
            event_name_lbl.hidden=NO;
            [event_name_txt resignFirstResponder];
        }
        else
        {
            
            Reachability *reach=[Reachability reachabilityWithHostName:@"www.ndot.in"];
            
            NetworkStatus internetStatus=[reach currentReachabilityStatus];
            
            if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
                
            {
                
                // *** ActivityIndicator Stop Animation *** //
                
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Unreach"
                                                                    message:@"Check your network Connection" delegate:self
                                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                
                
            }
            
            else
            {
                
                
                
                
                
                
                int value;
                int value1;
                
                value=[primarykey_count intValue];
                value1=value+1;
                USER_ID1=[NSString stringWithFormat:@"%d",value1];
                
                
                
                
                
                if (event_name_txt.text.length==0)
                {
                    
                }
                
                else
                {
                    
                    
                    
                    activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
                    [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    [activitidicator setColor:[UIColor blackColor]];
                    [self.view addSubview:activitidicator];
                    [activitidicator startAnimating];
                    [self performSelector:@selector(calladdevent) withObject:activitidicator afterDelay:0.0];
                    
                    
                    
                    
                    
                    
                }
            }
            
            
            
            
            
            
        }
    }
    
    
    
}

            

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

