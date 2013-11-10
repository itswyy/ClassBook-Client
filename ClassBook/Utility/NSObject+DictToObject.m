//
//  NSObject+DictToObject.m
//  ClassBook
//
//  Created by wtlucky on 13-3-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "NSObject+DictToObject.h"

@implementation NSObject (DictToObject)

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    [self setValuesForKeysWithDictionary:aDictionary];
    return self;
}

@end
