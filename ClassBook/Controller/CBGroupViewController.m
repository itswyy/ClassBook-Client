//
//  CBViewController.m
//  GMGridDemoTwo
//
//  Created by Admin on 13-3-6.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import "CBGroupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "CBUser.h"
#import "GMGridViewLayoutStrategies.h"
#import "CBDatabase.h"
#import "DDMenuController.h"
#import "CBDrawMenuViewController.h"
#import "CBViewController.h"
#import "iCarouselViewController.h"
#import "CBCurrentUser.h"
#import "CBPersonViewController.h"
#import "CBBlackboardViewController.h"
#import "CBCommonFunction.h"
#import "NSDictionary+ObjectToDict.h"
#import "NSObject+DictToObject.h"

#pragma mark - ViewController (privates methods)

@interface CBGroupViewController () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray * _data;
}

- (void)removeItem;
- (void)jumpToBlackBoard;

@end

@implementation CBGroupViewController

@synthesize group_id = _group_id;
@synthesize personAr = _personAr;

#pragma mark - ViewController implementation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


#pragma mark - controller events

- (void)loadView
{
    [super loadView];
    
    self.title = @"学生时代";
    
    DLog(@"%d",_group_id);
    
    //数据源
    _data = [[NSMutableArray alloc]initWithCapacity:0];
    
    if (_group_id == 9995 && [CBCurrentUser currentUser].user_id == 0)
    {
        //离线赠言
        _personAr = [[CBDatabase sharedInstance]getUsersByOutLineUserId:0];
        
        for (NSDictionary * dic in _personAr)
        {
             
            NSString * headImage = [dic objectForKey:@"head_portrait"];
            if ([headImage isEqualToString:@"nohead"]) {
                if ([dic objectForKey:@"sex"] == [NSNull null] || [[dic objectForKey:@"sex"] intValue] == 1 || [dic objectForKey:@"sex"] == nil) {
                    headImage = ISDEFAULT_HEAD_MALE;
                }
                else
                {
                    headImage = ISDEFAULT_HEAD_FEMALE;
                }
            }

            [_data addObject:[[CBUser alloc]initWithDictionary:dic]];

        }
    }
    else
    {   //在线的
        _personAr = [[CBDatabase sharedInstance]getUsersByGroupId:_group_id]; //所有的用户ID
        
        for (NSDictionary * dic in _personAr)
        {
            NSDictionary * userInfo = [[CBDatabase sharedInstance]getUserInfoByUserID:[[dic objectForKey:@"user_id"]integerValue]];
            
            NSString * headImage = [userInfo objectForKey:@"head_portrait"];
            if ([headImage isEqualToString:@"nohead"]) {
                if ([dic objectForKey:@"sex"] == [NSNull null] || [[dic objectForKey:@"sex"] intValue] == 1 || [dic objectForKey:@"sex"] == nil) {
                    headImage = ISDEFAULT_HEAD_MALE;
                }
                else
                {
                    headImage = ISDEFAULT_HEAD_FEMALE;
                }
            }
            
            [_data addObject:[[CBUser alloc]initWithDictionary:userInfo]];
            
        }
        
        //离线添加的用户
        NSMutableArray * ar = [[CBDatabase sharedInstance]getUsersByOutLineGroupId:_group_id];
        
        for (NSDictionary * dic in ar)
        {
            
            NSString * headImage = [dic objectForKey:@"head_portrait"];
            if ([headImage isEqualToString:@"nohead"]) {
                if ([dic objectForKey:@"sex"] == [NSNull null] || [[dic objectForKey:@"sex"] intValue] == 1 || [dic objectForKey:@"sex"] == nil) {
                    headImage = ISDEFAULT_HEAD_MALE;
                }
                else
                {
                    headImage = ISDEFAULT_HEAD_FEMALE;
                }
            }
            
            [_data addObject:[[CBUser alloc]initWithDictionary:dic]];
        }
        
        [_personAr addObjectsFromArray:ar];
    }


    
    self.view.backgroundColor = [UIColor whiteColor];

    NSMutableArray *msgesFromDB = [[CBDatabase sharedInstance] getMessagesByGroupId:self.group_id];
    UIImageView * blackboard = nil;
    if ([msgesFromDB count])
    {//黑白有内容
        blackboard =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"u96.jpg"]];
    }
    else
    {
        blackboard =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"u9.jpg"]];
    }
  
    msgesFromDB = nil;
    blackboard.frame = CGRectMake(0, 0, 320, 175);
    blackboard.userInteractionEnabled = YES;
    
    //add gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToBlackBoard)];
    [blackboard addGestureRecognizer:tapGesture];
    
    [self.view addSubview:blackboard];
    
    //****************/
    //*  GMGridView
    //****************/
    CGRect rect = CGRectMake(0, 166, 320, 310);
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:rect];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    gmGridView.backgroundColor = [UIColor clearColor];
    gmGridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodBoard.png"]];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontalPagedLTR];
    _gmGridView.style = GMGridViewStylePush;
    _gmGridView.itemSpacing = 10;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(0, 35, 0, 35);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    [_gmGridView setShowsHorizontalScrollIndicator:NO];
    [_gmGridView setShowsVerticalScrollIndicator:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    //按钮
//    UIButton * right = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    right.frame = CGRectMake(0, 0, 36, 30);
//    
//    [right setTitle:@"相册" forState:UIControlStateNormal];
//    right.titleLabel.font = [UIFont systemFontOfSize: 13.0];
//    right.titleLabel.shadowColor = [UIColor blackColor];
//    right.titleLabel.shadowOffset = CGSizeMake(0.0, -0.618);
//    [right addTarget:self action:@selector(gotoCarouselView) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
     UIBarButtonItem *Button = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(gotoCarouselView)];
    [Button setTintColor:[UIColor purpleColor]];
    self.navigationItem.rightBarButtonItem = Button;
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - 进入相册页面

- (void)gotoCarouselView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    iCarouselViewController *iCarousel  = [storyboard instantiateViewControllerWithIdentifier:@"iCarouselViewController"];
    
    iCarousel.groupId = [NSNumber numberWithInt:_group_id];
    
//    [self.navigationController pushViewController:iCarousel animated:YES];
    [self presentViewController:iCarousel animated:YES completion:nil];
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - orientation management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //只有正立的方向
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}


#pragma mark - GMGridViewDataSource

/**
	<#Description#>
	@param gridView <#gridView description#>
	@returns 返回这个分组中同学的个数
 */
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_data count];
}

/**
	每个同学的头像大小
	@param gridView <#gridView description#>
	@param orientation <#orientation description#>
	@returns <#return value description#>
 */
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return CGSizeMake(75, 70);
}

/**
	绘制每个头像
	@param gridView <#gridView description#>
	@param index <#index description#>
	@returns <#return value description#>
 */
- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:UIInterfaceOrientationPortrait];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(5, 5);
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.layer.shadowRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage * image = [UIImage imageNamed:[(CBUser *)[_data objectAtIndex:index] head_portrait]];
    if (!image) {
        if([(CBUser *)[_data objectAtIndex:index] sex])
        {
            image = [UIImage imageNamed:ISDEFAULT_HEAD_MALE];
        }
        else
        {
            image = [UIImage imageNamed:ISDEFAULT_HEAD_FEMALE];
        }
    }
    UIImageView * view = [[UIImageView alloc]initWithImage:image];

    view.frame = CGRectMake(3, 0, 70, 70);
    [cell.contentView addSubview:view];
    
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    [_data removeObjectAtIndex:index];
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    if (index == [_data count] - 1) {
        return NO;
    }
    return YES;
}

#pragma mark - GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    
    //TODO: 响应点击事件
    
    NSLog(@"Did tap at index %d", position);
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CBPersonViewController *person = [storyBoard instantiateViewControllerWithIdentifier:@"PersonView"];
    
    person.user_id = [(CBUser *)[_data objectAtIndex:position] user_id];
    
    if ([CBCurrentUser currentUser].user_id == 0)//离线
    {
        person.userInfoDic = [_personAr objectAtIndex:position];
    } else {
        person.userInfoDic = [NSDictionary dictionaryWithNSObject:[_data objectAtIndex:position]];
    }
    
   // if ([CBCurrentUser currentUser].user_id == 0)
   // {
    
    
        //person.userInfoDic = [_personAr objectAtIndex:position];
   // }
   // else
   // {
   //     person.userInfoDic = [[CBDatabase sharedInstance]getUserInfoByUserID:[[[_personAr objectAtIndex:position] objectForKey:@"user_id"]integerValue]];
   // }
    
    [self.navigationController pushViewController:person animated:YES];

}



#pragma mark - GMGridViewSortingDelegate

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         //cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    if (index == [_data count] - 1) {
        return NO;
    }
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    if (newIndex == [_data count]-1) {
        // [gridView swapObjectAtIndex:[_data count]-1 withObjectAtIndex:[_data count]-2 animated:YES];
        return;
    }
    NSObject *object = [_data objectAtIndex:oldIndex];
    [_data removeObject:object];
    [_data insertObject:object atIndex:newIndex];
    
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_data exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}


#pragma mark - DraggableGridViewTransformingDelegate


- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    //TODO:未知方法
    return CGSizeMake(310, 310);
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index inInterfaceOrientation:UIInterfaceOrientationPortrait];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
    label.font = [UIFont boldSystemFontOfSize:15];
    
    
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(UIView *)cell
{
        //TODO:未知方法
}

#pragma mark - private methods


/**
	删除某一个同学
 */
- (void)removeItem
{
    // Example: removing last one item
    if ([_data count] > 0)
    {
        NSInteger index = [_data count] - 2;
        
        [_gmGridView removeObjectAtIndex:index animated:YES];
        [_data removeObjectAtIndex:index];
    }
}

- (void)jumpToBlackBoard
{
    UIStoryboard *blackboardSB = [UIStoryboard storyboardWithName:@"BlackboardStoryboard" bundle:[NSBundle mainBundle]];
    CBBlackboardViewController *boardController = (CBBlackboardViewController *)[blackboardSB instantiateInitialViewController];
    boardController.groupid = self.group_id;
    [self presentModalViewController:boardController animated:NO];
}

@end
