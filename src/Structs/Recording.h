//
//  Recording.h
//  myFans
//
//  Created by wonliao on 13/1/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recording : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end
