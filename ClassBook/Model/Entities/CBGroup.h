//
//  CBGroup.h
//  ClassBook
//
//  Created by Admin on 13-3-2.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBGroup : NSObject

@property (strong, nonatomic) NSString * group_name;
@property (strong, nonatomic) NSString * group_image;
@property (assign, nonatomic) int group_id;
@property (strong, nonatomic) NSString * group_album_flag;

- (id)initWithName:(NSString*)name Image:(NSString *)image;

@end
