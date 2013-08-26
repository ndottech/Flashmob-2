//
//  EventsList.m
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "EventsList.h"




#import <AWSRuntime/AWSRuntime.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"98oN+od+HOGBkPilsDnYoRBmaJ6JxA3kVV97E+MZ"

#define EVENT_DOMAIN    @"Events"
#define EVENTITEMNAME      @"events"


 #define EVENT_NAME_ATTRIBUTE     @"eventName"


#define EVENT_CREATEDDATE     @"createddate"
#define EVENT_USERID    @"userid"


#define EVENT_COUNT_QUERY          @"select count(*) from Events"

#define NO_SORT_QUERY        @"select * from Events"

//#define NO_SORT_QUERY        @"select Events.userid from Events"



@implementation EventsList

@synthesize nextToken;
@synthesize objEventList = _objEventList;
NSString *primary_keycount;
NSString *user_id_key;
int val;
NSString *Userid_string;

-(id)init
{
    self = [super init];
    if (self)
    {
               
        // Initial the SimpleDB Client.
        sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
        self.nextToken = nil;
        
        
        SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:EVENT_COUNT_QUERY];
        selectRequest.consistentRead = YES;
        
        SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
       // NSLog(@"Error.......: %@", selectResponse);
        
        
        
        if(selectResponse.error != nil)
        {
           // NSLog(@"Error: %@", selectResponse.error);
            return 0;
        }
        
        SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
        
        primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
        
        
        
            
        
        
        int get=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
        
        
        int set=get +1;
        
        
        user_id_key=[NSString stringWithFormat:@"%d",set];
        
     //   NSLog(@"USEEEEEEEEEEEEEE22222222:%@",user_id_key);
        
        
        NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
        [Device_lan1 setObject:primary_keycount forKey:@"KEY"];
        
        
        
        
    }
    
    

    return self;
    
}



/*
 * Creates the Users domain.
 */
-(void)createEventsDomain
{
    SimpleDBCreateDomainRequest *createDomain = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:EVENT_DOMAIN];
   // NSLog(@"......createDomain.....%@",createDomain);
    SimpleDBCreateDomainResponse *createDomainResponse = [sdbClient createDomain:createDomain];
    if(createDomainResponse.error != nil)
    {
       // NSLog(@"Error...Create: %@", createDomainResponse.error);
    }
}

/*
 * Creates a new item and adds it to the HighScores domain.
 */
-(void)addEvents:(Events *)theEvents
{
    
       
    SimpleDBReplaceableAttribute *eventName = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENT_NAME_ATTRIBUTE andValue:theEvents.eventName andReplace:YES];
    
    
     SimpleDBReplaceableAttribute *userid  = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENTITEMNAME andValue:theEvents.eventsItemName andReplace:YES];
    
       
    

    
    SimpleDBReplaceableAttribute *createddate  = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENT_CREATEDDATE  andValue:theEvents.createddate andReplace:YES];
    
     SimpleDBReplaceableAttribute *userid_val  = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENT_USERID  andValue:theEvents.userid andReplace:YES];



    
    
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:1];
    [attributes addObject:eventName];

    [attributes addObject:userid];
       [attributes addObject:createddate];
    
      [attributes addObject:userid_val];
    


    
    
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:EVENT_DOMAIN andItemName:user_id_key andAttributes:attributes];
    
    SimpleDBPutAttributesResponse *putAttributesResponse = [sdbClient putAttributes:putAttributesRequest];
    if(putAttributesResponse.error != nil)
    {
       // NSLog(@"Error.....ONE....: %@", putAttributesResponse.error);
    }
}

/*
 * Gets the item from the High Scores domain with the item name equal to 'thePlayer'.
 */
-(Events *)getEvents:(NSString *)EventName
{
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:EVENT_DOMAIN andItemName:@"1"];
    SimpleDBGetAttributesResponse *response = [sdbClient getAttributes:gar];
    if(response.error != nil)
    {
       // NSLog(@"Error...TWO....: %@", response.error);
        return nil;
    }
    
    NSString *firstName = [self getEventStringValueForAttribute:EVENT_NAME_ATTRIBUTE fromList:response.attributes];
       
    NSString *events_item_name = [self getitemStringValueForAttribute:EVENTITEMNAME fromList:response.attributes];
      NSString *createddate = [self getcreateddateStringValueForAttribute:EVENT_CREATEDDATE fromList:response.attributes];
    
    NSString *userid = [self getuseridvalStringValueForAttribute:EVENT_USERID fromList:response.attributes];
    
    
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    [Device_lan1 setObject:primary_keycount forKey:@"KEY"];
    
   // return [[Events alloc]initWithEvent:firstName EventAddress:lastName EventItemName:events_item_name];
     return [[Events alloc]initWithEvent:firstName EventItemName:events_item_name Createddate:createddate userid:userid ];
}

/*
 * Extracts the value for the given attribute from the list of attributes.
 * Extracted value is returned as a NSString.
 */


-(NSString *)getuseridvalStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
{
    for (SimpleDBAttribute *attribute in attributeList) {
        if ( [attribute.name isEqualToString:theAttribute]) {
            return attribute.value;
        }
    }
    
    return @"";
}



-(NSString *)getEventStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
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


-(NSString *)getcreateddateStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
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




-(NSArray *)getHighScores
{
    
    //select * from Events
    
    
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    
    
    Userid_string =[Device_lan1 objectForKey:@"USERID"];
    //[Device_lan1 setObject:Userid_string forKey:@"UD"];

    
    NSLog(@"LOO:%@",Userid_string);
    
    NSString *query=[NSString stringWithFormat:@"select * from Events where userid='%@'", Userid_string];
    

    
    
   // NSString *query=NO_SORT_QUERY;
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query];
    
   // NSLog(@"query......:%@",query);
    
    selectRequest.consistentRead = YES;
    if (self.nextToken != nil) {
        selectRequest.nextToken = self.nextToken;
    }
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
    if(selectResponse.error != nil)
    {
       // NSLog(@"Error......THEREE: %@", selectResponse.error);
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
-(Events *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem
{
    //return [[Events alloc] initWithEvent:[self getEventNameFromItem:theItem] LastName:[self getLastNameFromItem:theItem] EmailID:[self getEmailIDFromItem:theItem]];
    //return [[Events alloc]initWithEvent:[self getEventNameFromItem:theItem] EventAddress:[self getEventAddressFromItem:theItem]EventItemName:[self getItemFromItem:theItem]];
     return [[Events alloc]initWithEvent:[self getEventNameFromItem:theItem]  EventItemName:[self getItemFromItem:theItem]  Createddate:[self getEventcreateddateFromItem:theItem] userid:[self getuseridvalFromItem:theItem] ];    
}

/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */


-(NSString *)getuseridvalFromItem:(SimpleDBItem *)theItem
{
    return [self getuseridvalStringValueForAttribute:EVENT_USERID fromList:theItem.attributes];
}


-(NSString *)getEventNameFromItem:(SimpleDBItem *)theItem
{
    return [self getEventStringValueForAttribute:EVENT_NAME_ATTRIBUTE fromList:theItem.attributes];
}

/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */
-(NSString *)getEventcreateddateFromItem:(SimpleDBItem *)theItem
{
    return [self getcreateddateStringValueForAttribute:EVENT_CREATEDDATE fromList:theItem.attributes];
}


/*
 * Extracts the 'player' attribute from the SimpleDB Item.
 */

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


-(NSString *)getItemFromItem:(SimpleDBItem *)theItem
{
    return [self getitemStringValueForAttribute:EVENTITEMNAME fromList:theItem.attributes];
}

-(int)highScoreCount
{
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:EVENT_COUNT_QUERY];
    // NSLog(@"selected Request......%@",selectRequest);
    selectRequest.consistentRead = YES;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
   // NSLog(@"Error.......: %@", selectResponse);
    
    
    
    if(selectResponse.error != nil)
    {
       // NSLog(@"Error: %@", selectResponse.error);
        return 0;
    }
    
    SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
    
    // primary_keycount=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
    
    primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
    
  //  NSLog(@"DBBBBBBBBB insert.......: %@", primary_keycount);
    
    
    
    
    return [self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
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

@end
