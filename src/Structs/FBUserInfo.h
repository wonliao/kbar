//
//  FBUserInfo.h
//  kBar
//
//  Created by wonliao on 13/2/22.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FBUserInfo : NSManagedObject

@property (nonatomic, retain) NSString * fbUID;
@property (nonatomic, retain) NSString * fbName;
@property (nonatomic, retain) NSString * fbPlace;
@property (nonatomic, retain) NSString * fbLink;

@end
