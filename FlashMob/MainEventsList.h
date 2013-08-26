//
//  MainEventsList.h
//  FlashMob
//
//  Created by apple on 30/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSSimpleDB/AWSSimpleDB.h>
#import "MainEvents.h"

@interface MainEventsList : NSObject
{
    AmazonSimpleDBClient *sdbClient;
    NSString             *nextToken;
    int                  sortMethod;
}

@property (nonatomic, retain) NSString *nextToken;

@property(nonatomic,retain) NSString *get_id;

-(void)addEventList:(MainEvents *)theEventList;

-(void)createEventsMainDomain;

-(MainEvents *)getEventMainList:(NSString *)EventId;

-(NSArray *)getHighScores;
-(NSArray *)getNextPageOfScores;
-(int)highScoreCount;
@property (nonatomic, retain) MainEvents *objEventMainList;


// Utility Methods
-(NSArray *)convertItemsToHighScores:(NSArray *)items;
-(MainEvents *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem;
-(NSString *)getPlayerNameFromItem:(SimpleDBItem *)theItem;
-(int)getPlayerScoreFromItem:(SimpleDBItem *)theItem;
-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
-(NSString *)getStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
@end
