//
//  CBPostitNoteViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBPostitNoteViewController.h"
#import "CBDatabase.h"

@interface CBPostitNoteViewController ()

@end

@implementation CBPostitNoteViewController
@synthesize delegateForAdd;

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
//    DLog(@"itswyy groupid = %d",self.groupid);
    //收回软键盘
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //添加便利贴
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]];
    imageView.userInteractionEnabled = YES;
    imageView.frame =  CGRectMake(30, 50, 300, 300);
    imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:imageView];
    
    //添加便利贴的文本框
    textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 60, 200, 180)];
    textView.delegate = self;
    textView.tag = 500;
    textView.font = [UIFont fontWithName:@"KaiTi_GB2312" size:21];
    textView.backgroundColor = [UIColor clearColor];
    [imageView addSubview:textView];
    
    //便利贴上添加时间lable
    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 240, 140, 20)];
    dateLabel.tag = 510;
    dateLabel.backgroundColor = [UIColor clearColor];
    NSDate * newDate = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * newDateOne = [dateformat stringFromDate:newDate];
    [dateformat setFormatterBehavior:NSDateFormatterFullStyle];
    [dateformat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    textView.text = @"在这里输入记事本内容";
    dateLabel.text = newDateOne;
    dateString = [[NSString alloc]initWithString:newDateOne];
    dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:15];//MarkerFelt-Thin
    dateLabel.transform = CGAffineTransformMakeRotation(-1.57789/20);
    [imageView addSubview:dateLabel];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - keyboard will show

/**
 *	收回键盘
 *
 *	@param 	recognizer 	触发手势
 */
-(void)hideKeyboard:(UITapGestureRecognizer *)recognizer
{
    [textView resignFirstResponder];
    if (textView.text.length <=0) {
        textView.text = @"在这里输入记事本内容";
    }
}

#pragma mark - UITextViewDelegate

/**
 *	开始编辑时，去掉默认文本
 *
 *	@param 	atextView 	文本编辑框
 */
- (void)textViewDidBeginEditing:(UITextView *)atextView

{
    if ([textView.text isEqualToString:@"在这里输入记事本内容"]) {
        textView.text = nil;
    }
}

/**
 *	保存编辑好的NOTE
 */
-(IBAction)saveNote
{
    int userid = [[CBCurrentUser currentUser] user_id];
    int groupid= self.groupid;
    NSString *msgcontent = textView.text;
    NSString *msgtime = dateLabel.text;
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:userid],@"user_id",[NSNumber numberWithInt:groupid] ,@"group_id",msgcontent,@"msg_content",msgtime,@"msg_time",nil];
        
    ClassBookAPIClient *httpClient = [ClassBookAPIClient sharedClient];

    [httpClient postPath:@"sendMsg.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"insert msg to the group succeed!resonse = %@",[responseObject objectAtIndex:0]);

//TODO:此处只用与看效果，往服务端和本地同时插入数据，逻辑有待解决
//做测试用
       NSArray * arr = [[NSArray alloc] initWithObjects:parameters, nil];
       BOOL res = [[CBDatabase sharedInstance] insertData:arr forTable:@"message"];
        if (res) {
            DLog(@"insert local succeed");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"insert msg to the group failed! error == %@",error);
    }];
//TODO:最后需要刚开，保存完了后就消失
    [self dismissModalViewControllerAnimated:YES];
    
}


- (IBAction)backToBlackboard:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 *	当此视图退出时，小黑板重载数据
 *
 *	@param 	animated
 */
//- (void)viewDidDisappear:(BOOL)animated
//
//{
//    [self.delegateForAdd refreshBlackBoard];
//}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.delegateForAdd  = nil;
}

@end
