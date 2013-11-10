//
//  CBHomeViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-4-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBHomeViewController.h"
#import "CBEntities.h"
#import "CBDatabase.h"
#import "CBGroupViewController.h"

@interface CBHomeViewController ()



@end

@implementation CBHomeViewController

@synthesize backgroundView = _backgroundView;
@synthesize userGroupsArr = _userGroupsArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Self Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置数组
    _userGroupsArr = [[CBDatabase sharedInstance]getUserGroupsByUserId:[CBCurrentUser currentUser].user_id];
	
    //设置背景scrollView
    _backgroundView = [[CBHomeBackView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44)];
    [self.view addSubview:_backgroundView];
    
    self.backgroundView.cbDegelate = self;
    self.backgroundView.dataSource = self;
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor purpleColor]];
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setBackgroundView:nil];
    [super viewDidUnload];
}

#pragma mark - Self Private Methods

#pragma mark - CBHomeBackView datasoure methods
- (NSInteger)numberOfGroups
{
    return [self.userGroupsArr count];
}

- (CBGroupIconView *)viewAtIndex:(NSInteger)aIndex
{
    CBGroup *group = [self.userGroupsArr objectAtIndex:aIndex];
    CBGroupIconView *groupIconView = [[CBGroupIconView alloc]initWithFootType:aIndex];
    groupIconView.groupName.text = group.group_name;
    
    return groupIconView;
}

#pragma mark - CBHomeBackView cbDelegate methods
- (void)groupDidTapedAtIndex:(NSInteger)aIndex
{
    DLog(@"%d group tapped!", aIndex);
    
    CBGroupViewController *groupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"groupViewController"];
    CBGroup *group = [self.userGroupsArr objectAtIndex:aIndex];
    groupVC.group_id = group.group_id;
    [self.navigationController pushViewController:groupVC animated:YES];
}

@end
