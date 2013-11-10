//
//  CBDatabase.m
//  ClassBook
//
//  Created by wtlucky on 13-3-2.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBDatabase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "CBEntities.h"
#import "NSObject+DictToObject.h"

@interface CBDatabase ()

@property (nonatomic, strong) FMDatabaseQueue *backgroundQueue;

/**
 *	给指定table生成插入给定数据的语句
 *
 *	@param 	aTable 	指定的table
 *	@param 	aData 	要插入的数据
 *
 *	@return	生成的sql语句
 */
- (NSString *)generateInsertSQLForTable:(NSString *)aTable andDatas:(NSDictionary *)aData;

- (BOOL)setHaveLoggedFieldForTrueToUser:(NSNumber *)aUserId;
- (BOOL)insertDataforUserTable:(NSArray *)aArray;


@end


@implementation CBDatabase

@synthesize backgroundQueue = _backgroundQueue;


+ (CBDatabase *)sharedInstance
{
    static CBDatabase *singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[CBDatabase alloc]init];
    });
    
    return singleton;
}

- (id)init
{
    if (self = [super init])
    {
        _backgroundQueue = [[FMDatabaseQueue alloc]initWithPath:DB_PATH];
    }
    
    return self;
}

#pragma mark - Self Methods

- (BOOL)updateUserAccount:(NSString *)aUserAccount andPassword:(NSString *)aPassword withAccountType:(NSString *)aLoginAccountType andUserID:(NSNumber *)aUserID
{
    __block BOOL res = NO;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        //查询用户是否存在
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE %@ = ?", aLoginAccountType];
        FMResultSet *rs = [db executeQuery:sql, aUserAccount];
        if ([rs next])
        {
            //有值则更新
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE User SET password = ? WHERE %@ = ?", aLoginAccountType];
            res = [db executeUpdate:updateSql, aPassword, aUserAccount];
            
            if (res)
            {
                DLog(@"update user login info succeed!");
                
                //查看用户是否是首次登陆（有可能他被添加了好友，用户信息已存在，但并不是首次登陆）
                if ([rs boolForColumn:@"havelogged"]) {
                    
                    //为了防止用户第二次登陆为离线用户，特在此做出修改。2013年06月17日
                    [[CBCurrentUser currentUser]setUser_id:[rs intForColumn:@"user_id"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //发出用户登陆成功通知，进入下一级页面
                        [[NSNotificationCenter defaultCenter] postNotificationName:NNUSER_LOGIN_SUCCEED object:nil userInfo:nil];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //无值则发出用户首次登陆通知，创建用户目录，同步用户数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:NNUSER_FIRST_LOGIN object:nil userInfo:[NSDictionary dictionaryWithObject:aUserID forKey:@"userId"]];
                    });
                }
                
            }
        }
        else
        {
            
            res = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                //无值则发出用户首次登陆通知，创建用户目录，同步用户数据
                [[NSNotificationCenter defaultCenter] postNotificationName:NNUSER_FIRST_LOGIN object:nil userInfo:[NSDictionary dictionaryWithObject:aUserID forKey:@"userId"]];
            });
            
        }
        
        
    }];
    
    return res;
}

- (BOOL)selectLoginByAccount:(NSString *)aUserAccount andPassword:(NSString *)aPassword withAccountType:(NSString *)aLoginAccountType
{
    __block BOOL res = NO;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE %@ = ? and password = ?", aLoginAccountType];
        FMResultSet *rs = [db executeQuery:sql, aUserAccount, aPassword];
        if ([rs next])
        {
            res = YES;
        }
        
    }];
    
    return res;
}

- (BOOL)synchronizeUserDataByFirstTimeWithADictionary:(NSDictionary *)aDic
{
    NSArray *cbgroup = [aDic objectForKey:@"cbgroup"];
    NSArray *cbgroupuser = [aDic objectForKey:@"cbgroupuser"];
    NSArray *cboutlinemsg = [aDic objectForKey:@"cboutlinemsg"];
    NSArray *cbuser = [aDic objectForKey:@"cbuser"];
    NSArray *cbuseradvice = [aDic objectForKey:@"cbuseradvice"];
    NSArray *cbmessage = [aDic objectForKey:@"cbmessage"];
    NSArray *userfriends = [aDic objectForKey:@"userfriends"];

    BOOL res = YES;
    res = [self insertDataforUserTable:cbuser];
    
    //同步时置用户表havelogged字段为true
    if (res) res = [self setHaveLoggedFieldForTrueToUser:[cbuser[0] objectForKey:@"user_id"]];
    
    if (res) res = [self insertDataforUserTable:userfriends];
    if (res) res = [self insertData:cbgroup forTable:@"Groups"];
    if (res) res = [self insertData:cbgroupuser forTable:@"GroupUser"];   
    if (res) res = [self insertData:cbuseradvice forTable:@"UserAdvice"];
    if (res) res = [self insertData:cboutlinemsg forTable:@"OutLineUserAdvice"];
    if (res) res = [self insertData:cbmessage forTable:@"Message"];
    return res;

}

- (BOOL)insertData:(NSArray *)aArray forTable:(NSString *)aTable
{
    __block BOOL res = NO;
    [self.backgroundQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [aArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
                NSString *sql = [self generateInsertSQLForTable:aTable andDatas:obj];
                res = [db executeUpdate:sql];
                
                if (!res)
                {
                    *stop = YES;
                    *rollback = YES;
                }
            
        }];
        
        if (0 == [aArray count]) res = YES;
        
    }];
    
    return res;
}

- (BOOL)insertOneData:(NSDictionary *)aDictionary forTable:(NSString *)aTable
{
    //当要插入用户表时
    if ([@"User" isEqualToString:aTable]) {
        return [self insertDataforUserTable:[NSArray arrayWithObject:aDictionary]];
    }
    
    __block BOOL res = NO;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [self generateInsertSQLForTable:aTable andDatas:aDictionary];
        res = [db executeUpdate:sql];
    }];
    
    return res;
}

- (NSDictionary *)getUserInfoByUserID:(int)aUserID
{
    __block NSMutableDictionary *dic = nil;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserID]];
        while ([rs next]) {
            dic = [[rs resultDict] mutableCopy];
            //丢掉无用用户信息
            [dic removeObjectForKey:@"havelogged"];
        }
        
    }];
    
    return dic;
}

- (NSDictionary *)getOutLineUserInfoByUserID:(int)aUserID
{
    __block NSMutableDictionary *dic = nil;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM OutLineUserAdvice WHERE outline_user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserID]];
        while ([rs next]) {
            dic = [[rs resultDict] mutableCopy];
        }
        
    }];
    
    return dic;
}
- (NSDictionary *)getUserNameByUserID:(int)aUserID
{
    __block NSDictionary *dic = nil;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT name FROM User WHERE user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserID]];
        while ([rs next]) {
            dic = [rs resultDict];
        }
        
    }];
    
    return dic;
}

- (BOOL)saveUserInfoByUserID:(int)aUserID Value:(NSString *)aValue ForKey:(id)key
{
    __block BOOL res= NO;
        
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE User SET %@ = ? WHERE user_id = %d",key,aUserID];
        NSLog(@"%@",updateSql);
        res = [db executeUpdate:updateSql,aValue];
    }];
    
    return res;
}

- (NSMutableArray *)getUserAdviceInfoByUserID:(int)aUserID FromUserID:(int)userid
{
    __block NSMutableArray *dic = [[NSMutableArray alloc]initWithCapacity:2];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM UserAdvice WHERE user_id2 = ? And user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserID], [NSNumber numberWithInt:userid]];
        while ([rs next]) {
            [dic addObject:[rs resultDict]];
        }
        
    }];
    
    return dic;
}
- (NSMutableArray *)getUserGroupsByUserId:(int)aUserId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT group_album_flag, group_id, group_image, group_name FROM Groups WHERE user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserId]];
        while ([rs next]) {
            CBGroup *group = [[CBGroup alloc]initWithDictionary:[rs resultDict]];
            [ar addObject:group];
        }
        
    }];
    
    return ar;
}
- (NSMutableArray *)getUsersByGroupId:(int)aGroupId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM GroupUser WHERE group_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aGroupId]];
        while ([rs next]) {
            [ar addObject: [rs resultDict]];
        }
        
    }];
    
    return ar;
}
- (NSMutableArray *)getMessagesByGroupId:(int)aGroupId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Message WHERE group_id = ?"];
        FMResultSet *rs = [db executeQuery:sql,[NSNumber numberWithInt:aGroupId]];
        while ([rs next]) {
            [ar  addObject:[rs resultDict]];
        }
    }];
    return ar;
}

- (NSMutableArray *)getUsersByOutLineUserId:(int)aUserId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM OutLineUserAdvice WHERE user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserId]];
        while ([rs next]) {
            [ar addObject: [rs resultDict]];
        }
        
    }];
    
    return ar;
}

- (NSMutableArray *)getUsersByOutLineGroupId:(int)aGroupId
{
    __block NSMutableArray *ar = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM OutLineUserAdvice WHERE outline_group_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aGroupId]];
        while ([rs next]) {
            [ar addObject: [rs resultDict]];
        }
        
    }];
    
    return ar;
}

- (NSInteger)getGroupIdByUserId:(int)aUserId andGroupName:(NSString *)aGroupName
{
    __block NSInteger groupId;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT group_id FROM Groups WHERE user_id = ? AND group_name = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserId], aGroupName];
        while ([rs next]) {
            groupId = [rs intForColumn:@"group_id"];
        }
    }];
    
    return groupId;
}

- (NSMutableArray *)getAllRelatedOnlineUserInfoByUserId:(int)aUserId
{
    __block NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT a.user_id, a.name, a.head_portrait,a.sex FROM User a, GroupUser b, Groups c WHERE c.user_id = ? AND c.group_id = b.group_id AND a.user_id = b.user_id"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserId]];
        while ([rs next]) {
            [arr addObject:[rs resultDict]];
        }
    }];
    
    return arr;
}

- (NSMutableArray *)getAllRelatedOutlineUserInfoByUserId:(int)aUserId
{
    __block NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT outline_user_id, name, head_portrait ,sex FROM OutLineUserAdvice WHERE user_id = ?"];
        FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInt:aUserId]];
        while ([rs next]) {
            [arr addObject:[rs resultDict]];
        }
    }];
    
    return arr;
}

#pragma mark - Self Private Methods

- (NSString *)generateInsertSQLForTable:(NSString *)aTable andDatas:(NSDictionary *)aData
{
    //把字典拆出两个数组，一个存放key，一个存放value
    NSMutableArray* cols = [[NSMutableArray alloc] init];
    NSMutableArray* vals = [[NSMutableArray alloc] init];
    
    for (id key in aData) {
        [cols addObject:key];
        [vals addObject:[aData objectForKey:key]];
    }
    
    //把两个数组的信息格式化成sql语句所需的样式
    NSMutableArray* newCols = [[NSMutableArray alloc] init];
    NSMutableArray* newVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[cols count]; i++) {
        [newCols addObject:[NSString stringWithFormat:@"'%@'", [cols objectAtIndex:i]]];
        [newVals addObject:[NSString stringWithFormat:@"'%@'", [vals objectAtIndex:i]]];
    }
    //生成sql语句
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", aTable, [newCols componentsJoinedByString:@", "], [newVals componentsJoinedByString:@", "]];
    
    DLog(@"Insert SQL = %@", sql);
    
    return sql;
}

- (BOOL)setHaveLoggedFieldForTrueToUser:(NSNumber *)aUserId
{
    __block BOOL res = NO;
    [self.backgroundQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE User SET havelogged = 1 WHERE user_id = ?"];
        res = [db executeUpdate:sql, aUserId];
    }];
    
    return res;
}

- (BOOL)insertDataforUserTable:(NSArray *)aArray
{
    __block BOOL res = YES;
    [self.backgroundQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [aArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            //查看该用户数据是否存在
            NSString *checkSql = [NSString stringWithFormat:@"SELECT name FROM User WHERE user_id = ?"];
            FMResultSet *rs = [db executeQuery:checkSql, [obj objectForKey:@"user_id"]];
            if (![rs next]) {
                //用户数据不存在，插入
                NSString *sql = [self generateInsertSQLForTable:@"User" andDatas:obj];
                res = [db executeUpdate:sql];
                
                if (!res)
                {
                    *stop = YES;
                    *rollback = YES;
                }
                
            }
            
        }];
        
    }];
    
    return res;
}

@end
