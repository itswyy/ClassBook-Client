//
//  CBCurrentUser.h
//  ClassBook
//
//  Created by wtlucky on 13-3-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBUser.h"

@interface CBCurrentUser : CBUser

+ (CBCurrentUser *)currentUser;

- (void)setUser_id:(int)aUser_id;
- (void)formatCurrentUser;
/**
	保存个人信息
	@param value 需要保存的值
	@param key 相对应的键
 */
-(void)saveValue:(id)value forkey:(id)key;
/**
 *	为当前用户添加新好友，默认被添加到‘好友’组中
 *
 *	@param 	aUser 	要添加的好友信息
 *
 *	@return	添加是否成功
 */
//- (BOOL)addFriendWithUser:(CBUser *)aUser;

- (BOOL)addFriendWithUser:(NSDictionary *)aUser;



@end
