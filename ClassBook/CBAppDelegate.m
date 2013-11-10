//
//  CBAppDelegate.m
//  ClassBook
//
//  Created by wtlucky on 13-3-1.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBAppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ClassBookAPIClient.h"
#import "PhotoStore.h"
#import "CBFileManager.h"

@interface CBAppDelegate ()

- (void)initializeTheDatabase;

@end


@implementation CBAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    //加载数据库
    [self initializeTheDatabase];
    //初始化网络客户端
    [ClassBookAPIClient sharedClient];
    //初始化当前用户
    [CBCurrentUser currentUser];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    DLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    DLog(@"applicationDidEnterBackground");
    
    [[PhotoStore defaultStore] saveChanges];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    DLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    DLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    DLog(@"applicationWillTerminate");
    
    [[PhotoStore defaultStore] saveChanges];
}

#pragma mark - Self Methods

- (void)initializeTheDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:DB_PATH])
    {
        NSString *sourceDB = [[NSBundle mainBundle]pathForResource:@"classbook" ofType:@"sqlite3"];
        NSError *error = nil;
        [fileManager copyItemAtPath:sourceDB toPath:DB_PATH error:&error];
        if (error) {
            DLog(@"Create DB error: %@", [error localizedDescription]);
        }
    }
    //创建默认用户文件夹 文件夹名字为0 里面包含images 和 voices
    BOOL isDictionary = YES;
    if (![fileManager fileExistsAtPath:DEFULT_FOLDER_PaTH isDirectory:&isDictionary]) {
        [[CBFileManager  sharedInstance] createDirectoryForNewUser:0];
    }
}


@end
