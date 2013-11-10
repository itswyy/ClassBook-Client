//
//  CBUserListViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBUserListViewController.h"
#import "CBPersonViewController.h"
#import "CBEntities.h"
#import "CBProgressHUD.h"
#import "CBDatabase.h"

@interface CBUserListViewController ()

@property (strong, nonatomic) CBProgressHUD *HUD;

@end

@implementation CBUserListViewController

@synthesize classMatesArr = _classMatesArr;
@synthesize outLineClassMatesArr = _outLineClassMatesArr;
@synthesize personViewController = _personViewController;
@synthesize HUD = _HUD;

#pragma mark - Lazy Initialization

- (CBPersonViewController *)personViewController
{
    if (nil == _personViewController) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        _personViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PersonView"];
    }
    
    return _personViewController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //定制导航栏后退按钮
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leaveThisController:)];
    self.navigationItem.leftBarButtonItem = backBar;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
    
    _HUD = [[CBProgressHUD alloc]initWithView:self.tableView];

//    [self.HUD showAnimated:YES whileExecutingBlock:^{
//        self.HUD.animationType = MBProgressHUDAnimationFade;
//        self.HUD.labelText = @"请稍等...";
//        self.HUD.mode = MBProgressHUDModeIndeterminate;
//        self.HUD.margin = 20.f;
//        self.HUD.yOffset = 0;
//        self.HUD.labelFont = [UIFont boldSystemFontOfSize:16];
//        
//        self.classMatesArr = [[CBDatabase sharedInstance]getAllRelatedOnlineUserInfoByUserId:[CBCurrentUser currentUser].user_id];
//        self.outLineClassMatesArr = [[CBDatabase sharedInstance]getAllRelatedOutlineUserInfoByUserId:[CBCurrentUser currentUser].user_id];
//    } completionBlock:^{
//        [self.tableView reloadData];
//    }];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        self.HUD.animationType = MBProgressHUDAnimationFade;
        self.HUD.labelText = @"请稍等...";
        self.HUD.mode = MBProgressHUDModeIndeterminate;
        self.HUD.margin = 20.f;
        self.HUD.yOffset = 0;
        self.HUD.labelFont = [UIFont boldSystemFontOfSize:16];
        
        self.classMatesArr = [[CBDatabase sharedInstance]getAllRelatedOnlineUserInfoByUserId:[CBCurrentUser currentUser].user_id];
        self.outLineClassMatesArr = [[CBDatabase sharedInstance]getAllRelatedOutlineUserInfoByUserId:[CBCurrentUser currentUser].user_id];
    } completionBlock:^{
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Self Private Methods

- (void)leaveThisController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if ([_outLineClassMatesArr count] && [_classMatesArr count]) {
//        return 2;
//    }
//    else if ([_outLineClassMatesArr count] || [_classMatesArr count]) {
//        return 1;
//    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (1 == section) {
        return [self.outLineClassMatesArr count];
    }
    return [self.classMatesArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClassMatesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (1 == section)
    {
        id info = [self.outLineClassMatesArr objectAtIndex:row];
        cell.textLabel.text = [info valueForKey:@"name"];
        if ([info objectForKey:@"sex"] == [NSNull null] || [[info objectForKey:@"sex"] intValue] == 1 || [info objectForKey:@"sex"] == nil) {
            cell.imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_MALE];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_FEMALE];
        }
    }
    else
    {
        id info = [self.classMatesArr objectAtIndex:row];
        cell.textLabel.text = [info valueForKey:@"name"];
        if ([info objectForKey:@"sex"] == [NSNull null] || [[info objectForKey:@"sex"] intValue] == 1 || [info objectForKey:@"sex"] == nil) {
            cell.imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_MALE];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_FEMALE];
        }
    }
    

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

//TODO:添加拼音索引
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return @"在线添加好友";
    }
    return @"离线添加好友";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    int user_id;
    if (1 == section)
    {
        user_id = [[[self.outLineClassMatesArr objectAtIndex:row] valueForKey:@"outline_user_id"]intValue];
        self.personViewController.user_id = user_id;
        self.personViewController.userInfoDic = [[CBDatabase sharedInstance]getOutLineUserInfoByUserID:user_id];
    }
    else
    {
        user_id = [[[self.classMatesArr objectAtIndex:row] valueForKey:@"user_id"]intValue];
        self.personViewController.user_id = user_id;
        self.personViewController.userInfoDic = [[CBDatabase sharedInstance]getUserInfoByUserID:user_id];
    }
    

    [self.navigationController pushViewController:self.personViewController animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

@end
