//
//  CBCommonFunction.m
//  ClassBook
//
//  Created by wtlucky on 13-6-17.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBCommonFunction.h"
#import "CBBarButtonItem.h"

@implementation CBCommonFunction

+ (CBCommonFunction *)sharedInstance
{
    static CBCommonFunction *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CBCommonFunction alloc]init];
    });
    
    return instance;
}

- (void)setNavigationBackBarBtn:(UIViewController *)VC
{
    CBBarButtonItem *backBar = [[CBBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leaveThisController:)];
    backBar.viewController = VC;
    VC.navigationItem.leftBarButtonItem = backBar;
    VC.navigationItem.leftBarButtonItem.tintColor = [UIColor purpleColor];
}

- (void)leaveThisController:(id)sender
{
    UIViewController *VC = [(CBBarButtonItem *)sender viewController];
    [VC.navigationController popViewControllerAnimated:YES];
}

@end
