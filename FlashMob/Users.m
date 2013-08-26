//
//  Users.m
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "Users.h"

@implementation Users

@synthesize firstName;
@synthesize lastName;
@synthesize emailID;
@synthesize itemname;
@synthesize location_long;
@synthesize location_lat;
@synthesize created_date;
@synthesize password;




NSString *USER_ID;


-(id)initWithPlayer:(NSString *)thefirstName LastName:(NSString *)thelastName EmailID:(NSString *)theemailID ItemName:(NSString *)theItemName Longitude:(NSString *)thelatitude  Latitude:(NSString *)theLongtitude CreatedDate:(NSString *)thecreateddate Password:(NSString *)thepassword  

{
   
    
    NSUserDefaults *us1 = [NSUserDefaults standardUserDefaults];
    USER_ID =[us1 objectForKey:@"KEY"];
    
   
    self = [super init];
    if (self)
    {
        firstName = thefirstName;
        lastName = thelastName;
        emailID = theemailID;
        itemname=theItemName;
        location_lat=thelatitude;
        location_long=theLongtitude;
        created_date=thecreateddate;
        password=thepassword;
        
    }
    
    return self;
}



@end
