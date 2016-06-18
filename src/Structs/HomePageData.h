//
//  HomePageData.h
//  kBar
//
//  Created by wonliao on 13/3/26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HomePageData : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * fbImageFilename;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * keyName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * imageFilename;

@end
