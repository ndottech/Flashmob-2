//
//  UsersList.h
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AWSSimpleDB/AWSSimpleDB.h>

#import "Users.h"

@interface UsersList : NSObject
{
    AmazonSimpleDBClient *sdbClient;
    NSString             *nextToken;
    int                  sortMethod;
}
@property (nonatomic, retain) NSString *nextToken;

-(void)addUsers:(Users *)theUsers;
-(void)createUsersDomain;
-(Users *)getUsers:(NSString *)UserName;

-(NSArray *)getHighScores;
-(NSArray *)getNextPageOfScores;
-(int)highScoreCount;

-(NSArray *)convertItemsToHighScores:(NSArray *)items;



-(Users *)convertSimpleDBItemToHighScore:(SimpleDBItem *)theItem;
//-(NSString *)getPlayerNameFromItem:(SimpleDBItem *)theItem;
//-(int)getPlayerScoreFromItem:(SimpleDBItem *)theItem;
-(int)getIntValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
//-(NSString *)getStringValueForAttribute:(NSString *)theAttribute fromList:(NSArray *)attributeList;
@end
