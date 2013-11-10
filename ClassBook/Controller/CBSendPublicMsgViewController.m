//
//  CBSendPublicMsgViewController.m
//  ClassBook
//
//  Created by Parker on 21/4/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBSendPublicMsgViewController.h"
#import "CBPostitNoteViewController.h"
#import "CBDatabase.h"
#import "CBGroup.h"

@interface GroupBtn : UIButton

@property (assign, nonatomic) int groupid;

@end
@implementation GroupBtn
@synthesize groupid;

@end



@interface CBSendPublicMsgViewController ()

@property (strong, nonatomic) NSDictionary *groupBtnframesDic;
@property (strong, nonatomic) NSMutableArray *groupsInfoArr;
@end

@implementation CBSendPublicMsgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getGroupsInfo
{
    self.groupsInfoArr = [[CBDatabase sharedInstance]getUserGroupsByUserId: [[CBCurrentUser currentUser] user_id]];
}

//SendMsgGroupBtnsFrames
- (NSDictionary *)getGroupViewsFrames
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SendMsgGroupBtnsFrames" ofType:@"plist"];
    NSDictionary *groupViewsFrameDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    return groupViewsFrameDic;
}

- (UIView *)createAGroupBtn:(NSDictionary *)aFrame title:(NSString*)atitle
{
    float x= [(NSNumber *)[aFrame objectForKey:@"x"] floatValue];
    float y= [(NSNumber *)[aFrame objectForKey:@"y"] floatValue];
    float width = [(NSNumber *)[aFrame objectForKey:@"width"] floatValue];
    float height = [(NSNumber *)[aFrame objectForKey:@"height"] floatValue];
    NSString * image = (NSString *)[aFrame objectForKey:@"image"];
    
    GroupBtn *aGroupBtn = [GroupBtn buttonWithType:UIButtonTypeCustom];
//    [aGroupBtn setImage:[UIImage imageNamed:@"kitten.jpg"] forState:UIControlStateNormal];
//    [aGroupBtn setBackgroundColor:[UIColor greenColor]];
    [aGroupBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //[aGroupBtn setTitle:atitle forState:UIControlStateNormal];
    
    aGroupBtn.frame = CGRectMake(x, y, width, height);
    [aGroupBtn addTarget:self action:@selector(GroupBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    return aGroupBtn;
}

- (void)addAllViewToView:(NSDictionary *)btnFameDic
{
    for (CBGroup * obj in self.groupsInfoArr) {
        NSDictionary * aFrameDic = [self.groupBtnframesDic objectForKey:obj.group_name];
        GroupBtn *aGroupBtn = (GroupBtn *)[self createAGroupBtn:aFrameDic title:obj.group_name];
        aGroupBtn.groupid = obj.group_id;
        [self.view addSubview:aGroupBtn];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"发送公共留言";
    [self getGroupsInfo];
    self.groupBtnframesDic = [self getGroupViewsFrames];
    [self addAllViewToView:self.groupBtnframesDic];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- self methods
- (void)GroupBtnPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BlackboardStoryboard" bundle:[NSBundle mainBundle]];
    CBPostitNoteViewController* postNoteVC  = (CBPostitNoteViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CBPostitNoteViewController"];
    postNoteVC.groupid = [(GroupBtn *)sender groupid];
//    DLog(@"hello world %d",[(GroupBtn *)sender groupid]);
    [self presentViewController:postNoteVC animated:YES completion:nil];
}

@end
