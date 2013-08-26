//
//  MainEvents.h
//  FlashMob
//
//  Created by apple on 30/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainEvents : NSObject
{
    NSString *userid;
    NSString *eventid;
    NSString *eventsItemName;
}
@property(nonatomic,readonly)NSString *userid;
@property(nonatomic,readonly)NSString *eventid;
@property(nonatomic,readonly)NSString *eventsItemName;



-(id)initWithPlayer:(NSString *)theUserId  EventID:(NSString *)theeventID ItemName:(NSString *)theItemName;

@end
