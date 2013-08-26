//
//  UsersTable.m
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "UsersTable.h"
#import "EventsTable.h"
#import "MainEvents.h"
#import "MainEventsList.h"
#import "infoview.h"
#import "Reachability.h"


#define ZOOM_LEVEL 14


#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"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"


@interface UsersTable ()

@end

@implementation UsersTable
@synthesize get_event_id;
@synthesize user_tbl;
@synthesize objUsers = objUsers;
@synthesize objUserList = _objUserList;
@synthesize get_event_address;
@synthesize Event_addr_str,Event_lat,Event_long,Event_meeting,get_val;
@synthesize Favourite_search;
@synthesize search_arr;
@synthesize nextToken;
@synthesize Event_user_id;
@synthesize alert_view;

int indexval;
int k;

NSString *currentDate;
NSString *First_name;
NSString *latitudestr;
NSString *user_count;

NSMutableArray *username_arr;
NSMutableArray *test_arr;
NSMutableArray *add_user;







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _objUserList = [[UsersList alloc] init];
        
        _doneLoading = NO;
   
    
       
    }
    return self;
}

-(IBAction)back:(id)sender
{
    
    infoview *nxtp = [[infoview alloc] initWithNibName: @"infoview" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nxtp];
       
    [self presentModalViewController: navController animated: NO];

    
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.ndot.in"];
	
    NetworkStatus internetStatus=[reach currentReachabilityStatus];
	
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
		
	{
		
			
		
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Network Unreach"
                                                            message:@"Check your network Connection" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
             
        
    }
    
    else
    {


    test_arr=[[NSMutableArray alloc]init];
    
          
       
    alert_view.hidden=YES;
    
    search_arr=[[NSMutableArray alloc]init];
    
    add_user=[[NSMutableArray alloc]init];
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    currentDate = [formatter stringFromDate:date];
           
    self.objUsers =[[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        [self.objUsers addObjectsFromArray:[self.objUserList getHighScores]];
         int highScoreCount = [self.objUserList highScoreCount];
        
               
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            self.title = [NSString stringWithFormat:@"High Scores (%d)", highScoreCount];
            
           [self.user_tbl reloadData];
        });
    });
    
     [self.user_tbl reloadData];
}
}


-(IBAction)back_button:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searching)
    {
        return 1;
    }
    else
    {

    return 1;
    }
    

    }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    if ([self.objUsers count]>0)
    {
        
        
        username_arr=[[NSMutableArray alloc]init];
        
              
             
        for (int i=0; i<[self.objUsers count]; i++)
        {
            
            
            
            
            Users *highScore = [self.objUsers objectAtIndex:i];
            
            [username_arr addObject:highScore.firstName];
        }
        
            
        }
        
    if (searching)
    {
        return [search_arr count];
    }
    else
    {
         return [self.objUsers count];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar

{
    
	Favourite_search.text =nil;
	
    [Favourite_search resignFirstResponder];
	
    searching = NO;
	
    letUserSelectRow = YES;
    
    [user_tbl reloadData];
	
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar

{
	
    Favourite_search.showsScopeBar = NO;
	
    [Favourite_search setShowsCancelButton:NO animated:YES];
	
    return YES;
	
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar

{
	
    Favourite_search.showsScopeBar = YES;
	
    [Favourite_search setShowsCancelButton:NO animated:YES];
	
    Favourite_search.autocorrectionType=UITextAutocorrectionTypeNo;
	
    return YES;
    
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText

{
	  [search_arr removeAllObjects];
   	
    k = 0;
	
	if([searchText length] > 0)
		
    {
		
        searching = YES;
		
        letUserSelectRow = YES;
		
        [self searchTableView];
		
    }
	
    else
		
    {
		
        searching = NO;
		
        letUserSelectRow = NO;
		
    }
    
	[user_tbl reloadData];
	
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar

{
	
	@try
	
	{
        
		user_tbl.scrollEnabled = YES;
		
		[user_tbl reloadData];
		
		[Favourite_search resignFirstResponder];
		
	}
	
	@catch (NSException *e)
	
	{
		
		[Favourite_search resignFirstResponder];
		
	}
    
}

- (void) searchTableView

{
	k=0;
	NSString *searchText = Favourite_search.text;
	
	for (NSString *sTemp in username_arr)
        
        
		
	{
		
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			
        {
			                       
            [search_arr addObject:sTemp];
            
         			
        }
        
		k++;
	}
	
	[user_tbl reloadData];
    
    
    if ([search_arr count]==0)
    {
      
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.objUsers count] - 1 &&_doneLoading == NO)
        {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            });
            
            NSArray *newScores = [self.objUserList getNextPageOfScores];
            if(newScores == nil || [newScores count] == 0)
            {
                _doneLoading = YES;

            }
            else
            {
                [self.objUsers addObjectsFromArray:newScores];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self.user_tbl reloadData];
            });
        });
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellStateShowingEditControlMask;
    }
    
    
    if (searching)
    {
       
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[search_arr objectAtIndex:indexPath.row]];
        
                 
                      
    }
    else
    {
      
        Users *highScore = [self.objUsers objectAtIndex:indexPath.row];
        ;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",highScore.firstName];
        
        
        }
        

    
      
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    indexval=indexPath.row;
       
    sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc]
                                            initWithSelectExpression:[NSString stringWithFormat:@"select firstname from EventList where eventId='%@'",get_event_id]];
    selectRequest.consistentRead = YES;
    
    selectRequest.nextToken = nextToken;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
    
    nextToken = selectResponse.nextToken;
     
    
    NSString *strvalue = [NSString stringWithFormat:@"%@",selectResponse];
    
    NSArray *responsearray = [strvalue componentsSeparatedByString:@"\n"];
    
    
    for(int i=1; i<[responsearray count]-1;i++)
    {
              
        NSArray *responsearray1 = [[responsearray objectAtIndex:i] componentsSeparatedByString:@","];
            
        latitudestr = [[responsearray1 objectAtIndex:4] stringByReplacingOccurrencesOfString:@"Value: " withString:@""];
        
         
        [test_arr addObject:latitudestr];
        
        
       
    }
    
       
    Users *highScore = [self.objUsers objectAtIndex:indexPath.row];
    
     
       int checkValue=0;
    
    
    
    
    if ([test_arr containsObject:highScore.firstName])
    {
        checkValue=1;

    }
    else
    {
        checkValue=0;

    }
    
    
    
    if (checkValue==1) {
        
            
        Nodata=[[UIAlertView alloc]initWithTitle:@"Information" message:@"User already exist,choose different user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Nodata show];
    }

else{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        
        
        
        
        
        Users *highScore = [self.objUsers objectAtIndex:indexval];
        ;
        
        
        MainEvents *objusers = [[MainEvents alloc]initWithPlayer:highScore.itemname EventID:get_event_id ItemName:highScore.firstName];
        MainEventsList *objEventMainList = [[MainEventsList alloc]init];
        [objEventMainList addEventList:objusers];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            
            if ([get_val isEqualToString:@"VAL"]) {
                
                
                infoview *nxtp = [[infoview alloc] initWithNibName: @"infoview" bundle:nil];
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nxtp];
                nxtp.Event_addr_str=Event_addr_str;
                nxtp.Event_lat=Event_lat;
                nxtp.Event_long=Event_long;
                nxtp.Event_meeting=Event_meeting;
                nxtp.get_event_id=get_event_id;
                
                
                [self presentModalViewController: navController animated: NO];
                
                
              
                
            }
            else
            {
                
              
            }
                 
        });
    });
    
    
    // iPhone-specific code
}
    

}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {

        
        }
}





-(IBAction)ok:(id)sender
{
    alert_view.hidden=YES;
}

@end
