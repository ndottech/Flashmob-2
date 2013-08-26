//
//  Events.m
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import "Events.h"

@implementation Events

@synthesize eventName;
@synthesize eventsItemName;
@synthesize createddate;
@synthesize userid;


-(id)initWithEvent:(NSString *)theeventName EventItemName:(NSString *)theEventItemName Createddate:(NSString *)thecreateddate userid:(NSString *)theuserid
{
    self = [super init];
    if (self)
    {
        eventName  = theeventName;
        eventsItemName = theEventItemName;
        createddate=thecreateddate;
        userid=theuserid;
        
    }
    
    return self;
}


@end
