//
//  CBFileManager.m
//  ClassBook
//
//  Created by wtlucky on 13-3-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBFileManager.h"

@interface CBFileManager ()

@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation CBFileManager

+ (CBFileManager *)sharedInstance
{
    static CBFileManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CBFileManager alloc]init];
    });
    
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (BOOL)createDirectoryForNewUser:(int)aUserId
{
    NSString *userDocumentPath = [GET_APP_DOCUMENT_PATH stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", aUserId]];
    NSError *error;
    
    if ([self.fileManager createDirectoryAtPath:userDocumentPath withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSString *imgPath = [userDocumentPath stringByAppendingPathComponent:@"images"];
        if (![self.fileManager createDirectoryAtPath:imgPath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            DLog(@"Create user images directory faild, error:%@", [error localizedDescription]);
            return NO;
        }
        
        NSString *voicePath = [userDocumentPath stringByAppendingPathComponent:@"voices"];
        if (![self.fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:&error])
        {
            DLog(@"Create user voice directory faild, error:%@", [error localizedDescription]);
            return NO;
        }
        
        return YES;
    }
    
    DLog(@"Create user directory faild, error:%@", [error localizedDescription]);
    return NO;
}

@end
