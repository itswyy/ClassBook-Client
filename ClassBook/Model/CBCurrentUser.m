//
//  CBCurrentUser.m
//  ClassBook
//
//  Created by wtlucky on 13-3-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBCurrentUser.h"
#import "CBFileManager.h"
#import "CBDatabase.h"
#import "NSDictionary+ObjectToDict.h"

@interface CBCurrentUser ()

- (void)userFirstLogin:(NSNotification *)notification;

@end

@implementation CBCurrentUser

+ (CBCurrentUser *)currentUser
{
    static CBCurrentUser *currentUser = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentUser = [[CBCurrentUser alloc]init];
    });
    
    return currentUser;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFirstLogin:) name:NNUSER_FIRST_LOGIN object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - self Methods

-(void)saveValue:(NSString *)value forkey:(id)key
{
    BOOL resule = [[CBDatabase sharedInstance] saveUserInfoByUserID:self.user_id Value:value ForKey:key];
    
    if (!resule) {
        DLog(@"更新失败");
    }
}

- (void)setUser_id:(int)aUser_id
{
    _user_id = aUser_id;
}

- (void)formatCurrentUser
{
    NSDictionary *currentUserInfo = [[CBDatabase sharedInstance]getUserInfoByUserID:self.user_id];
    DLog(@"currentUserInfo = %@", currentUserInfo);
    
    [currentUserInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        if (obj == [NSNull null]) {
            obj = nil;
        }
        if ([@"longtitude" isEqualToString:key]) {
            self.longtitude = [obj doubleValue];
        }
        else if ([@"latitude" isEqualToString:key]) {
            self.latitude = [obj doubleValue];
        }
        else if ([@"sex" isEqualToString:key]) {
            self.sex = [obj intValue];
        }
        else {
            [self setValue:obj forKey:key];
        }
    }];
    
}

//- (BOOL)addFriendWithUser:(CBUser *)aUser
//{
//    BOOL res = NO;
//    //插入用户数据
//    NSDictionary *userDic = [NSDictionary dictionaryWithNSObject:aUser];
//    res = [[CBDatabase sharedInstance] insertOneData:userDic forTable:@"User"];
//    if (res)
//    {
//        int groupId = [[CBDatabase sharedInstance]getGroupIdByUserId:self.user_id andGroupName:@"好友"];
//        NSDictionary *userGroup = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:aUser.user_id], @"user_id", [NSNumber numberWithInt:groupId], @"group_id", nil];
//        res = [[CBDatabase sharedInstance]insertOneData:userGroup forTable:@"GroupUser"];
//    }
//    
//    return res;
//}

- (BOOL)addFriendWithUser:(NSDictionary *)aUser
{
    BOOL res = NO;
    //插入用户数据
    NSDictionary *userDic = aUser;
    res = [[CBDatabase sharedInstance] insertOneData:userDic forTable:@"User"];
    if (res)
    {
        int groupId = [[CBDatabase sharedInstance]getGroupIdByUserId:self.user_id andGroupName:@"好友"];
        NSDictionary *userGroup = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[aUser objectForKey:@"user_id"] intValue]], @"user_id", [NSNumber numberWithInt:groupId], @"group_id", nil];
        res = [[CBDatabase sharedInstance]insertOneData:userGroup forTable:@"GroupUser"];
    }
    
    return res;
}

#pragma mark - self Private Methods

- (void)userFirstLogin:(NSNotification *)notification
{
    self.user_id = [[notification.userInfo objectForKey:@"userId"]intValue];
    CBFileManager *fileManager = [CBFileManager sharedInstance];
    [fileManager createDirectoryForNewUser:self.user_id];
}

@end
