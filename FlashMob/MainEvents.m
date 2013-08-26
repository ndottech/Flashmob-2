//
//  MainEvents.m
//  FlashMob
//
//  Created by apple on 30/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "MainEvents.h"

@implementation MainEvents
@synthesize userid;
@synthesize eventid;
@synthesize eventsItemName;
-(id)initWithPlayer:(NSString *)theUserId  EventID:(NSString *)theeventID ItemName:(NSString *)theItemName;{
    self = [super init];
    if (self)
    {
        
     //   NSLog(@"......2.......");

        userid  = theUserId;
        eventid = theeventID;
        eventsItemName = theItemName;
       
    }
    
    return self;
}
@end
