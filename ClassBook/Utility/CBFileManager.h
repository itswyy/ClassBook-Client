//
//  CBFileManager.h
//  ClassBook
//
//  Created by wtlucky on 13-3-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBFileManager : NSObject

+ (CBFileManager *)sharedInstance;

/**
 *	为新用户创建个人目录
 *
 *	@param 	aUserId 	新用户的UserID
 *
 *	@return	目录创建是否成功
 */
- (BOOL)createDirectoryForNewUser:(int)aUserId;


@end
