//
//  CBUser.h
//  GMGridDemoTwo
//
//  Created by Admin on 13-3-6.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBUser : NSObject
{
 @protected
    int _user_id;
}

@property (assign, nonatomic) int user_id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *head_portrait;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *tel_num;
@property (strong, nonatomic) NSString *bloodtype;
@property (assign, nonatomic) int sex;
//@property (assign, nonatomic) int age;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *constellation;
@property (strong, nonatomic) NSString *race;
@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *sina_weibo;
@property (assign, nonatomic) double longtitude;
@property (assign, nonatomic) double latitude;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *real_name;


- (id)initWithName:(NSString*)name Image:(NSString *)image Uid:(int)_id;

@end
