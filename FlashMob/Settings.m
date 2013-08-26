//
//  Settings.m
//  FlashMob
//
//  Created by APPLE on 8/1/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "Settings.h"
#import "EventsTable.h"
#import "Reachability.h"
#import "ViewController.h"


@interface Settings ()

@end

@implementation Settings
@synthesize updatelocation_txt,update_current_txt,dis_no_lbl,updates_no_lbl;
NSUserDefaults *Device_lan1;
@synthesize tabBar;
@synthesize item1,item2;

UIActivityIndicatorView *activitidicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = NSLocalizedString(@"Events ", @"Settings");
    
    
    
    item1 = [[UITabBarItem alloc] initWithTitle:@"Events" image:[UIImage imageNamed:@"listtab.png"] tag:0];
    item2  = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"set_icon.png"] tag:1];
    
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    [tabBar setItems:items animated:NO];
    [tabBar setSelectedItem:[tabBar.items objectAtIndex:1]];
    
    // [tabBar setSelectedItem:nil];
    tabBar.delegate=self;
    
    [self.view addSubview:tabBar];

    
    
    dis_no_lbl.hidden=YES;
    updates_no_lbl.hidden=YES;
    
    // Do any additional setup after loading the view from its nib.
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

    
- (BOOL)textFieldShouldReturn:(UITextField *)textField
    
    {
        
        //CGRect viewFrame = self.view.frame;
        
        if(textField==updatelocation_txt)
            
        {
            if (updatelocation_txt.text.length==0)
            {
                dis_no_lbl.hidden=NO;
                [updatelocation_txt resignFirstResponder];
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
                    
                    [updatelocation_txt resignFirstResponder];

                    
                }
                
                else
                {
                    
                    NSString *update_str=updatelocation_txt.text;
                    
                    
                    
                    int sec = [update_str integerValue];
                                  
                    NSString *Get_update_status=@"UPDATEYES";
                    
                    
                    
                    [Device_lan1 setObject:Get_update_status forKey:@"UPDATESTATUS"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:sec] forKey:@"UPDATEOTHERUSER"];
                    
                    
                    
                    
                    [updatelocation_txt resignFirstResponder];
                    
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"User location updated given time interval" delegate:self
                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    
                    


                }

}
            
            
        }
        
        if(textField==update_current_txt)
            
        {
            if (update_current_txt.text.length==0)
            {
                updates_no_lbl.hidden=NO;
                [update_current_txt resignFirstResponder];
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
                    [update_current_txt resignFirstResponder];

                    
                    
                    
                }
                
                else
                {
                    
                    NSString *update_current_user_str=update_current_txt.text;
                    
                    
                    
                    int current_user = [update_current_user_str integerValue];
                                  
                    NSString *Get_current_update_status=@"CURRENTUSERUPDATES";
                    
                    
                    
                    [Device_lan1 setObject:Get_current_update_status forKey:@"CURRENTUSERSTATUS"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:current_user] forKey:@"UPDATECURRENT"];
                    
                    
                    
                    
                    [update_current_txt resignFirstResponder];
                    
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                        message:@"User location updated given time interval" delegate:self
                                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                    
                    

                    
                  

                    
                }

    }


        }

        }


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    }
    
    NSRange location = [string rangeOfCharacterFromSet:charSet];
    return (location.location == NSNotFound);
}

-(IBAction)event_btn:(id)sender
{
    
    
    activitidicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(150, 230, 30, 30)];
    [activitidicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activitidicator setColor:[UIColor blackColor]];
    [self.view addSubview:activitidicator];
    [activitidicator startAnimating];
    [self performSelector:@selector(calllevent) withObject:activitidicator afterDelay:0.0];
    

}




-(void)calllevent
{
    
            
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            EventsTable *nxtp = [[EventsTable alloc]initWithNibName:@"EventsTable" bundle:nil];
            
            
            [self.navigationController pushViewController:nxtp animated:NO];
            [activitidicator stopAnimating];
        });
        
    });
    

    
   }


-(IBAction)updateBtn:(id)sender
{
    NSLog(@"JK");
    
    ViewController *vc=[[ViewController alloc]init];
    
   
    
   // int update_int=[[update_current_txt.text]integerValue];
    
    
    [vc update_notify:5];
    

}

-(IBAction)back_btn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
