//
//  CBDetailMessageViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBDetailMessageViewController.h"

@interface CBDetailMessageViewController ()

@end

@implementation CBDetailMessageViewController

@synthesize indexNumber;
@synthesize delegate;

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
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
//	self.navigationItem.leftBarButtonItem = item;
//    
//    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteItem:)];
//    self.navigationItem.rightBarButtonItem = deleteButton;
//    
//    //添加便利贴
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"notepad.png"]];
//    imageView.userInteractionEnabled = NO;
//    imageView.frame =  CGRectMake(10, 10, 300, 350);
//    imageView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:imageView];
//    
//    textView = [[UITextView alloc]initWithFrame:CGRectMake(35, 60, 200, 180)];
//    textView.delegate = self;
//    textView.tag = 500;
//    textView.font = [UIFont fontWithName:@"KaiTi_GB2312" size:21];
//    textView.backgroundColor = [UIColor clearColor];
//    textView.userInteractionEnabled = NO;
//    [imageView addSubview:textView];
//    
//    dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 285, 150, 30)];
//    dateLabel.tag = 510;
//    dateLabel.backgroundColor = [UIColor clearColor];
//    dateLabel.font = [UIFont fontWithName:@"AmericanTypewriter-CondensedLight" size:17];
//    dateLabel.transform = CGAffineTransformMakeRotation(-M_PI_2/20);
//    [imageView addSubview:dateLabel];

    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
}



/**
 *	视图出现前加载记录数据
 *
 *	@param 	animated 	
 */
- (void)viewWillAppear:(BOOL)animated

{
//    NSMutableArray *dataMutableArray = [[NSUserDefaults standardUserDefaults]mutableArrayValueForKey:@"note"];
//    textView.text = [[dataMutableArray objectAtIndex:indexNumber] objectForKey:@"text"];
//    dateLabel.text = [[dataMutableArray objectAtIndex:indexNumber]objectForKey:@"date"];
    
}

/**
 *	关闭此视图
 *
 *	@param 	
 */
-(void)close:(id)sender{

    [delegate DetailViewControllerClose:self];
}

/**
 *	删除便利贴
 *
 *	@param 	sender 	
 */
-(void)deleteItem:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //取消
            break;
        case 1:
            //确定
        {
            //TODO:这里要从数据库里删除
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.delegate = nil;
}


- (IBAction)backToBlackboard:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
}

@end
