//
//  CBUser.m
//  GMGridDemoTwo
//
//  Created by Admin on 13-3-6.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import "CBUser.h"
#import "NSObject+DictToObject.h"

@implementation CBUser

@synthesize user_id = _user_id;
@synthesize name = _name;
@synthesize head_portrait = _head_portrait;
@synthesize email = _email;
@synthesize tel_num = _tel_num;
@synthesize bloodtype = _bloodtype;
@synthesize sex = _sex;
//@synthesize age = _age;
@synthesize birthday = _birthday;
@synthesize constellation = _constellation;
@synthesize race = _race;
@synthesize qq = _qq;
@synthesize address = _address;
@synthesize sina_weibo = _sina_weibo;
@synthesize longtitude = _longtitude;
@synthesize latitude = _latitude;
@synthesize password = _password;
@synthesize real_name = _real_name;

- (id)init
{
    return [self initWithName:nil Image:nil Uid:0];
}

- (id)initWithName:(NSString *)name Image:(NSString *)image Uid:(int)_id
{
    if (self = [super init]) {
        _name = name;
        _head_portrait = image;
        _user_id = _id;
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (value == [NSNull null]) {
        value = nil;
    }
    if ([@"longtitude" isEqualToString:key]) {
        self.longtitude = [value doubleValue];
    }
    else if ([@"latitude" isEqualToString:key]) {
        self.latitude = [value doubleValue];
    }
    else if ([@"sex" isEqualToString:key]) {
        if (value == nil || value == [NSNull null]) value = [NSNumber numberWithInt:1];
        self.sex = [value intValue];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}


@end
