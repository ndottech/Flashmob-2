//
//  UsersList.m
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "UsersList.h"

#import <AWSRuntime/AWSRuntime.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"98oN+od+HOGBkPilsDnYoRBmaJ6JxA3kVV97E+MZ"

#define USERS_DOMAIN    @"Users"

#define FIRST_ATTRIBUTE     @"firstName"
#define LAST_ATTRIBUTE      @"lastName"
#define EMAIL_ATTRIBUTE      @"emailID"
#define PASSWORD_ATTRIBUTE      @"password"


#define ITEMNAME      @"userid"

#define LATITUDE      @"latitude"

#define LONGITUDE     @"longitude"

#define CREATEDDATE     @"createddate"









#define COUNT_QUERY          @"select count(*) from Users"


@implementation UsersList

@synthesize nextToken;


NSString *primary_keycount;
NSString *user_id_key;
int val;


-(id)init
{
    self = [super init];
    if (self)
    {
        
        
        
       

        // Initial the SimpleDB Client.
        sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
        self.nextToken = nil;
        
        
        SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:COUNT_QUERY];
        selectRequest.consistentRead = YES;
        
        SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
      //  NSLog(@"Error.......: %@", selectResponse);
        
        
        
        if(selectResponse.error != nil)
        {
           // NSLog(@"Error: %@", selectResponse.error);
            return 0;
        }
        
        SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
        
        // primary_keycount=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
        
        primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
        
        
        
     
       
        
        
        int get=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
      
        
        int set=get +1;
       
        
       user_id_key=[NSString stringWithFormat:@"%d",set];
        
       // NSLog(@"USEEEEEEEEEEEEEE22222222:%@",user_id_key);
    
        
        NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
        [Device_lan1 setObject:primary_keycount forKey:@"KEY"];

               
                   }
    
    return self;
}

 

/*
 * Creates the Users domain.
 */
-(void)createUsersDomain
{
    SimpleDBCreateDomainRequest *createDomain = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:USERS_DOMAIN];
    SimpleDBCreateDomainResponse *createDomainResponse = [sdbClient createDomain:createDomain];
    if(createDomainResponse.error != nil)
    {
       // NSLog(@"Error: %@", createDomainResponse.error);
    }
}

/*
 * Creates a new item and adds it to the HighScores domain.
 */


-(int)highScoreCount
{
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:COUNT_QUERY];
    selectRequest.consistentRead = YES;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
   // NSLog(@"Error.......: %@", selectResponse);
    
    
    
    if(selectResponse.error != nil)
    {
        //NSLog(@"Error: %@", selectResponse.error);
        return 0;
    }
    
    SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
    
   // primary_keycount=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
    
    primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
    
   // NSLog(@"DBBBBBBBBB insert.......: %@", primary_keycount);
    
  
    
  
    return [self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
    }


-(void)addUsers:(Users *)theUsers
{
    
    //NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
   // [Device_lan1 setObject:user_id_key forKey:@"KEY"];

    SimpleDBReplaceableAttribute *firstAttribute = [[SimpleDBReplaceableAttribute alloc] initWithName:FIRST_ATTRIBUTE andValue:theUsers.firstName andReplace:YES];
    
    
    SimpleDBReplaceableAttribute *lastAttribute  = [[SimpleDBReplaceableAttribute alloc] initWithName:LAST_ATTRIBUTE andValue:theUsers.lastName andReplace:YES];
    
    SimpleDBReplaceableAttribute *emailAttribute  = [[SimpleDBReplaceableAttribute alloc] initWithName:EMAIL_ATTRIBUTE andValue:theUsers.emailID andReplace:YES];
    
    SimpleDBReplaceableAttribute *userid  = [[SimpleDBReplaceableAttribute alloc] initWithName:ITEMNAME andValue:theUsers.itemname andReplace:YES];
    
    SimpleDBReplaceableAttribute *latitude  = [[SimpleDBReplaceableAttribute alloc] initWithName:LATITUDE andValue:theUsers.location_lat andReplace:YES];

    SimpleDBReplaceableAttribute *longitude  = [[SimpleDBReplaceableAttribute alloc] initWithName:LONGITUDE andValue:theUsers.location_long andReplace:YES];

    SimpleDBReplaceableAttribute *createddate  = [[SimpleDBReplaceableAttribute alloc] initWithName:CREATEDDATE  andValue:theUsers.created_date andReplace:YES];
    SimpleDBReplaceableAttribute *password  = [[SimpleDBReplaceableAttribute alloc] initWithName:PASSWORD_ATTRIBUTE  andValue:theUsers.password andReplace:YES];
    



    
    
   // *udhaya*/
    
    
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:1];
    [attributes addObject:firstAttribute];
    [attributes addObject:lastAttribute];
    [attributes addObject:emailAttribute];
    [attributes addObject:userid];
    [attributes addObject:latitude];
    [attributes addObject:longitude];
     [attributes addObject:createddate];
    [attributes addObject:password];

    
    
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:USERS_DOMAIN andItemName:theUsers.emailID andAttributes:attributes];
    
         
    
    SimpleDBPutAttributesResponse *putAttributesResponse = [sdbClient putAttributes:putAttributesRequest];
    if(putAttributesResponse.error != nil)
    {
       // NSLog(@"Error: %@", putAttributesResponse.error);
    }
}






/*
 * Gets the item from the High Scores domain with the item name equal to 'thePlayer'.
 */
-(Users *)getUsers:(NSString *)UserName
{
    
   
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:USERS_DOMAIN andItemName:UserName];
    SimpleDBGetAttributesResponse *response = [sdbClient getAttributes:gar];
    if(response.error != nil)
    {
       // NSLog(@"Error: %@", response.error);
        return nil;
    }
    
    NSString *firstName = [self getFirstStringValueForAttribute:FIRST_ATTRIBUTE fromList:response.attributes];
    NSString *lastName = [self getLastStringValueForAttribute:LAST_ATTRIBUTE fromList:response.attributes];
    NSString *emailID = [self getEmailStringValueForAttribute:EMAIL_ATTRIBUTE fromList:response.attributes];
    
     NSString *item_name = [self getitemStringValueForAttribute:ITEMNAME fromList:response.attributes];
    
     NSString *latitude = [self getlatitudeStringValueForAttribute:LATITUDE fromList:response.attributes];
    
     NSString *longitude = [self getlongitudeStringValueForAttribute:LONGITUDE fromList:response.attributes];
    
    NSString *createddate = [self getdatecreatedStringValueForAttribute:CREATEDDATE fromList:response.attributes];
    
    NSString *password = [self getpasswordStringValueForAttribute:PASSWORD_ATTRIBUTE fromList:response.attributes];
    


    
    
    
    
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    [Device_lan1 setObject:primary_keycount forKey:@"KEY"];
    
    //return [[Users alloc] initWithPlayer:firstName LastName:lastName EmailID:emailID ItemName:item_name Latitude:latitude Longitude :longitude Createddate:createddate ];
    
    return [[Users alloc]initWithPlayer:firstName LastName:lastName EmailID:emailID ItemName:item_name Longitude:longitude Latitude:latitude CreatedDate:createddate Password:password];
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a NSString.
 */


-(NSString *)getpasswordStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}


-(NSString *)getFirstStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}

-(NSString *)getLastStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}

-(NSString *)getEmailStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}


-(NSString *)getitemStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}

//////////////////////////////////
/*
 * Using the pre-defined query, extracts items from the domain in a determined order using the 'select' operation.
 */

-(NSString *)getlatitudeStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}

-(NSString *)getlongitudeStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}

-(NSString *)getdatecreatedStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}



-(NSArray *)getHighScores
{
    
//    NSString *query=NO_SORT_QUERY;
    NSString *Userid_str;
    
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    
    
    Userid_str =[Device_lan1 objectForKey:@"USERID"];
    
    
   // NSLog(@"queryddsdsdsds......:%@",Userid_str);
    
    
    //NSString *query=NO_SORT_QUERY;
    NSString *query=[NSString stringWithFormat:@"select * from Users where userid!='%@'", Userid_str];
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query];
    
   // NSLog(@"query......:%@",query);
    
    selectRequest.consistentRead = YES;
    if (self.nextToken != nil) {
        selectRequest.nextToken = self.nextToken;
    }
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
    if(selectResponse.error != nil)
    {
       // NSLog(@"Error: %@", selectResponse.error);
        return [NSArray array];
    }
    
    self.nextToken = selectResponse.nextToken;
    
    return [self convertItemsToHighScores:selectResponse.items];
}

/*
 * Converts an array of Items into an array of HighScore objects.
 */
-(NSArray *)convertItemsToHighScores:(NSArray *)theItems
{
    NSMutableArray *highScores = [[NSMutableArray alloc] initWithCapacity:[theItems count]];
    for (SimpleDBItem *item in theItems) {
        [highScores addObject:[self convertSimpleDBItemToHighScore:item]];
    }
    
    return highScores;
}

/*
 * Converts a single SimpleDB Item into a HighScore object.
 */
-(Users *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem
{
    //return [[Users alloc] initWithPlayer:[self getFirstNameFromItem:theItem] LastName:[self getLastNameFromItem:theItem] EmailID:[self getEmailIDFromItem:theItem] ItemName:[self getItemFromItem:theItem] latitude:[self getlatitudeFromItem:theItem] longiude:[self getlongitudeFromItem:theItem] createddate:[self getcreateddateFromItem:theItem] ];
    
    return [[Users alloc]initWithPlayer:[self getFirstNameFromItem:theItem]LastName:[self getLastNameFromItem:theItem] EmailID:[self getEmailIDFromItem:theItem] ItemName:[self getItemFromItem:theItem] Longitude:[self getlongitudeFromItem:theItem] Latitude:[self getlongitudeFromItem:theItem] CreatedDate:[self getcreateddateFromItem:theItem] Password:[self getPasswordFromItem:theItem]];
}

/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */

-(NSString *)getPasswordFromItem:(SimpleDBItem *)theItem
{
    return [self getpasswordStringValueForAttribute:PASSWORD_ATTRIBUTE fromList:theItem.attributes];
}


-(NSString *)getFirstNameFromItem:(SimpleDBItem *)theItem
{
    return [self getFirstStringValueForAttribute:FIRST_ATTRIBUTE fromList:theItem.attributes];
}

/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */
-(NSString *)getLastNameFromItem:(SimpleDBItem *)theItem
{
    return [self getLastStringValueForAttribute:LAST_ATTRIBUTE fromList:theItem.attributes];
}

/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */
-(NSString *)getEmailIDFromItem:(SimpleDBItem *)theItem
{
    return [self getEmailStringValueForAttribute:EMAIL_ATTRIBUTE fromList:theItem.attributes];
}


-(NSString *)getItemFromItem:(SimpleDBItem *)theItem
{
    return [self getitemStringValueForAttribute:ITEMNAME fromList:theItem.attributes];
}


-(NSString *)getlatitudeFromItem:(SimpleDBItem *)theItem
{
    return [self getlatitudeStringValueForAttribute:LATITUDE  fromList:theItem.attributes];
}

-(NSString *)getlongitudeFromItem:(SimpleDBItem *)theItem
{
    return [self getlongitudeStringValueForAttribute:LONGITUDE  fromList:theItem.attributes];
}
-(NSString *)getcreateddateFromItem:(SimpleDBItem *)theItem
{
    return [self getdatecreatedStringValueForAttribute:CREATEDDATE fromList:theItem.attributes];
}



/*
 * If a 'nextToken' was returned on the previous query execution, use the next token to get the next batch of items.
 */
-(NSArray *)getNextPageOfScores
{
    if (self.nextToken == nil) {
        return [NSArray array];
    }
    else {
        return [self getHighScores];
    }
}

/*
 * Method returns the number of items in the High Scores Domain.
 */

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as an int.
 */
-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return [attribute.value intValue];
        }
    }
    
    return 0;
}

@end
