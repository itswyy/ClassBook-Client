//
//  CBSearchViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBSearchViewController.h"
#import "CBDetailSearchView.h"
#import "CBProgressHUD.h"
#import "CBEntities.h"
#import "CBUserPreviewCell.h"
#import "CBConditionSearchView.h"
#import "CBCurrentUser.h"

@interface CBSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) CBProgressHUD *HUD;
@property (strong, nonatomic) UITableView *resultTabelView;
@property (strong, nonatomic) NSMutableArray *resultData;
@property (strong, nonatomic) UIAlertView *alerView;

- (void)segmentValueChanged:(UISegmentedControl *)sender;
- (void)showDetailView;
- (void)showConditionView;

@end

@implementation CBSearchViewController

@synthesize searchSegment = _searchSegment;
@synthesize detailView = _detailView;
@synthesize HUD = _HUD;
@synthesize resultTabelView = _resultTabelView;
@synthesize resultData = _resultData;
@synthesize conditionView = _conditionView;

#pragma mark - Lazy Initialization
- (UITableView *)resultTabelView
{
    if (nil == _resultTabelView) {
        _resultTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, 300) style:UITableViewStylePlain];
        _resultTabelView.delegate = self;
        _resultTabelView.dataSource = self;
        [self.view addSubview:_resultTabelView];
        _resultTabelView.allowsSelection = NO;
    }
    return _resultTabelView;
}

- (NSMutableArray *)resultData
{
    if (nil == _resultData) {
        _resultData = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _resultData;
}

- (UIAlertView *)alerView
{
    if (nil == _alerView) {
        _alerView = [[UIAlertView alloc]initWithTitle:@"添加好友"
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:@"不要"
                                    otherButtonTitles:@"是的", nil];
        [_alerView setDelegate:self];
    }
    return _alerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //分类查找按钮
    _searchSegment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"精确查找", @"条件查找", nil]];
    [_searchSegment setFrame:CGRectMake(-10, 0, 340, 44)];
    [_searchSegment setWidth:170.0 forSegmentAtIndex:0];
    [_searchSegment setWidth:170.0 forSegmentAtIndex:1];
    [_searchSegment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_searchSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_searchSegment setTintColor:[UIColor colorWithRed:39.0/255 green:190.0/255 blue:42.0/255 alpha:1]];

    [self.view addSubview:_searchSegment];
    
    //精确查找View
    _detailView = [[CBDetailSearchView alloc]initWithFrame:CGRectMake(0, 45, 320, 400) andDelegate:self];
    [self.view addSubview:_detailView];
    
    //条件查找View
    [_conditionView formatViewsAndSetDelegate:self];
    _conditionView.hidden = YES;
    
    //MBProgressHUD initialize
    _HUD = [[CBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUD];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.searchSegment setSelectedSegmentIndex:0];
    [self showDetailView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Self Methods

- (void)detailSearchWithUserId:(NSString *)aUserID
{
    NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:aUserID, @"user_id", nil];
    [self doSearchRequestWithPostPara:postParam];
}

- (void)conditionSearchWith:(NSString *)aKey andValue:(NSString *)aValue
{
    NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:aValue, aKey, nil];
    [self doSearchRequestWithPostPara:postParam];
}

#pragma mark - Self Private Methods

- (void)leaveThisController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showDetailView
{
    self.detailView.hidden = NO;
    self.conditionView.hidden = YES;
    [self.conditionView closeKeyboard];
    self.navigationItem.title = @"精确查找";
    self.resultTabelView.hidden = YES;
}

- (void)showConditionView
{
    self.detailView.hidden = YES;
    self.conditionView.hidden = NO;
    [self.detailView closeKeyboard];
    self.navigationItem.title = @"条件查找";
    self.resultTabelView.hidden = YES;
}

- (void)segmentValueChanged:(UISegmentedControl *)sender
{
    if (0 == sender.selectedSegmentIndex) {
        [self showDetailView];
    }
    else
    {
        [self showConditionView];
    }
}

- (void)doSearchRequestWithPostPara:(NSDictionary *)aParam
{
    [self.HUD showActivityTypeHUDViewWithText:@"查找中..."];
    
    //防止self被retain
    __weak NSMutableArray *tempArr = self.resultData;
    __weak CBSearchViewController *tempVC = self;
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    
    if (NETWORK_AVAILIABLE) {
        
        [client postPath:@"search.php" parameters:aParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //清空查找结果
            [tempArr removeAllObjects];
            NSArray *resultArray = (NSArray *)responseObject;
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [tempArr addObject:[[CBUser alloc]initWithDictionary:obj]];
                [tempArr addObject:obj];
            }];
            
            [tempVC.HUD hide:YES];
            [tempVC.resultTabelView reloadData];
            tempVC.resultTabelView.hidden = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"search request Failed!error:%@", [error localizedDescription]);
            //MBProgessHUD 显示信息
            NSString *failMsg = operation.responseString;
            DLog(@"failMsg = %@",failMsg);
            [tempVC.HUD showTextTypeHUDViewWithText:failMsg];
            
        }];
    }
    else {
        [self.HUD showTextTypeHUDViewWithText:@"无网络连接，请检查网络！"];
    }
}

- (void)addButtonTapped:(UIButton *)aButton
{
    //添加好友
    UITableViewCell *cell = (UITableViewCell *)aButton.superview;
    NSIndexPath *indexPath = [_resultTabelView indexPathForCell:cell];
    NSInteger row = [indexPath row];
//    CBUser *user = [self.resultData objectAtIndex:row];
    NSDictionary *user = [self.resultData objectAtIndex:row];
    
    [self.alerView setMessage:[NSString stringWithFormat:@"你确定要添加%@为好友吗？",[user objectForKey:@"name"]]];
    //alertview 传递添加的那个位置的好友
    self.alerView.tag = row;
    
    [self.alerView show];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"userAddResult";
    CBUserPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (nil == cell) {
        cell = [[CBUserPreviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    NSInteger row = [indexPath row];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"blueBtnBg.png"] forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(240, 15, 60, 30)];
    [addBtn addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:addBtn];
    
    cell.userName.text = [[self.resultData objectAtIndex:row] objectForKey:@"name"];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {

        [self.view bringSubviewToFront:self.HUD];
        //__weak NSMutableArray *tempArr = self.resultData;
        __weak CBSearchViewController *tempVC = self;
        ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
        
        //CBUser *userToAdd = [self.resultData objectAtIndex:alertView.tag];
        NSDictionary *userToAdd = [self.resultData objectAtIndex:alertView.tag];
        //post数据 此处group_id留空
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[[userToAdd objectForKey:@"user_id"] intValue]], @"user_id2", [NSNumber numberWithInteger:[CBCurrentUser currentUser].user_id], @"user_id", nil];
        
        if (NETWORK_AVAILIABLE) {
            
            [client postPath:@"addFriend.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ([[CBCurrentUser currentUser]addFriendWithUser:userToAdd])
                {
                    //CBProgessHUD 显示信息
                    [tempVC.HUD showTextTypeHUDViewWithText:@"添加好友成功！"];
                }
                else
                {
                    //CBProgessHUD 显示信息
                    [tempVC.HUD showTextTypeHUDViewWithText:@"添加好友失败！local error！"];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                DLog(@"addFriend request Failed!error:%@", [error localizedDescription]);
                //MBProgessHUD 显示信息
                NSString *failMsg = operation.responseString;
                DLog(@"failMsg = %@",failMsg);
                [tempVC.HUD showTextTypeHUDViewWithText:failMsg];
                
            }];
        }
        else {
            [self.HUD showTextTypeHUDViewWithText:@"无网络连接，请检查网络！"];
        }

    }
}


@end
