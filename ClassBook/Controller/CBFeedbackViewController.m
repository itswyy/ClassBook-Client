//
//  CBFeedbackViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-4-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBFeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface CBFeedbackViewController ()<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MFMailComposeViewController *emailVC;

@end

@implementation CBFeedbackViewController

@synthesize textView = _textView;
@synthesize titleText = _titleText;
@synthesize emailVC = _emailVC;

#pragma mark - Lazy Initialization

- (MFMailComposeViewController *)emailVC
{
    if (nil == _emailVC) {
        _emailVC = [[MFMailComposeViewController alloc]init];
        _emailVC.mailComposeDelegate = self;
    }
    return _emailVC;
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
	
    [self configerTextView];
    
    self.navigationItem.title = @"意见反馈";
    UIBarButtonItem *sendBar = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendFeedbackMsg:)];
    self.navigationItem.rightBarButtonItem = sendBar;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"commonBack.png"]];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleText:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - Self Methods

#pragma mark - Self Private Methods

- (IBAction)closeTheKeyboard
{
    [self.textView resignFirstResponder];
    [self.titleText resignFirstResponder];
}

- (void)configerTextView
{
    [_textView.layer setCornerRadius:10.0f];
    [_textView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_textView.layer setBorderWidth:1];
    [_textView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_textView.layer setShadowOpacity:0.9];
    [_textView.layer setShadowRadius:3.0];
    [_textView.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    [_textView.layer setMasksToBounds:YES];
    _textView.clipsToBounds = YES;
    
    [_textView setReturnKeyType:UIReturnKeyNext];
    
    _textView.delegate = self;
}

- (void)sendFeedbackMsg:(UIButton *)button
{
    NSString *title = self.titleText.text;
    NSString *content = self.textView.text;
    
    if (nil == title || nil == content) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"出错了"
                                                       message:@"亲，请把信息填写完整，再反馈给我们！"
                                                      delegate:nil
                                             cancelButtonTitle:@"好的"
                                             otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if ([MFMailComposeViewController canSendMail])
    {
        //本地发送email
        [self sendEmailByLocalServerWithTitle:title andMessageBody:content];
    }
//    else
//    {
        //通过服务端发送email
        [self sendEmailByRemoteServerWithTitle:title andMessageBody:content];
//    }
}

- (void)sendEmailByLocalServerWithTitle:(NSString *)aTitle andMessageBody:(NSString *)aBody
{
    [self.emailVC setSubject:aTitle];
    [self.emailVC setMessageBody:aBody isHTML:NO];
    [self.emailVC setToRecipients:[NSArray arrayWithObject:@"classbook@hotmail.com"]];
    if (self.emailVC) {
        [self presentModalViewController:self.emailVC animated:YES];
    }
}

- (void)sendEmailByRemoteServerWithTitle:(NSString *)aTitle andMessageBody:(NSString *)aBody
{
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:aTitle, @"email_subject", aBody, @"email_body", nil];
    
    if (NETWORK_AVAILIABLE) {
        
        [client postPath:@"feedback.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DLog(@"feedback succeed! %@", responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"feedback request Failed!error:%@", [error localizedDescription]);
        }];
    }
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"感谢你"
                                                       message:@"亲，感谢你的反馈，我们会做的更好！"
                                                      delegate:nil
                                             cancelButtonTitle:@"好的"
                                             otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        DLog(@"Send local email error: %@", [error localizedDescription]);
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
