//
//  CBPersonalDetailViewController.m
//  ClassBook
//
//  Created by Parker on 16/4/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBPersonalDetailViewController.h"
#import "CBPersonalDetailCell.h"
#import "CBDatabase.h"
#import "CBCurrentUser.h"
#import "DDMenuController.h"
#import "CBDrawMenuViewController.h"
#import "ImageStore.h"

//headPhotoBtn relatived
static const float kHeadPhotoBtnOffSetX = 10.0f;
static const float kHeadPhotoBtnOffSetY = 10.0f;
static const float kHeadPhotoBtnWidth = 70.0f;
static const float kHeadPhotoBtnHeight = 70.0f;
static NSString *kHeadPortraitImg = ISDEFAULT_HEAD_MALE;
static NSString * reuserIdentifer = @"personalMenuCell";

//addMsgButton relatived
static const float kAddMsgButtonOffSetX = 10.0f;
static const float kAddMsgButtonOffSetY = 10.0f;
static const float kAddMsgButtonWidth = 300.0f;
static const float kAddMsgButtonHeight = 42.0f;
static const float kAddMsgTitleFontSize = 18.0f;
static NSString *kAddMsgButtonTitle = @"添加赠言";

static NSString *kDefualUserName = @"Parker";

@interface CBPersonalDetailViewController ()
<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong ,nonatomic) UITextView *firsRespondTextView;
@property (strong ,nonatomic) DDMenuController *middleViewController;

@property (strong ,nonatomic) NSString *headerName;
@property (strong, nonatomic) NSString *headerQQ;
@property (strong, nonatomic) NSString *headerEmail;

@property (strong ,nonatomic) UITextField *headerNameField;
@property (strong ,nonatomic) UITextField *headerQQField;
@property (strong ,nonatomic) UITextField *headerEmailField;

/**
 *	弹出画板来写赠言
 *
 *	@param 	sender
 */
- (void)addMsgButtonPressed:(id)sender;
/**
 *	选择图片
 */
- (void)choosePhoto;

/**
 *	保存操作
 *
 *	@param 	sender 	
 */
- (void)saveBtnPressed:(id)sender;

/**
 *	将数据插入到数据库中
 */
- (void)insertDataToDataBase:(id)photoPath;

@end

@implementation CBPersonalDetailViewController

- (DDMenuController *)middleViewController
{
    if (_middleViewController == nil) {
        _middleViewController = [[DDMenuController alloc] init];
        _middleViewController.outlineAddAdvice = YES;
        
        CBViewController *mainViewController =[[CBViewController alloc] init];
        
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        CBDrawMenuViewController *menuVC  = [storyboard instantiateViewControllerWithIdentifier:@"CBDrawMenuViewController"];
        _middleViewController.leftViewController = menuVC;
        _middleViewController.rootViewController =mainNav;
           }
    return _middleViewController;
}

- (void)formatSaveBtn
{
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(saveBtnPressed:)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self formatSaveBtn];
    
    self.valueDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.detailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.detailTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.detailTableView];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.separatorColor = [UIColor clearColor];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PersonalMenu" ofType:@"plist"];
    self.personalDetailDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.dataSource = [[self.personalDetailDic allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg3.jpg"]];
    self.navigationItem.title = @"添加离线赠言";
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - UITableViewDelegate

- (UITextField *)addANewTextFieled:(int)tag aRect:(CGRect)rect aHolder:(NSString *)holder
{
    UITextField *textField = nil;
    
    textField = [[UITextField alloc] initWithFrame:rect];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor clearColor];
    
    textField.placeholder = holder;
    textField.font = [UIFont fontWithName:@"Arial" size:13.0f];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.textAlignment = UITextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.returnKeyType =UIReturnKeyDone;
    textField.tag = tag;
    
    return textField;
}
// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSuperView = [[UIView alloc] init];
    
    UIButton *headPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headPhotoBtn.frame = CGRectMake(
                                    kHeadPhotoBtnOffSetX,
                                    kHeadPhotoBtnOffSetY,
                                    kHeadPhotoBtnWidth,
                                    kHeadPhotoBtnHeight);
    
    [headPhotoBtn addTarget:self
                     action:@selector(choosePhoto)
           forControlEvents:UIControlEventTouchUpInside];
    
    [headPhotoBtn setImage:[UIImage imageNamed:kHeadPortraitImg]
                  forState:UIControlStateNormal];
    [headerSuperView addSubview:headPhotoBtn];    
//    return headerSuperView;
    
    UILabel * name_label = [[UILabel alloc]initWithFrame:CGRectMake(80, 24, 45, 21)];
    [name_label setText:@"姓名："];
    [name_label setFont:[UIFont boldSystemFontOfSize:14]];
    [name_label setBackgroundColor:[UIColor clearColor]];
    [headerSuperView addSubview:name_label];
    UITextField *nameField = [self addANewTextFieled:4001 aRect:CGRectMake(118, 26, 70, 21) aHolder:@"尊姓大名"];
    nameField.delegate = self;
    [headerSuperView addSubview:nameField];
    nameField.delegate = self;
    self.headerNameField = nameField;
    self.headerNameField.text = self.headerName;
    
    UILabel * sex_label = [[UILabel alloc]initWithFrame:CGRectMake(193, 24, 40, 21)];
    [sex_label setText:@"QQ："];
    [sex_label setFont:[UIFont systemFontOfSize:14]];
    [sex_label setBackgroundColor:[UIColor clearColor]];
    [headerSuperView addSubview:sex_label];
    
    UITextField *qqField = [self addANewTextFieled:4002 aRect:CGRectMake(223, 26, 80, 21) aHolder:@"5211314"];
    qqField.delegate = self;
    [headerSuperView addSubview:qqField];
    qqField.delegate = self;
    self.headerQQField = qqField;
    self.headerQQField.text = self.headerQQ;
    
    
    UILabel * addr_label = [[UILabel alloc]initWithFrame:CGRectMake(80, 56, 50, 21)];
    [addr_label setText:@"邮箱："];
    [addr_label setFont:[UIFont systemFontOfSize:14]];
    [addr_label setBackgroundColor:[UIColor clearColor]];    
    [headerSuperView addSubview:addr_label];
    
    UITextField *emailField = [self addANewTextFieled:4003 aRect:CGRectMake(118, 58, 180, 21) aHolder:@"ILY@2.com"];
    emailField.delegate = self;
    [headerSuperView addSubview:emailField];
    emailField.delegate = self;
    self.headerEmailField = emailField;
    self.headerEmailField.text = self.headerEmail;
    
    return headerSuperView;

}

// custom view for footer. will be adjusted to default or specified footer height
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerSuperView = [[UIView alloc] init];
    
    UIButton *addMsgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addMsgButton.frame = CGRectMake(
                                    kAddMsgButtonOffSetX,
                                    kAddMsgButtonOffSetY,
                                    kAddMsgButtonWidth,
                                    kAddMsgButtonHeight);
    
    addMsgButton.titleLabel.font=[UIFont boldSystemFontOfSize:kAddMsgTitleFontSize];
    [addMsgButton setBackgroundImage:[UIImage imageNamed:@"addMsgBlueBg.png"] forState:UIControlStateNormal];
//    [addMsgButton setTitle:kAddMsgButtonTitle forState:UIControlStateNormal];
    
    [addMsgButton addTarget:self
                     action:@selector(addMsgButtonPressed:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [footerSuperView addSubview:addMsgButton];
    
    return footerSuperView;
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
    CBPersonalDetailCell *cell = (CBPersonalDetailCell *)[tableView dequeueReusableCellWithIdentifier:reuserIdentifer];
    
    if (!cell) {
        cell = [[CBPersonalDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifer];
    }
    
    int row = [indexPath row];
    NSString *key =[[self.personalDetailDic allKeys] objectAtIndex:row];

    NSString *menuLableText = [NSString stringWithFormat:@"%@ :",[self.personalDetailDic objectForKey:key]];
    cell.myImageView = nil;
    cell.myLable.text = menuLableText;
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //以plist表中的键为键，myTextView中的值为值存到数据组里
//    NSString *key =[[self.personalDetailDic allKeys] objectAtIndex:row];
    NSString * textViewValue = (NSString *)[self.valueDic objectForKey:key];
    if (textViewValue) {
        cell.myTextView.text = textViewValue;
    }
    else
    {
        cell.myTextView.text = nil;
    }
    cell.myTextView.delegate =self;

    
//    NSString *menuLableText = [NSString stringWithFormat:@"%@ :",[self.dataSource objectAtIndex:row]];
//    cell.myImageView = nil;
//    cell.myLable.text = menuLableText;
//    //无色
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    //以plist表中的键为键，myTextView中的值为值存到数据组里
//    NSString *key =[[self.personalDetailDic allKeys] objectAtIndex:row];
//    NSString * textViewValue = (NSString *)[self.valueDic objectForKey:key];
//    if (textViewValue) {
//        cell.myTextView.text = textViewValue;
//    }
//    else
//    {
//        cell.myTextView.text = nil;
//    }
//    cell.myTextView.delegate =self;
    return cell;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.firsRespondTextView = textView;
    float superOrignY = textView.superview.frame.origin.y;
    float offset;   
    offset = superOrignY -150;
    if (superOrignY > 187) {
        [self.detailTableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CBPersonalDetailCell *cell = (CBPersonalDetailCell *) textView.superview;
    NSIndexPath *indexpath  = [self.detailTableView indexPathForCell: cell];
    NSString *key =[[self.personalDetailDic allKeys] objectAtIndex:indexpath.row];
    [self.valueDic setObject:textView.text forKey:key];
//    NSLog(@"section:%d,row:%d,text:%@ key: %@",indexpath.section,indexpath.row,textView.text,key);
}

//收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if ([text isEqualToString:@"\n"])
    {
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        [self.detailTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        return NO;
    }else {
        if ([textView.text length] < 140) {//判断字符个数
            return YES;
        }
    }
    [self.detailTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    return NO;
}

#pragma mark - self methods
/**
 *	选择图片
 */
- (void)choosePhoto
{
    
}

- (void)addMsgButtonPressed:(id)sender
{
//    self.middleViewController.imageToSave = self.imageToSave;
    [self presentModalViewController:self.middleViewController animated:YES];
}

/**
 *	将图片保存到0/images/日期文件夹中
 *
 *	@param 	aimage 	一张图片（此处没有用，用的是属性中的图片）
 *
 *	@return	路径名
 */
- (NSString *)savePhotoToFolder:(UIImage *)aimage

{
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    int userId = [[CBCurrentUser currentUser] user_id];    
    NSString *photoPath = [NSString stringWithFormat:@"%d/images/%@",userId,date];
    
    if (self.imageToSave != nil) {
        [[ImageStore defaultImageStore] setImage:self.imageToSave forKey:photoPath];
    }
    
    return photoPath;
}

- (void)saveBtnPressed:(id)sender
{
    self.imageToSave = self.middleViewController.imageToSave;
//    NSLog(@"======%@",self.imageToSave);
    
    NSString * photoPath = [self savePhotoToFolder:nil];    
    [self insertDataToDataBase:photoPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertDataToDataBase:(id)photoPath
{
    NSMutableDictionary *aDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    int userId = [[CBCurrentUser currentUser] user_id];
    NSArray *keyArray = [self.personalDetailDic allKeys];
    NSString *userIdKey = @"user_id";
    [aDic setObject:[NSNumber numberWithInt:userId] forKey:userIdKey];
    NSString * groupIdKey=@"outline_group_id";
    
    int groupId = [[CBDatabase sharedInstance]getGroupIdByUserId:userId andGroupName:@"好友"];
    
    [aDic setObject:[NSNumber numberWithInt:groupId] forKey:groupIdKey];
    NSString * photoPathKey = @"advice_add";
    [aDic setObject:photoPath forKey:photoPathKey];
    
    
    //    UITextField * nameField = (UITextField *)[[self.detailTableView headerViewForSection:0] viewWithTag:4001];
    NSString *nameText = self.headerName;
    if (!nameText) {
        nameText = kDefualUserName;
    }
    NSString * name = @"name";
    [aDic setObject:nameText forKey:name];
    
    //    UITextField * qqField = (UITextField *)[[self.detailTableView headerViewForSection:0] viewWithTag:4002];
    NSString *qqText = self.headerQQ;
    NSString * qq = @"QQ";
    [aDic setObject:qqText forKey:qq];
    
    //    UITextField * emailField = (UITextField *)[[self.detailTableView headerViewForSection:0] viewWithTag:4003];
    NSString *emailText = self.headerEmail;
    [aDic setObject:emailText forKey:@"email"];
    
//    DLog(@"adic=%@",aDic);
    
    for (NSString *key in keyArray) {
        id value = [self.valueDic objectForKey:key];
        if (value) {
            
            [aDic setObject:value forKey:key];
            
            if ([key isEqualToString:@"sex"]) {
                if ([value isEqualToString:@"男"]) {
                    [aDic setObject:@"0" forKey:key];
                }else
                    [aDic setObject:@"1" forKey:key];
            }
            
        }
    }
    //向数据库中OutLineUserAdvice表中插入数据
    NSArray * insertData = [[NSArray alloc]initWithObjects:aDic, nil];
    BOOL res = [[CBDatabase sharedInstance] insertData:insertData forTable:@"OutLineUserAdvice"];
    if(!res)
    {
        NSLog(@"insert outlineAdvice failed");
    }
    else
    {
        NSLog(@"insert outlineAdvice succeed");
    }

}

#pragma mark - UITextFiled Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 4001:
            self.headerName = textField.text;
            break;
        case 4002:
            self.headerQQ = textField.text;
            break;
        case 4003:
            self.headerEmail = textField.text;
            break;
        default:
            break;
    }
}

@end

