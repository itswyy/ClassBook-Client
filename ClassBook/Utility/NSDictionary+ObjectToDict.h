//
//  NSDictionary+ObjectToDict.h
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ObjectToDict)

+ (NSDictionary *)dictionaryWithNSObject:(id)object;

@end
