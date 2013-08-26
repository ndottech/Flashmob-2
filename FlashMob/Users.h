//
//  Users.h
//  FlashMob
//
//  Created by apple on 20/07/13.
//  Copyright (c) 2013 APPLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject
{
    NSString *firstName;
    NSString *lastName;
    NSString *emailID;
    NSString *itemname;
    NSString *location_long;
    NSString *location_lat;
     NSString *created_date;

    
    NSString *itemName;
    NSString *itemAddress;
    NSString *itemLocation;
    NSString *password;

    
}
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *emailID;
@property (nonatomic, readonly) NSString *itemname;
@property (nonatomic, readonly) NSString *location_long;
@property (nonatomic, readonly) NSString *location_lat;
@property (nonatomic, readonly) NSString *created_date;
@property (nonatomic, readonly) NSString *password;





@property (nonatomic, readonly) NSString *itemName;
@property (nonatomic, readonly) NSString *itemAddress;
@property (nonatomic, readonly) NSString *itemLocation;

-(id)initWithPlayer:(NSString *)thefirstName LastName:(NSString *)thelastName EmailID:(NSString *)theemailID ItemName:(NSString *)theItemName Longitude:(NSString *)thelatitude  Latitude:(NSString *)theLongtitude CreatedDate:(NSString *)thecreateddate Password:(NSString *)thepassword  ;

-(id)initWithEvent:(NSString *)itemName LastName:(NSString *)thelastName EmailID:(NSString *)theemailID ItemName:(NSString *)theItemName  ;

@end
