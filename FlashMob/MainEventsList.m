
//  MainEventsList.m
//  FlashMob
//
//  Created by apple on 30/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "MainEventsList.h"
#import <AWSRuntime/AWSRuntime.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"AKIAIEGDPP5P34BDFALQ"

#define SECRET_KEY             @"98oN+od+HOGBkPilsDnYoRBmaJ6JxA3kVV97E+MZ"

#define EVENTLIST_DOMAIN    @"EventList"

#define EVENTITEMNAME      @"eventList"
#define EVENTID_ATTRIBUTE     @"eventId"
#define USERID_ATTRIBUTE   @"userid"
#define EVENT_EVENT_NAME     @"firstname"

#define EVENT_COUNT_QUERY     @"select count(*) from EventList"


	



@implementation MainEventsList


@synthesize nextToken;
@synthesize objEventMainList = _objEventMainList;

NSString *primary_keycount;
NSString *user_id_key;
NSString *USER_ID;
int val;



-(id)init
{
    self = [super init];
    if (self)
    {
               
                
        
        
        NSUserDefaults *us1 = [NSUserDefaults standardUserDefaults];
        USER_ID =[us1 objectForKey:@"KEY"];
        
      
        sdbClient      = [[AmazonSimpleDBClient alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        sdbClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
        self.nextToken = nil;
        
        
        SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:EVENT_COUNT_QUERY];
        selectRequest.consistentRead = YES;
        
        SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
       
           
        
        if(selectResponse.error != nil)
        {
          NSLog(@"Error: %@", selectResponse.error);
            return 0;
        }
        
        SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
        
        primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
        
           
        
        int get=[self getIntValueForAttribute:@"Count" fromList:countItem.attributes];
        
        
        int set=get +1;
        
        
        user_id_key=[NSString stringWithFormat:@"%d",set];
        
      
        
        
        NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
        [Device_lan1 setObject:primary_keycount forKey:@"KEY"];
        
               

    }
    
    
    
    return self;
}

/*
 * Creates the EventList domain.
 */


-(void)createEventsMainDomain
{
    SimpleDBCreateDomainRequest *createDomain = [[SimpleDBCreateDomainRequest alloc] initWithDomainName:EVENTLIST_DOMAIN ];
    SimpleDBCreateDomainResponse *createDomainResponse = [sdbClient createDomain:createDomain];
    if(createDomainResponse.error != nil)
    {
        NSLog(@"Error...Create: %@", createDomainResponse.error);
    }
}

/*
 * Creates a new item and adds it to the EventList domain.
 */


-(void)addEventList:(MainEvents *)theEventList
{
    SimpleDBReplaceableAttribute *eventName = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENTID_ATTRIBUTE andValue:theEventList.eventid andReplace:YES];
    SimpleDBReplaceableAttribute *userid  = [[SimpleDBReplaceableAttribute alloc] initWithName:USERID_ATTRIBUTE andValue:theEventList.userid andReplace:YES];
    
     SimpleDBReplaceableAttribute *event_name_second  = [[SimpleDBReplaceableAttribute alloc] initWithName:EVENT_EVENT_NAME andValue:theEventList.eventsItemName andReplace:YES];
       
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithCapacity:1];
    [attributes addObject:eventName];
    [attributes addObject:userid];
    [attributes addObject:event_name_second];
      
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:EVENTLIST_DOMAIN  andItemName:user_id_key andAttributes:attributes];
    
    SimpleDBPutAttributesResponse *putAttributesResponse = [sdbClient putAttributes:putAttributesRequest];
    if(putAttributesResponse.error != nil)
    {
     
    }
}


-(MainEvents *)getEventMainList:(NSString *)EventId
{
    SimpleDBGetAttributesRequest *gar = [[SimpleDBGetAttributesRequest alloc] initWithDomainName:EVENTLIST_DOMAIN  andItemName:EventId];
    SimpleDBGetAttributesResponse *response = [sdbClient getAttributes:gar];
    if(response.error != nil)
    {
        NSLog(@"Error...TWO....: %@", response.error);
        return nil;
    }
    
    NSString *eventId = [self getEventStringValueForAttribute:EVENTID_ATTRIBUTE fromList:response.attributes];
    
    NSString *userId = [self getEventStringValueForAttribute:USERID_ATTRIBUTE fromList:response.attributes];
    
    NSString *events_item_name = [self getitemStringValueForAttribute:EVENT_EVENT_NAME fromList:response.attributes];
    
        
    NSUserDefaults *Device_lan1 = [NSUserDefaults standardUserDefaults];
    [Device_lan1 setObject:primary_keycount forKey:@"KEY"];
    
      return [[MainEvents alloc]initWithPlayer:userId EventID:eventId ItemName:events_item_name];
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


-(NSString *)getEventAddressStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList
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


-(NSArray *)getHighScores
{
    
     
    
    
    NSUserDefaults *us1 = [NSUserDefaults standardUserDefaults];
    NSString *eventid =[us1 objectForKey:@"EVENTID"];
    
        
    
    NSString *query =  [NSString stringWithFormat:@"select userid from EventList where eventId='%@'", eventid];

    
    
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:query];
    
     
    selectRequest.consistentRead = YES;
    if (self.nextToken != nil) {
        selectRequest.nextToken = self.nextToken;
    }
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
    if(selectResponse.error != nil)
    {
        NSLog(@"Error......THEREE: %@", selectResponse.error);
        return [NSArray array];
    }
    
    self.nextToken = selectResponse.nextToken;
    
    return [self convertItemsToHighScores:selectResponse.items];
}


-(NSArray *)convertItemsToHighScores:(NSArray *)theItems
{
    NSMutableArray *highScores = [[NSMutableArray alloc] initWithCapacity:[theItems count]];
    for (SimpleDBItem *item in theItems) {
        [highScores addObject:[self convertSimpleDBItemToHighScore:item]];
    }
    
    return highScores;
}

-(MainEvents *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem
{
     
    return [[MainEvents alloc]initWithPlayer:[self getUserIdFromItem:theItem] EventID:[self getEventIdFromItem:theItem] ItemName:[self getItemFromItem:theItem]];
}

-(NSString *)getUserIdFromItem:(SimpleDBItem *)theItem
{
    return [self getEventStringValueForAttribute:USERID_ATTRIBUTE fromList:theItem.attributes];
}

-(NSString *)getEventIdFromItem:(SimpleDBItem *)theItem
{
    return [self getEventAddressStringValueForAttribute:EVENTID_ATTRIBUTE fromList:theItem.attributes];
}


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
    return [self getitemStringValueForAttribute:EVENT_EVENT_NAME fromList:theItem.attributes];
}


-(int)highScoreCount
{
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:EVENT_COUNT_QUERY];
      selectRequest.consistentRead = YES;
    
    SimpleDBSelectResponse *selectResponse = [sdbClient select:selectRequest];
      
    if(selectResponse.error != nil)
    {
       NSLog(@"Error: %@", selectResponse.error);
        return 0;
    }
    
    SimpleDBItem *countItem = [selectResponse.items objectAtIndex:0];
    
       primary_keycount=[NSString stringWithFormat:@"%d",[self getIntValueForAttribute:@"Count" fromList:countItem.attributes]];
    
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
