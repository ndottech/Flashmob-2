//
//  ViewController.m
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "ViewController.h"
#import "UsersList.h"
#import "UsersTable.h"

#import "Reachability.h"
#import "EventsTable.h"
#import "Settings.h"


#define COUNT_QUERY          @"select count(*) from Users"

#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"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"

#define USERS_DOMAIN    @"Users"

#define LATITUDE      @"latitude"

#define LONGITUDE     @"longitude"



@interface ViewController ()

@end

@implementation ViewController
@synthesize first_Name;
@synthesize last_Name;
@synthesize email_ID;

@synthesize locationManager;
@synthesize startLocation;
@synthesize nextToken;

NSString *USER_ID;

NSString *USER_ID1;
NSString *primary_keycount;

NSString *currentLatitude;
NSString *currentLongitude ;


NSString *old_currentLatitude;
NSString *old_currentLongitude ;





NSString *currentDate;
NSString *Userid;
UIActivityIndicatorView *activitidicator;
NSString *Login_status;
NSString *email_id_string;
NSString *email;
NSMutableArray *email_arr;

NSString *get_email_str;
@synthesize password_txt;
@synthesize tabController;
NSUserDefaults *local_storage;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    email_arr=[[NSMutableArray alloc]init];
    
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
        
        

    }

    
   NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
         
   Login_status =[Device_lan1 objectForKey:@"LOGIN"];
    
    //NSLog(@"MYNA:%@",udhaya);
        
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        float lat=manager.location.coordinate.latitude;
        float lon=manager.location.coordinate.longitude;
     
   if (![Login_status length]==0) {
       
       
       EventsTable *addItemToListViewController = [[EventsTable alloc] initWithNibName: @"EventsTable" bundle:nil];
       UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
       [self presentModalViewController: navController animated: NO];
       
           
   }
    
      
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
     currentDate = [formatter stringFromDate:date];
  
       
   
    sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
    
       
    
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:COUNT_QUERY];
    selectRequest.consistentRead = YES;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
 
    
    
    
    if(selectResponse.error != nil)
    {
     
        
    }
    
    SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
    
    
    
    primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
    

    

         
        SimpleDBSelectRequest *selectRequest1 = [[SimpleDBSelectRequest alloc] initWithSelectExpression:[NSString stringWithFormat:@"select emailID from Users"]];
        selectRequest1.consistentRead = YES;
        selectRequest1.nextToken = nextToken;
        
        SimpleDBSelectResponse *selectResponse1 = [sdbClient select:selectRequest1];
        
        
        nextToken = selectResponse1.nextToken;
        
        
        
        NSString *strvalue = [NSString stringWithFormat:@"%@",selectResponse1];
        
        NSArray *responsearray = [strvalue componentsSeparatedByString:@"\n"];
        
      
        for(int i=1; i<[responsearray count]-1;i++)
        {
            
            
            NSArray *responsearray1 = [[responsearray objectAtIndex:i] componentsSeparatedByString:@","];
          
            
            NSString *latitudestr = [[responsearray1 objectAtIndex:4] stringByReplacingOccurrencesOfString:@"Value: " withString:@""];
            
            [email_arr addObject:latitudestr];
          
        }
        
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               [self map];
            });
            
        });
      
    }
   
      
	

-(IBAction)cancel_button:(id)sender
{
    first_Name.text=@"";
    last_Name.text=@"";
    email_ID.text=@"";
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

-(void)map{
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    startLocation = nil;
}
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation


{
    currentLatitude = [[NSString alloc] initWithFormat:@"%g",
                                 newLocation.coordinate.latitude];
    
    currentLongitude = [[NSString alloc] initWithFormat:@"%g",
                        newLocation.coordinate.longitude];
    
    old_currentLatitude = [[NSString alloc] initWithFormat:@"%g",
                       oldLocation.coordinate.latitude];
       
    
    old_currentLongitude = [[NSString alloc] initWithFormat:@"%g",
                        oldLocation.coordinate.longitude];
    
    
    
     float lat_new=[currentLatitude floatValue];
     float lang_new=[currentLongitude floatValue];
     float lat_old=[old_currentLatitude floatValue];
     float lang_old=[old_currentLongitude floatValue];
    
    
      
    if (lat_new==lat_old &&lang_new==lang_old) {
        
        // NSLog(@" NOT UPDATEEEE");
        
     
        
               
    }
    else
    {
        
               
         [self updateotheruserlocation];
                       
       // NSLog(@" UPDATEEEE");

    }
    
     
    
    local_storage = [NSUserDefaults standardUserDefaults];
    [local_storage setObject:currentLatitude forKey:@"CLAT"];
    
    [local_storage setObject:currentLongitude forKey:@"CLAG"];

    [locationManager startUpdatingLocation];
    
 
    get_email_str =[local_storage objectForKey:@"EMAIL"];
    
       
    
    
}




-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Fail to take");
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
      
     [locationManager startUpdatingLocation];
}

-(IBAction)register_button:(id)sender
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
    
    value=[primary_keycount intValue];
    value1=value+1;
    USER_ID1=[NSString stringWithFormat:@"%d",value1];
  
          
    
    NSString* emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString *subjectString =email_ID.text;
        NSString *validate=subjectString;
    
    
    if (first_Name.text.length ==0 && last_Name.text.length==0 && email_ID.text.length==0 ) {
        
        [self DialogAlert:@"All fields are mandatory"];

        
       
    }
    else if (first_Name.text.length==0)
    {
           [self DialogAlert:@"Enter the firstname"];
    }
    
    else if (last_Name.text.length==0)
    {
        [self DialogAlert:@"Enter the Lastname"];
    }
       else if([emailTest evaluateWithObject:subjectString] == NO)
    {
        
        [self DialogAlert:@"Enter valid mail Id"];

         
    }
        
       else if([email_arr containsObject:validate])
       {
           [self DialogAlert:@"Email id already exist"];
       }
       else
       {
           
           
          
           
           
           activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
           [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
           [activitidicator setColor:[UIColor blackColor]];
           [self.view addSubview:activitidicator];
           [activitidicator startAnimating];
           [self performSelector:@selector(callregsubmit) withObject:activitidicator afterDelay:0.0];
           
           
           
       }



}
}


-(void)callregsubmit
    {
                   
           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
           dispatch_async(queue, ^{
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
               });
               
               
               
                             
               
               Users  *objusers     = [[Users alloc] initWithPlayer:first_Name.text LastName:last_Name.text EmailID:email_ID.text ItemName:USER_ID1 Longitude:currentLatitude Latitude:currentLongitude CreatedDate:currentDate Password:password_txt.text ];
               
                 email_id_string=email_ID.text;
               
               
               
               NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
               [Device_lan1 setObject:email_id_string forKey:@"EMAIL"];
               
               
                         
               UsersList *objusersList = [[UsersList alloc] init];
               [objusersList addUsers:objusers];
               
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                   
                  // [self dismissViewControllerAnimated:YES completion:nil];
                   
                   NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
                   [Device_lan1 setObject:USER_ID1 forKey:@"USERID"];
                   
                   
                    Userid =[Device_lan1 objectForKey:@"USERID"];
                 [Device_lan1 setObject:Userid forKey:@"LOGIN"];
                                     
                  // [tabController setSelectedIndex:0];
                  // [self presentViewController: tabController animated:YES completion:NULL];
                
                   
                   EventsTable *addItemToListViewController = [[EventsTable alloc] initWithNibName: @"EventsTable" bundle:nil];
                   UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
                   [self presentModalViewController: navController animated: NO];

                   
               });
           });
                
       }
       
-(void)update_notify:(int)check
{
    NSLog(@"Notify Value:%d",check);
    
    [NSTimer scheduledTimerWithTimeInterval:check target:self selector:@selector(updateotheruserlocation) userInfo:nil repeats:YES];
}

           

-(void)updateotheruserlocation
{
    NSLog(@"HELLO");
        
    SimpleDBReplaceableAttribute *lat = [[SimpleDBReplaceableAttribute alloc] initWithName:LATITUDE andValue:currentLatitude andReplace:YES] ;
    
    SimpleDBReplaceableAttribute *lang  = [[SimpleDBReplaceableAttribute alloc] initWithName:LONGITUDE andValue:currentLongitude andReplace:YES];
    
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:1];
    [attributes addObject:lat];
    [attributes addObject:lang];
        
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:USERS_DOMAIN andItemName:get_email_str andAttributes:attributes];
    
    SimpleDBPutAttributesResponse *putAttributesResponse = [sdbClient putAttributes:putAttributesRequest];
    if(putAttributesResponse.error != nil)
    {
        //NSLog(@"Error123: %@", putAttributesResponse.error);
    }
    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == first_Name) {
        [first_Name resignFirstResponder];
        [last_Name becomeFirstResponder];
    }
    if (textField == last_Name) {
        [last_Name resignFirstResponder];
        [email_ID becomeFirstResponder];
    }
    if (textField == email_ID) {
        [email_ID resignFirstResponder];
    }
    
    if (textField == password_txt) {
        [password_txt resignFirstResponder];
    }

    return YES;
}


-(void)DialogAlert:(NSString *)alert_text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:alert_text delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK" , nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
