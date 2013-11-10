//
//  CBPersonViewController.m
//  ClassBook
//
//  Created by Admin on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBPersonViewController.h"
#import "CBDatabase.h"
#import "CBPersonalDetailCell.h"
#import "CBUserAdviceViewController.h"

@interface CBPersonViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong ,nonatomic) UITableView *detailTableView;
@property (strong ,nonatomic) NSDictionary *personalDetailDic;
@property (strong ,nonatomic) NSArray *dataSource;

@end

@implementation CBPersonViewController

@synthesize user_id = _user_id;
@synthesize userInfoDic = _userInfoDic;

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
	// Do any additional setup after loading the view.
    
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 440) style:UITableViewStyleGrouped];
    self.detailTableView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:self.detailTableView];
    [self.view insertSubview:self.detailTableView atIndex:0];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.separatorColor = [UIColor clearColor];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ShowPersonalMenu" ofType:@"plist"];
    self.personalDetailDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataSource = [self.personalDetailDic allKeys];

//    DLog(@"%@",_personalDetailDic);
    
    UIBarButtonItem *seeBtn = [[UIBarButtonItem alloc] initWithTitle:@"查看赠言" style:UIBarButtonItemStylePlain target:self action:@selector(seeAdvice)];
    self.navigationItem.rightBarButtonItem = seeBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];

    
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg3.jpg"]];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
}

- (void)seeAdvice
{
    CBUserAdviceViewController * advice = [[CBUserAdviceViewController alloc]init];
    if ([CBCurrentUser currentUser].user_id == 0)
    {
        advice.user_id = 0;
        advice.advices = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:[_userInfoDic objectForKey:@"advice_add"],@"advice",[_userInfoDic objectForKey:@"advice_time"],@"time",nil],nil];
//        DLog(@"userInfoDic = %@",_userInfoDic);
    }
    else
    {
        advice.user_id = _user_id;
        if ([_userInfoDic objectForKey:@"outline_group_id"])
        {
            advice.advices = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:[_userInfoDic objectForKey:@"advice_add"],@"advice",[_userInfoDic objectForKey:@"advice_time"],@"time",nil],nil];
        }
        else
        {
            advice.advices = [[CBDatabase sharedInstance]getUserAdviceInfoByUserID:[CBCurrentUser currentUser].user_id FromUserID:_user_id];
        }
        
    }
    
    [self.navigationController pushViewController:advice animated:YES];
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    
    UIImageView * head_image = [[UIImageView alloc]initWithFrame:CGRectMake(44, 15, 77, 81)];
    
    NSString * headImage = [_userInfoDic objectForKey:@"head_portrait"];
    if ([headImage isEqualToString:@"nohead"]) {
        if ([_userInfoDic objectForKey:@"sex"] == [NSNull null] || [[_userInfoDic objectForKey:@"sex"] intValue] == 1 || [_userInfoDic objectForKey:@"sex"] == nil) {
            headImage = ISDEFAULT_HEAD_MALE;
        }
        else
        {
            headImage = ISDEFAULT_HEAD_FEMALE;
        }
    }
    [head_image setImage:[UIImage imageNamed:headImage]];
    [view addSubview:head_image];
    
    UILabel * name_label = [[UILabel alloc]initWithFrame:CGRectMake(155, 24, 128, 21)];
    [name_label setText:[_userInfoDic objectForKey:@"name"]];
    [name_label setFont:[UIFont boldSystemFontOfSize:19]];
    [name_label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:name_label];
    
    UILabel * sex_label = [[UILabel alloc]initWithFrame:CGRectMake(161, 66, 30, 21)];
    [sex_label setText:[_userInfoDic objectForKey:@"name"]];
    [sex_label setFont:[UIFont systemFontOfSize:17]];
    [sex_label setBackgroundColor:[UIColor clearColor]];
    [view addSubview:sex_label];
    
    //!= [NSNull null]
    if ([_userInfoDic objectForKey:@"sex"] == [NSNull null] || [[_userInfoDic objectForKey:@"sex"] intValue] == 1 || [_userInfoDic objectForKey:@"sex"] == nil)
    {
        [sex_label setText:@"女"];
    }
    else
    {
        [sex_label setText:@"男"];
    }
    
    //NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
    //int age=trunc(dateDiff/(60*60*24))/365;
    
    UILabel * age_label = [[UILabel alloc]initWithFrame:CGRectMake(217, 66, 71, 21)];
    [age_label setText:[_userInfoDic objectForKey:@"age"]];
    [age_label setFont:[UIFont systemFontOfSize:17]];
    [age_label setBackgroundColor:[UIColor clearColor]];
    //[age_label setText:[NSString stringWithFormat:@"22岁"]];
    
    [view addSubview:age_label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 33.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * reuserIdentifer = @"ShowpersonalMenuCell";
    
    CBPersonalDetailCell *cell = (CBPersonalDetailCell *)[tableView dequeueReusableCellWithIdentifier:reuserIdentifer];
    
    if (!cell) {
        cell = [[CBPersonalDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifer];
    }
    
    int row = [indexPath row];
    NSString *menuLableText = [NSString stringWithFormat:@"%@ :",[self.personalDetailDic objectForKey:[self.dataSource objectAtIndex:row]]];
    cell.myImageView = nil;
    cell.myLable.text = menuLableText;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    id textViewValue = [_userInfoDic objectForKey:[[self.dataSource objectAtIndex:row] lowercaseString]];

    //DLog(@"%@",textViewValue);
    
    if (textViewValue != [NSNull null])
    {
        cell.myTextView.text = textViewValue;
    }
    else
    {
        cell.myTextView.text = nil;
    }
    [cell.myTextView setUserInteractionEnabled:NO];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.detailTableView reloadData];
}
@end
