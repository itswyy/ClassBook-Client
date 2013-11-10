//
//  CBLoginViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-3-3.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBLoginViewController.h"
#import "NSString+MD5.h"
#import "CBProgressHUD.h"
#import "CBDatabase.h"
#import "UIDevice+UniqueIdentifier.h"
#import "CBHomeViewController.h"

@interface CBLoginViewController ()

@property (strong, nonatomic) CBProgressHUD *HUD;

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)accountEditEnd:(id)sender;
- (IBAction)pswEditEnd:(id)sender;

- (void)doLogin;
- (void)goToNextScene;
- (NSString *)checkLoginAccountType;
- (void)syncUserData:(NSNotification *)notification;

- (void)createLogoView;

@end

@implementation CBLoginViewController

@synthesize loginText = _loginText;
@synthesize loginLabel = _loginLabel;
@synthesize pswText = _pswText;
@synthesize pswLable = _pswLable;
@synthesize HUD = _HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View LifeCycles

//
- (void)showRegestView
{
    [self performSegueWithIdentifier:@"ShowRegestView" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //为用户首次登陆同步注册消息中心
    NSNotificationCenter *NTFCenter = [NSNotificationCenter defaultCenter];
    [NTFCenter addObserver:self selector:@selector(syncUserData:) name:NNUSER_FIRST_LOGIN object:nil];
    [NTFCenter addObserver:self selector:@selector(goToNextScene) name:NNUSER_LOGIN_SUCCEED object:nil];
    
    
    //[self createLogoView];
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginback.png"]];
    
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setImage:[UIImage imageNamed:@"loginBtn.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
//    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    
    loginBtn.frame = CGRectMake(80, 163, 160, 44);
    [self.view addSubview:loginBtn];
    
    UIButton *tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tryBtn setImage:[UIImage imageNamed:@"tryBtn.png"] forState:UIControlStateNormal];
    [tryBtn addTarget:self action:@selector(localLoginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    tryBtn.frame = CGRectMake(80, 293, 160, 44);
    [self.view addSubview:tryBtn];
    
    self.regestGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showRegestView)];
    self.regestLable.userInteractionEnabled = YES;
    [self.regestLable addGestureRecognizer:self.regestGesture];
    
    //MBProgressHUD initialize
    _HUD = [[CBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.HUD];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.loginText.text = @"";
    self.pswText.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoginLabel:nil];
    [self setPswLable:nil];
    [self setLoginText:nil];
    [self setPswText:nil];
    [self setHUD:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self setRegestLable:nil];
    [super viewDidUnload];
}

//orientation for lower ios 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait;
}

//orientation for ios 6
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //登陆
    if ([@"CBLoginSucceed" isEqualToString:[segue identifier]])
    {
        UIViewController *destVC = [segue destinationViewController];
        destVC.navigationItem.hidesBackButton = YES;
        destVC.navigationItem.title = @"学生时代";
    }
}

#pragma mark - Self Methods

- (void)loginByLoginID:(NSString *)aLoginID andPassword:(NSString *)aPassword
{
    //防止self被retain
    __weak CBProgressHUD *tempHUD = self.HUD;
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    
    if (NETWORK_AVAILIABLE)
    {
        //生成POST参数
        NSString *accountType = [self checkLoginAccountType];
        NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:aLoginID, accountType, aPassword, @"password", nil];
        DLog(@"%@",postParam);

        [client postPath:@"login.php" parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DLog(@"Login request succeed!");
            NSNumber *user_id = [(NSArray *)responseObject objectAtIndex:0];
            
            //数据库处理数据
            if (![[CBDatabase sharedInstance] updateUserAccount:aLoginID andPassword:aPassword withAccountType:accountType andUserID:user_id])
            {
                DLog(@"Database update data failed");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"Login request Failed!error:%@", [error localizedDescription]);
            //MBProgessHUD 显示信息
            NSString *failMsg = operation.responseString;
            [tempHUD showTextTypeHUDViewWithText:failMsg];
            
        }];
    }
    else
    {
        //查询本地数据库
        if (![[CBDatabase sharedInstance]selectLoginByAccount:aLoginID andPassword:aPassword withAccountType:[self checkLoginAccountType]])
        {
            NSString *failMsg = @"账号或密码错误";
            [tempHUD showTextTypeHUDViewWithText:failMsg];
        }
        else
        {
            [self goToNextScene];
        }
        
    }
    
}

#pragma mark - Self Private Methods

- (IBAction)hideKeyboard:(id)sender
{
    [self.loginText resignFirstResponder];
    [self.pswText resignFirstResponder];
}

- (IBAction)accountEditEnd:(id)sender
{
    [self.pswText becomeFirstResponder];
}

- (IBAction)pswEditEnd:(id)sender
{
    //设置currentUser的ID
    [[CBCurrentUser currentUser]setUser_id:[self.loginText.text intValue]];
    [self doLogin];
}
- (IBAction)localLoginBtnPressed:(id)sender
{
    //设置currentUser的ID
    [[CBCurrentUser currentUser]setUser_id:0];
    [self goToNextScene];
}

- (void)doLogin
{
    [self.HUD showActivityTypeHUDViewWithText:@"登录中..."];
    //登陆判定
    [self loginByLoginID:self.loginText.text andPassword:[NSString MD5ByAStr:self.pswText.text]];
}

- (void)goToNextScene
{
    //currentUser初始化信息
    [[CBCurrentUser currentUser] formatCurrentUser];
    //页面跳转
    [self.HUD hide:YES];
    [self performSegueWithIdentifier:@"CBLoginSucceed" sender:self];
}

- (NSString *)checkLoginAccountType
{
    NSRegularExpression *emailRE = [NSRegularExpression regularExpressionWithPattern:REGEX_EMAIL options:NSRegularExpressionCaseInsensitive error:nil];
    NSRegularExpression *nameRE = [NSRegularExpression regularExpressionWithPattern:REGEX_NAME options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *loginAccout = self.loginText.text;
    NSString *accountType = @"user_id";
    
    //检测匹配
    NSUInteger matchNum = [emailRE numberOfMatchesInString:loginAccout options:NSMatchingAnchored range:NSMakeRange(0, loginAccout.length)];
    if (0 < matchNum)
    {
        accountType = @"email";
    }
    matchNum = [nameRE numberOfMatchesInString:loginAccout options:NSMatchingAnchored range:NSMakeRange(0, loginAccout.length)];
    if (0 < matchNum)
    {
        accountType = @"name";
    }
    
    return accountType;
    
}

- (void)syncUserData:(NSNotification *)notification
{
    //用户信息首次同步 by wtlucky.
    self.HUD.labelText = @"首次登陆，初始化中...";
    //self.HUD.detailsLabelText = @"请稍等...";
    
    NSNumber *user_id = [notification.userInfo objectForKey:@"userId"];
    NSString *uniqueDeviceIdentifier = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    
    NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:user_id, @"user_id", uniqueDeviceIdentifier, @"device_id", nil];
    
    DLog(@"first login postParam = %@", postParam);
    
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    [client postPath:@"getAllData.php" parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"request first user all info succeed! info = %@", responseObject);
        
        //本地数据库同步
        BOOL res = [[CBDatabase sharedInstance] synchronizeUserDataByFirstTimeWithADictionary:responseObject];
        if (res)
        {
            DLog(@"first user all data sync Succeed!");
            [self goToNextScene];
        }
        else
        {
            NSString *failMsg = @"初始化数据失败，请重新登陆！";
            [self.HUD showTextTypeHUDViewWithText:failMsg];
        }
     
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DLog(@"syncUserData failed! %@, error = %@", operation.responseString, [error localizedDescription]);
        NSString *failMsg = @"初始化数据失败，请重新登陆！";
        [self.HUD showTextTypeHUDViewWithText:failMsg];
        
    }];
}

- (void)createLogoView
{
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.frame = CGRectMake(135, 345, 50, 50);
    logoImageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:logoImageView];
    
    UILabel *logoLabel = [[UILabel alloc]init];
    logoLabel.frame = CGRectMake(0, 396, 320, 20);
    logoLabel.text = @"Copyright ©2012 ClassBook, Inc. All Rights Reserved.";
    logoLabel.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4f];
    logoLabel.font = [UIFont systemFontOfSize:10.0f];
    logoLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:logoLabel];
    
}

@end
