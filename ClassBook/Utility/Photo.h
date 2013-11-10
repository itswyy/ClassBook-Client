//
//  Photo.h
//  UIAnimation
//
//  Created by Admin on 13-2-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * imagekey;
@property (nonatomic, retain) NSNumber * group_id;

@end
