//
//  Events.h
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Events : NSObject
{
    NSString *eventName;
    NSString *eventsItemName;
    NSString *createddate;
    NSString *userid;
    
    
}
@property (nonatomic, readonly) NSString *eventName;
@property (nonatomic, readonly) NSString *eventsItemName;
@property (nonatomic, readonly) NSString *createddate;
@property (nonatomic, readonly) NSString *userid;



-(id)initWithEvent:(NSString *)theeventName EventItemName:(NSString *)theEventItemName Createddate:(NSString *)thecreateddate userid:(NSString *)theuserid ;


@end