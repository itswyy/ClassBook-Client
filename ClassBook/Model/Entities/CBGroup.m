//
//  CBGroup.m
//  ClassBook
//
//  Created by Admin on 13-3-2.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBGroup.h"

@implementation CBGroup

@synthesize group_id = _group_id;
@synthesize group_image = _group_image;
@synthesize group_name = _group_name;
@synthesize group_album_flag = _group_album_flag;

- (id)init
{
    return [self initWithName:nil Image:nil];
}

-(id)initWithName:(NSString *)name Image:(NSString *)image
{
    if (self = [super init]) {
        _group_name = name;
        _group_image = image;
        _group_id = 0;
    }
    return self;
}

@end
