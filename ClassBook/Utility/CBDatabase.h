//
//  CBDatabase.h
//  ClassBook
//
//  Created by wtlucky on 13-3-2.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBDatabase : NSObject

+ (CBDatabase *)sharedInstance;

/**
 *	更新本地数据库用户账号和密码，如果账号存在则更新账号的登陆信息和密码，如果不存在则插入
 *
 *	@param 	aUserAccount 	用户登陆的账户信息，可能是邮箱、用户名或者唯一ID
 *	@param 	aPassword 	密码
 *	@param 	aLoginAccountType 	用户登陆账户类型
 *	@param 	aUserID 	用户的唯一ID
 *
 *	@return	更新或者插入是否成功
 */
- (BOOL)updateUserAccount:(NSString *)aUserAccount andPassword:(NSString *)aPassword withAccountType:(NSString *)aLoginAccountType andUserID:(NSNumber *)aUserID;

/**
 *	设备离线时使用，查询本地数据库，验证能否登陆成功
 *
 *	@param 	aUserAccount 	用户登陆的账户信息，可能是邮箱、用户名或者唯一ID
 *	@param 	aPassword 	密码
 *	@param 	aLoginAccountType 	用户登陆账户类型
 *
 *	@return	能否成功登陆
 */
- (BOOL)selectLoginByAccount:(NSString *)aUserAccount andPassword:(NSString *)aPassword withAccountType:(NSString *)aLoginAccountType;

/**
 *	用户首次同步数据，将服务端的数据同步到本地
 *
 *	@param 	aDic 	包含有用户信息的字典（个人信息，分组信息，离线记录信息，赠言信息）
 *
 *	@return	同步成功与否
 */
- (BOOL)synchronizeUserDataByFirstTimeWithADictionary:(NSDictionary *)aDic;

/**
 *	向数据表中插入多组数据
 *
 *	@param 	aArray 	保存有信息的数组，每条信息为一个字典
 *	@param 	aTable 	要插入的表
 *
 *	@return	插入是否成功
 */
- (BOOL)insertData:(NSArray *)aArray forTable:(NSString *)aTable;

/**
 *	向指定数据表中插入一条记录
 *
 *	@param 	aDictionary 	装有要插入内容的字典，key为数据表字段，value为要插入的数据
 *	@param 	aTable 	要插入的表
 *
 *	@return	插入是否成功
 */
- (BOOL)insertOneData:(NSDictionary *)aDictionary forTable:(NSString *)aTable;

/**
 *	根据指定ID获取用户信息
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	包含有用户信息的字典
 */
- (NSDictionary *)getUserInfoByUserID:(int)aUserID;
/**
 *	根据指定ID获取离线用户信息
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	包含有用户信息的字典
 */
- (NSDictionary *)getOutLineUserInfoByUserID:(int)aUserID;

/**
 *	根据指定ID获取用户姓名
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	包含有用户名字的字典
 */
- (NSDictionary *)getUserNameByUserID:(int)aUserID;

/**
 *	保存指定的用户信息
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	是否更新成功
 */
- (BOOL)saveUserInfoByUserID:(int)aUserID Value:(NSString *)aValue ForKey:(id)key;

/**
 *	根据指定ID用户的所有赠言信息
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	包含有赠言信息的字典
 */
- (NSMutableArray *)getUserAdviceInfoByUserID:(int)aUserID FromUserID:(int)userid;

/**
 *	根据指定ID获取用户分组信息
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	用户的所有分组
 */
- (NSMutableArray *)getUserGroupsByUserId:(int)aUserId;
/**
 *	根据指定分组ID得到分组内的用户
 *
 *	@param 	aGroupID 	指定的GroupID
 *
 *	@return	分组的所有用户
 */
- (NSMutableArray *)getUsersByGroupId:(int)aGroupId;
/**
 *	根据指定分组ID得到分组内的所有公共留言
 *
 *	@param 	aGroupID 	指定的GroupID
 *
 *	@return	分组的所有公共留言
 */
- (NSMutableArray *)getMessagesByGroupId:(int)aGroupId;

/**
 *	根据指定用户ID得到离线分组内的用户
 *
 *	@param 	aUserID 	指定的userID
 *
 *	@return	分组的所有用户信息
 */
- (NSMutableArray *)getUsersByOutLineUserId:(int)aUserId;
/**
 *	根据指定用户ID得到离线分组内的用户
 *
 *	@param 	aGroupId 	指定的离线分组ID
 *
 *	@return	分组的所有用户信息
 */
- (NSMutableArray *)getUsersByOutLineGroupId:(int)aGroupId;

/**
 *	根据指定的用户ID以及分组名获取该用户分组的ID
 *
 *	@param 	aUserId 	指定的userID
 *	@param 	aGroupName 	指定的分组名称
 *
 *	@return	分组的ID
 */
- (NSInteger)getGroupIdByUserId:(int)aUserId andGroupName:(NSString *)aGroupName;

- (NSMutableArray *)getAllRelatedOnlineUserInfoByUserId:(int)aUserId;

- (NSMutableArray *)getAllRelatedOutlineUserInfoByUserId:(int)aUserId;



@end
