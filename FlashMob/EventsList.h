//
//  EventsList.h
//  FlashMob
//
//  Created by apple on 26/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSSimpleDB/AWSSimpleDB.h>

#import "Events.h"

@interface EventsList : NSObject
{
    AmazonSimpleDBClient *sdbClient;
    NSString             *nextToken;
    int                  sortMethod;
}
@property (nonatomic, retain) NSString *nextToken;

-(void)addEvents:(Events *)theEvents;

-(void)createEventsDomain;

-(Events *)getEvents:(NSString *)EventName;

-(NSArray *)getHighScores;
-(NSArray *)getNextPageOfScores;
-(int)highScoreCount;
@property (nonatomic, retain) EventsList *objEventList;


// Utility Methods
-(NSArray *)convertItemsToHighScores:(NSArray *)items;
-(Events *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem;
-(NSString *)getPlayerNameFromItem:(SimpleDBItem *)theItem;
-(int)getPlayerScoreFromItem:(SimpleDBItem *)theItem;
-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
-(NSString *)getStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
@end