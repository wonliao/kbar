//
//  Playing.h
//  myFans
//
//  Created by wonliao on 13/2/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Playing : NSManagedObject

@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * fbImageFilename;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSString * name;

@end
