//
//  NSDictionary+ObjectToDict.m
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "NSDictionary+ObjectToDict.h"
#import <objc/runtime.h>

@implementation NSDictionary (ObjectToDict)

+ (NSDictionary *)dictionaryWithNSObject:(id)object
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([object class], &count);
    NSMutableArray *propertyArr = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [propertyArr addObject:name];
    }
    
    free(properties);
    
    __block NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [propertyArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        id value = [object valueForKey:obj];
        
        if (value) {
            [dictionary setObject:value forKey:obj];
        }
    }];
    
    return dictionary;
}

@end
