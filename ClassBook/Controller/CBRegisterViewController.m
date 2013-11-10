//
//  CBRegisterViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBRegisterViewController.h"
#import "CBDatabase.h"
#import "NSString+MD5.h"

//定义注册方式枚举
typedef enum registerAccountType{
    CBRegisterAccountTypeEmail = 1,
    CBRegisterAccountTypePhone = 2,
} CBRegisterAccountType;

@interface CBRegisterViewController ()
@property (nonatomic, strong) CBDepthViewController *depthView;
@property (nonatomic, strong) CBTopViewController *topViewController;

/**
 *	判断当前是否可以注册
 *
 *	@return	
 */
//- (BOOL)canRegisterUser;

@end

@implementation CBRegisterViewController
@synthesize registerOption;
@synthesize protocolLable;
@synthesize protocolImage;
@synthesize methodLale;
@synthesize nameText;
@synthesize emailOrTelText;
@synthesize pswdText;
@synthesize repswdText;
@synthesize cancelButton;
@synthesize sureButton;
@synthesize checkEoTImage;
@synthesize checkNameImage;
@synthesize checkPswdImage;
@synthesize checkRepswdImage;
@synthesize isAgreeProtocol;
@synthesize res_agreeProtocol;

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
	self.isAgreeProtocol = YES;//起始状态时默认同意协议
    self.registerOption = 1;//默认使用邮箱注册
    //添加选项卡部分
    CBRegisterMethodView *registerMethod = [[CBRegisterMethodView alloc]init];
    registerMethod.delegate = self;
    [self.view addSubview:registerMethod];
    
    res_agreeProtocol = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(presentView:)];
    self.protocolLable.userInteractionEnabled = YES;
    [self.protocolLable addGestureRecognizer:res_agreeProtocol];
    
    //获取TOPviewcontroller
    UIStoryboard *storyboard = self.storyboard;
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"CBTopViewController"];
        
    UITapGestureRecognizer *reg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    self.depthView = [[CBDepthViewController alloc]initWithGestureRecognizer:reg];
    
    self.topViewController.depthViewReference = self.depthView;
    self.topViewController.presentedInView = self.view;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]]];
}

- (void)dismiss {
    [self.depthView dismissPresentedViewInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)presentView:(id)sender {
    [self.depthView presentViewController:self.topViewController inView:self.view];
}

- (void)addEmailRegisterView
{
    if (![self.methodLale.text isEqualToString:@"邮       箱："])
    {
        self.methodLale.text = @"邮       箱：";
        self.emailOrTelText.placeholder = @"好童鞋都写正确的邮箱";
    }
    self.registerOption = 1;
}

- (void)addPhoneRegisterView
{
    if (![self.methodLale.text isEqualToString:@"电       话："])
    {
        self.methodLale.text = @"电       话：";
        self.emailOrTelText.placeholder = @"好童鞋都写正确的电话";
    }
    self.registerOption = 2;
}

- (IBAction)checkEmailoPhone:(id)sender
{
    if (self.registerOption == 1) {
        NSPredicate *emailCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_EMAIL];
        NSString *email = self.emailOrTelText.text;
        BOOL isMatchEmail = [emailCheck evaluateWithObject:email];
        
        if (isMatchEmail) {
            self.checkEoTImage.image = [UIImage imageNamed:@"CheckOK.png"];
        }else
        {
            self.checkEoTImage.image = [UIImage imageNamed:@"CheckError.png"];
        }
    }
    
    if (self.registerOption == 2) {
        NSPredicate *phoneCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_TELEPHONE];
        NSString *phone = self.emailOrTelText.text;
        BOOL isMatchPhone = [phoneCheck evaluateWithObject:phone];
        
        if (isMatchPhone) {
            self.checkEoTImage.image = [UIImage imageNamed:@"CheckOK.png"];
        }else
        {
            self.checkEoTImage.image = [UIImage imageNamed:@"CheckError.png"];
        }
    }
}


- (IBAction)checkName:(id)sender
{
    NSPredicate *nameCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_NAME];
    NSString *name = self.nameText.text;
    BOOL isMatchName = [nameCheck evaluateWithObject:name];
    
    if (isMatchName) {
        self.checkNameImage.image = [UIImage imageNamed:@"CheckOK.png"];
    }else
    {
        self.checkNameImage.image = [UIImage imageNamed:@"CheckOK.png"];
    }

}
- (IBAction)checkPswd:(id)sender
{
    NSPredicate *pswdCheck = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_PSWD];
    NSString *pswd = self.pswdText.text;
    BOOL isMatchPswd = [pswdCheck evaluateWithObject:pswd];
    
    if (isMatchPswd) {
        self.checkPswdImage.image = [UIImage imageNamed:@"CheckOK.png"];
    }else
    {
        self.checkPswdImage.image = [UIImage imageNamed:@"CheckError.png"];
    }

}
- (IBAction)checkRepswd:(id)sender
{
    NSString *repswd = self.repswdText.text;
    BOOL isMatchRepswd= [repswd isEqualToString:self.pswdText.text];
    
    if (isMatchRepswd) {
        self.checkRepswdImage.image = [UIImage imageNamed:@"CheckOK.png"];
    }else
    {
        self.checkRepswdImage.image = [UIImage imageNamed:@"CheckError.png"];
    }

}

- (IBAction)changeAgreeProtocolImage
{
    if (self.isAgreeProtocol) {
        self.isAgreeProtocol = NO;
    }else
    {
        self.isAgreeProtocol = YES;
    }
    
    if (self.isAgreeProtocol) {
        [self.protocolImage setImage:[UIImage imageNamed:@"CheckOK.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.protocolImage setImage:[UIImage imageNamed:@"CheckError.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.emailOrTelText resignFirstResponder];
    [self.nameText resignFirstResponder];
    [self.pswdText resignFirstResponder];
    [self.repswdText resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if (frame.origin.y<10) {
        frame.origin.y +=116;
        frame.size. height -=116;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)textFiledReturnEditing:(id)sender
{
//TODO: 小雨此处处理好像是有问题，点击确认密码后在点击其他的会跑没了
    [sender resignFirstResponder];
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if (frame.origin.y<10) {
        frame.origin.y +=116;
        frame.size. height -=116;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)upViews:(id)sender
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if (frame.origin.y<30) {
        frame.origin.y -=116;
        frame.size. height +=116;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    self.emailOrTelText.text = @"";
    self.nameText.text = @"";
    self.pswdText.text = @"";
    self.repswdText.text = @"";
    [self.protocolImage setImage:[UIImage imageNamed:@"CheckOK"] forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}

//TODO:itswyy 此处需要将他们分在几个函数中
- (IBAction)sureButtonPressed:(id)sender
{
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    //生成POST参数
   __block NSDictionary *postParam;
    CBRegisterAccountType CBRtype = self.registerOption;
    NSString *emailoTel = self.emailOrTelText.text;
    NSString *name = self.nameText.text;
    NSString *pwd =self.pswdText.text;
    NSString *repwd = self.repswdText.text;
    if (![pwd isEqualToString:repwd]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，确认密码不正确！"delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        self.repswdText.text = @"";
        return;
    }
    
    NSString *pswd =[NSString MD5ByAStr:pwd];
    
    DLog(@"%@ name %@ pswd",name ,pswd);
    if ([emailoTel isEqualToString:@""] || [name isEqualToString:@""] || [pwd isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，请完善个人注册信息"delegate:self cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    switch (CBRtype) {
        case 1:
            postParam = [NSDictionary dictionaryWithObjectsAndKeys:emailoTel, @"email", name, @"name",pswd, @"password", @"",@"tel_num",nil];
            break;
        case 2:
            postParam = [NSDictionary dictionaryWithObjectsAndKeys:emailoTel, @"tel_num", name, @"name",pswd, @"password",@"",@"email",nil];
            break;
        default:
            break;
    }
    
//    NSLog(@"postParam ===%@===",postParam);
    [client postPath:@"register.php" parameters:postParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //注册成功页面跳转
//        DLog(@"request succeed! resonseObject = %@, operation = %@", responseObject, operation);
        
        NSNumber *userid = [(NSArray *)responseObject objectAtIndex:0];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"亲，你的账号为%d",[userid intValue]] delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Sure", nil];
        [alert show];
        [self dismissModalViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //MBProgessHUD 显示信息
//        DLog(@"failer response string = %@", operation.responseString);        
//        DLog(@"request Failed!error:%@, operation = %@", [error localizedDescription], operation);

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"亲，你注册失败！" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Sure", nil];
        [alert show];
    }];
}

@end
