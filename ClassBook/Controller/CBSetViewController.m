//
//  CBSetViewController.m
//  ClassBook
//
//  Created by Admin on 13-3-30.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBSetViewController.h"
#import "CBAboutUsViewController.h"
#import "CBFeedbackViewController.h"
#import "CBSetPersonalInfoController.h"
#import "CBProgressHUD.h"

@interface CBSetViewController ()

@property (strong, nonatomic) CBAboutUsViewController *aboutUsVC;
@property (strong, nonatomic) CBFeedbackViewController *feedbackVC;
@property (strong, nonatomic) CBSetPersonalInfoController * setUsInfoVC;

@end

@implementation CBSetViewController

@synthesize aboutUsVC = _aboutUsVC;
@synthesize feedbackVC = _feedbackVC;
@synthesize setUsInfoVC = _setUsInfoVC;
@synthesize iconList = _iconList;

#pragma mark - Lazy initialization

- (CBAboutUsViewController *)aboutUsVC
{
    if (nil == _aboutUsVC) {
        _aboutUsVC = [[CBAboutUsViewController alloc]init];
    }
    return _aboutUsVC;
}

- (CBFeedbackViewController *)feedbackVC
{
    if (nil == _feedbackVC) {
        _feedbackVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CBFeedbackViewController"];
    }
    return _feedbackVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [_myTableView setDataSource:self];
    [_myTableView setDelegate:self];
    
    _setUsInfoVC = [[CBSetPersonalInfoController alloc]init];
    
    _dataSourceArray = [[NSMutableArray alloc]initWithObjects:@"个人信息",@"方案模板",@"刷新全部好友信息",@"关于我们",@"意见反馈",nil];
    _iconList = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"setting_PersonInfo.png"], [UIImage imageNamed:@"setting_template.png"], [UIImage imageNamed:@"setting_refreash.png"], [UIImage imageNamed:@"setting_about.png"], [UIImage imageNamed:@"setting_feedback.png"], nil];
 
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commonBack@2x.png"]];
    [_myTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"commonBack@2x.png"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //实现UITableViewController的clearsSelectionOnViewWillAppear效果
    NSArray *selectedRows = [self.myTableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_dataSourceArray count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    if (indexPath.section == 1) {
        cell.textLabel.text = @"注销登陆";
        UIImage *img = [UIImage imageNamed:@"zhuxiao.png"];
        UIImageView * bg = [[UIImageView alloc]initWithImage:img];
        bg.frame = CGRectMake(10, 1, 300, 44);
        [cell addSubview:bg];

    }else
    {
        cell.textLabel.text = [_dataSourceArray objectAtIndex:row];
        cell.imageView.image = [_iconList objectAtIndex:row];
    }
    if (indexPath.section==0 && row!=2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [_iconList objectAtIndex:row];
    }

    return cell;
}

#pragma mark - TableViewDelegat

/**
	设置cell缩进
	@param tableView tableview
	@param indexPat 行号
	@returns 缩进量
 */
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        CBProgressHUD *HUD = [[CBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        
        int row = indexPath.row;
        DLog(@"%@",[_dataSourceArray objectAtIndex:row]);
        switch (row) {
            case 0:
                //个人信息设置页面
                [self.navigationController pushViewController:self.setUsInfoVC animated:YES];
                break;
            case 1:
                
                [HUD showTextTypeHUDViewWithText:@"本模块暂未开放！"];
                break;
            case 2:
                
                break;
            case 3:
                [self.navigationController pushViewController:self.aboutUsVC animated:YES];
                break;
            case 4:
                [self.navigationController pushViewController:self.feedbackVC animated:YES];
                break;
            default:
                break;
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
