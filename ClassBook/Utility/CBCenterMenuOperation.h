//
//  CBCenterMenuOperation.h
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBTabBarController, CBSearchViewController, CBPersonalDetailViewController, CBUserListViewController;
@class CBSendPublicMsgViewController;
@class CBProgressHUD;

@interface CBCenterMenuOperation : NSObject

@property (strong, nonatomic) CBSearchViewController *searchViewController;
@property (strong, nonatomic) CBPersonalDetailViewController *outlineAddMsgViewController;
@property (strong, nonatomic) CBUserListViewController *userListViewController;
@property (weak, nonatomic) CBTabBarController *viewController;
@property (strong, nonatomic) CBSendPublicMsgViewController *sendPublicMsgViewController;

@property (strong, nonatomic) CBProgressHUD *HUD;

- (id)initWithViewController:(CBTabBarController *)aViewController;

- (void)centerMenuTappedAtIndex:(NSInteger)aIndex;

- (void)showSearchViewController;
/**
 *	显示发送离线赠言模块
 */
- (void)showOutlineAddMsgViewController;

- (void)showUserListViewController;

/**
 *	进入发送公共组留言模块
 */
- (void)showSendPublicMsgViewController;


@end
