//
//  infoview.m
//  FlashMob
//
//  Created by APPLE on 7/30/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "infoview.h"
#import "MyAnnotation.h"
#import "UsersTable.h"
#import "MKMapView+ZoomLevel.h"
#import "Reachability.h"
#import "Settings.h"
#import "EventsTable.h"
#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"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"


#import<QuartzCore/QuartzCore.h>
#import "EventsTable.h"

@interface infoview ()

@end

@implementation infoview

@synthesize get_event_id;
int indexval;
@synthesize user_tbl;
@synthesize objUsers = objUsers;
@synthesize objUserList = _objUserList;
NSString *currentDate;
@synthesize Event_addr_str,Event_lat,Event_long,Event_meeting;
NSMutableArray *userid_arr;
NSMutableArray *lat_arr;
NSMutableArray *long_arr;
UIActivityIndicatorView *activitidicator;
NSMutableArray *useridArr1;
NSMutableArray *usernamearr1;
int zoompoint;
NSMutableArray *username_arr;
NSString *get_view;
NSMutableArray *total_arr;

NSMutableArray *get_arr;
@synthesize mapView;
NSString *user_id_str;
NSString *lat_str;
NSString *lang_str;
@synthesize nextToken;

@synthesize event_tile;
@synthesize tabController;
@synthesize item1,item2;
@synthesize tabBar;
NSString *current_title;

NSUserDefaults *Device_lan1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _objUserList = [[MainEventsList alloc] init];
        
        _doneLoading = NO;
        
                
    }
   
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
   
    
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
        
      
        self.title = NSLocalizedString(@"Crops ", @"Articles");
            
           
        
        item1 = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"listtab.png"] tag:0];
        item2  = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"set_icon.png"] tag:1];
        
        NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
        [tabBar setItems:items animated:NO];
        [tabBar setSelectedItem:[tabBar.items objectAtIndex:1]];
        tabBar.delegate=self;
                
        [self.view addSubview:tabBar];
        
        
        
       
        Device_lan1 = [NSUserDefaults standardUserDefaults];
        [Device_lan1 setObject:@"YES" forKey:@"K"];
        

            
     [user_tbl reloadData];
     [mapView removeAnnotations:mapView.annotations];
      
       
    
    //create function
   
   

    
    event_tile.text=Event_meeting;
   
    
      
    self.objUsers =[[NSMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
        
        [self.objUsers addObjectsFromArray:[self.objUserList getHighScores]];
        int  highScoreCount = [self.objUserList highScoreCount];
        
        
       
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            self.title = [NSString stringWithFormat:@"High Scores (%d)", highScoreCount];
            
            
            [self call_user_values];
            
            [self.user_tbl reloadData];
        });
    });
    
    
    
     
    
   // [self.user_tbl reloadData];
    
    }
        


    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.user_tbl reloadData];
            
            
            
            
        });
        
    });

  

    // Do any additional setup after loading the view from its nib.
}






-(void)call_user_values
{
    username_arr=[[NSMutableArray alloc]init];
    useridArr1=[[NSMutableArray alloc]init];
    
    lat_arr=[[NSMutableArray alloc]init];
    long_arr=[[NSMutableArray alloc]init];
    
    
    
  
    if ([self.objUsers count]>0)
    {
        
        
        
        for (int i=0; i<[self.objUsers count]; i++)
        {
            
            
            
            
            MainEvents *highScore = [self.objUsers objectAtIndex:i];
            
            [useridArr1 addObject:highScore.userid];
            
            
        }
       
        
        
        
        
        for (int i=0; i<[useridArr1 count]; i++)
        {
            NSString *firstname = [useridArr1 objectAtIndex:i];
            
            
            
            
            sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
            sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
            
            self.nextToken = nil;
            
            
            
            SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:[NSString stringWithFormat:@"select firstName,latitude,longitude from Users where userid='%@'", firstname]];
            
            
          
            selectRequest.consistentRead = YES;
            selectRequest.nextToken = nextToken;
            
            SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
            
            
            nextToken = selectResponse.nextToken;
            
            
            
            NSString *strvalue = [NSString stringWithFormat:@"%@",selectResponse];
            
            NSArray *responsearray = [strvalue componentsSeparatedByString:@"\n"];
            
            NSString *str2 = [responsearray objectAtIndex:1];
            
            NSArray *responsearray1 = [str2 componentsSeparatedByString:@","];
            
            NSString *latitudestr = [[responsearray1 objectAtIndex:4] stringByReplacingOccurrencesOfString:@"Value: " withString:@""];
            
            
            
            [long_arr addObject:latitudestr];
            
         
            
            
            
            NSString *longitudestr = [[responsearray1 objectAtIndex:9] stringByReplacingOccurrencesOfString:@"Value: " withString:@""];
            
            
            [lat_arr addObject:longitudestr];
           
            
            
            NSString *namestr = [[responsearray1 objectAtIndex:14] stringByReplacingOccurrencesOfString:@"Value: " withString:@""];
            [username_arr addObject:namestr];
            
         
            
            
            
            
        }
        
    }
    
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self LoadMapview];
            
        });
        
    });
    
    

}






- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
        EventsTable *addItemToListViewController = [[EventsTable alloc] initWithNibName: @"EventsTable" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
       [self presentModalViewController: navController animated: NO];
        

    }
    else
    {
        Settings *addItemToListViewController = [[Settings alloc] initWithNibName: @"Settings" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addItemToListViewController];
        [self presentModalViewController: navController animated: NO];
        

    }
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    zoompoint = [mapView zoomLevel];
    
    
       
 [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:zoompoint] forKey:@"ZP"];
   
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








-(void)LoadMapview
{
    
   
    [mapView removeAnnotations:mapView.annotations];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.span = span;
    span.latitudeDelta = 0.060529;
    span.longitudeDelta = 0.060529;
    region.span = span;
     
	NSMutableArray* annotations=[[NSMutableArray alloc] init];
    
   
    
	CLLocationCoordinate2D theCoordinate1;
    
              
    mapView.delegate=self;
        
    CLLocationManager *manager = [[CLLocationManager alloc] init];
       float lat=manager.location.coordinate.latitude;
        float lon=manager.location.coordinate.longitude;
    
       
    CLLocationCoordinate2D c;
    c.latitude =  lat;
    c.longitude = lon;
      
    mapView.delegate=self;
    
    
    MyAnnotation* myAnnotation2=[[MyAnnotation alloc] init];
    myAnnotation2.coordinate=c;
      current_title=@"Current Location";
    myAnnotation2.title=current_title;
    
   
    [annotations addObject:myAnnotation2];
          
    
    for(int cor=0; cor<[useridArr1 count];cor++)
        
	{
        	
		      
        
        theCoordinate1.latitude = [[lat_arr objectAtIndex:cor]floatValue];
        
        theCoordinate1.longitude = [[long_arr objectAtIndex:cor]floatValue];
	
		MyAnnotation* myAnnotation1=[[MyAnnotation alloc] init];
        myAnnotation1.coordinate=theCoordinate1;
        myAnnotation1.image=[UIImage imageNamed:@"usericon.png"];

        myAnnotation1.title=[username_arr objectAtIndex:cor];
                
                       
		[annotations addObject:myAnnotation1];
        
       
        
	}
	
	for(int i=0; i<[annotations count];i++)
        
	{
        
		[mapView addAnnotation:[annotations objectAtIndex:i]];
        
	}
    
	   
    
     get_view =[Device_lan1 objectForKey:@"K"];
    
    if ([get_view isEqualToString:@"YES"]) {
        
    
    
    
	
	MKMapRect flyTo = MKMapRectNull;
    
	for (id <MKAnnotation> annotation in annotations)
        
    {
        
		
        
		MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        
		MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
		if (MKMapRectIsNull(flyTo))
            
        {
            
                        
			flyTo = pointRect;
            
		}
        
        
        else
            
        {
            
			flyTo = MKMapRectUnion(flyTo, pointRect);
            
		}
         
	}
	
	mapView.visibleMapRect = flyTo;
    }
    else
    {
        
    }
    
    
   
    
    NSInteger get_update = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UPDATEOTHERUSER"] intValue];
    
    
    
    
   NSString *updatestatus =[Device_lan1 objectForKey:@"UPDATESTATUS"];
   
    
        
    if ([updatestatus isEqualToString:@"UPDATEYES"]) {
        
       
        
        [self performSelector:@selector(reloadTableview) withObject:nil afterDelay:get_update];
        

    }
    else
    {
        
         
        [self performSelector:@selector(reloadTableview) withObject:nil afterDelay:10];

    }
   
    
  
    
  }




-(void)reloadTableview
{
    //NSLog(@"######");
    
    [self call_user_values];

    
            [Device_lan1 setObject:@"NO" forKey:@"K"];
            
            Device_lan1 = [NSUserDefaults standardUserDefaults];
            [Device_lan1 setObject:@"N" forKey:@"ONE"];


            
        
    
   
}




-(IBAction)event_btn:(id)sender
{
    
    activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
    [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activitidicator setColor:[UIColor blackColor]];
    [self.view addSubview:activitidicator];
    [activitidicator startAnimating];
    [self performSelector:@selector(callback) withObject:activitidicator afterDelay:0.0];
    

}




-(IBAction)zoom_event:(id)sender
{
    
    
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    float lat=manager.location.coordinate.latitude;
    float lon=manager.location.coordinate.longitude;
    
    
    CLLocationCoordinate2D c;
    c.latitude =  lat;
    c.longitude = lon;
    // region.center = c;
    [mapView setCenterCoordinate:c zoomLevel:7.5 animated:NO];

    
       
    }






- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    
        
    MKPinAnnotationView *view = nil;
    if (annotation != mapView.userLocation) {
        view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        if (nil == view) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }
        
        UIImageView *thumbnailImageView = [[UIImageView alloc] initWithImage:((MyAnnotation *)annotation).image];
        
        
              
        
        if ([annotation.title isEqualToString:current_title]) {
            
            
            
            view.opaque=YES;
            view.image=[UIImage imageNamed:@"current.png"];
            [view setCanShowCallout:YES];
            [view setAnimatesDrop:NO];
          
                      
            // pinView.pinColor=MKPinAnnotationColorRed;
            
        }
        else{
            
           
            
            view.opaque=YES;
            view.image=[UIImage imageNamed:@"user.png"];
            [view setCanShowCallout:YES];
            [view setAnimatesDrop:NO];

            
            //  pinView.pinColor=MKPinAnnotationColorGreen;
            //[view setPinColor:MKPinAnnotationColorGreen];
            
        }
        //annView.opaque = YES;
        
        view.opaque=YES;
        
        
        
        [view setCanShowCallout:YES];
        [view setAnimatesDrop:NO];
    }
    else {
        // Do something with the user location view
    }
    return view;
}




-(void)callback
{
    EventsTable *nxtp = [[EventsTable alloc]initWithNibName:@"EventsTable" bundle:nil];
    
    
    [self.navigationController pushViewController:nxtp animated:YES];
    [activitidicator stopAnimating];
}





-(IBAction)moreuser:(id)sender
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
        [self performSelector:@selector(moreusercall) withObject:activitidicator afterDelay:0.0];
        
        

          
}
}


-(void)moreusercall
{
     NSString *send_val=@"VAL";
    
    
    UsersTable *nxtp = [[UsersTable alloc] initWithNibName: @"UsersTable" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:nxtp];
    
    nxtp.get_event_id=get_event_id;
    
    nxtp.Event_addr_str=Event_addr_str;
    nxtp.Event_lat=Event_lat;
    nxtp.Event_long=Event_long;
    nxtp.Event_meeting=Event_meeting;
    nxtp.get_val=send_val;

  
    [self presentModalViewController: navController animated: NO];

    
      
    [activitidicator stopAnimating];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    lat_arr=nil;
    long_arr=nil;
    useridArr1=nil;
    mapView=nil;
      
    // Dispose of any resources that can be recreated.
}

@end
