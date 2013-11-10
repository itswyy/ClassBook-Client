//
//  CBCenterMenuOperation.m
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBCenterMenuOperation.h"
#import "CBPersonalDetailViewController.h"
#import "CBSearchViewController.h"
#import "CBTabBarController.h"
#import "CBUserListViewController.h"
#import "CBSendPublicMsgViewController.h"
#import "CBProgressHUD.h"

@implementation CBCenterMenuOperation

@synthesize searchViewController = _searchViewController;
@synthesize viewController = _viewController;
@synthesize outlineAddMsgViewController = _outlineAddMsgViewController;
@synthesize userListViewController = _userListViewController;
@synthesize sendPublicMsgViewController = _sendPublicMsgViewController;

- (id)initWithViewController:(CBTabBarController *)aViewController
{
    if (self = [super init]) {
        _viewController = aViewController;
        _HUD = [[CBProgressHUD alloc]initWithWindow:[[UIApplication sharedApplication].delegate window]];
    }
    return self;
}

#pragma mark - Lazy initialization

- (CBSearchViewController *)searchViewController
{
    if (nil == _searchViewController) {
        _searchViewController = [_viewController.storyboard instantiateViewControllerWithIdentifier:@"CBSearchViewController"];
//        _searchViewController = [[CBSearchViewController alloc]init];
    }
    
    return _searchViewController;
}

- (CBPersonalDetailViewController *)outlineAddMsgViewController
{
    //每次点击按钮进去都新建一个对象，为了使上次的内容清空
    _outlineAddMsgViewController = nil;
    _outlineAddMsgViewController = [[CBPersonalDetailViewController alloc]init];
    
    return _outlineAddMsgViewController;
}

- (CBUserListViewController *)userListViewController
{
    if (nil == _userListViewController) {
        _userListViewController = [[CBUserListViewController alloc]initWithStyle:UITableViewStylePlain];
    }
    
    return _userListViewController;
}

- (CBSendPublicMsgViewController *)sendPublicMsgViewController
{
    if (nil == _sendPublicMsgViewController) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BlackboardStoryboard" bundle:[NSBundle mainBundle]];
        _sendPublicMsgViewController = [storyboard instantiateViewControllerWithIdentifier:@"CBSendPublicMsgViewController"];
    }
    return _sendPublicMsgViewController;
}

#pragma mark - Self Methods

- (void)centerMenuTappedAtIndex:(NSInteger)aIndex
{
    switch (aIndex) {
        case 0:
            if ([CBCurrentUser currentUser].user_id == 0)
                [self.HUD showTextTypeHUDViewWithText:@"请登录后使用"];
            else
                [self showSearchViewController];
            break;
        case 1:
            [self showOutlineAddMsgViewController];
            break;
        case 2:
            [self.HUD showTextTypeHUDViewWithText:@"暂未开放！"];
            break;
        case 3:
            [self showUserListViewController];
            break;
        case 4:
            if ([CBCurrentUser currentUser].user_id == 0)
                [self.HUD showTextTypeHUDViewWithText:@"请登录后使用"];
            else
                [self showSendPublicMsgViewController];
            break;
        default:
            break;
    }
}

- (void)showSearchViewController
{
    [self.viewController.navigationController pushViewController:self.searchViewController animated:YES];
}

- (void)showOutlineAddMsgViewController
{    
   [self.viewController.navigationController pushViewController:self.outlineAddMsgViewController animated:YES];
}

- (void)showUserListViewController
{
    [self.viewController.navigationController pushViewController:self.userListViewController animated:YES];
}

- (void)showSendPublicMsgViewController
{
    [self.viewController.navigationController pushViewController:self.sendPublicMsgViewController animated:YES];
}

@end
