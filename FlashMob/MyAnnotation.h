//
//  MyAnnotation.h
//  SimpleMapView
//
//  Created by Mayur Birari.

//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	coordinate;
	NSString*				title;
	NSString*				subtitle;
     UIImage*                image;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic, assign) NSString *locationType;
@property (nonatomic, retain)		UIImage*                image;
@end