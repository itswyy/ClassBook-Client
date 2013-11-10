//
//  CBTabBarController.m
//  ClassBook
//
//  Created by Parker on 5/3/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "QuadCurveMenuDelegate.h"
#import "CBTabBarController.h"
#import "QuadCurveMenuDelegate.h"
#import "QuadCurveDefaultMenuItemFactory.h"
#import "QuadCurveRadialDirector.h"
#import "CBMenuItemDataSource.h"
#import "CBCenterMenuOperation.h"

@interface CBTabBarController ()
<QuadCurveMenuDelegate, UITabBarControllerDelegate>

@property (nonatomic ,strong) QuadCurveMenu *menu;

@property (strong, nonatomic) CBCenterMenuOperation *menuOperation;

/**
 *	添加菜单视图
 */
- (void)addMenu;

@end

@implementation CBTabBarController
@synthesize menu = _menu;
@synthesize menuOperation = _menuOperation;

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
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tab_center_btn.png"] highlightImage:[UIImage imageNamed:@"tab_center_btn_pressed.png"]];
    self.delegate = self;
    
    _menuOperation = [[CBCenterMenuOperation alloc]initWithViewController:self];
    
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
    //定制返回按钮
    self.navigationItem.backBarButtonItem.tintColor = [UIColor purpleColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *	添加菜单视图
 */
- (void)addMenu

{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    QuadCurveDefaultMenuItemFactory *mainFactory = [[QuadCurveDefaultMenuItemFactory alloc]
                                                    initWithImage:nil highlightImage:nil];
    QuadCurveDefaultMenuItemFactory *menuItemFactory = [[QuadCurveDefaultMenuItemFactory alloc] initWithImage:storyMenuItemImage highlightImage:storyMenuItemImagePressed];
    QuadCurveRadialDirector *menuDirector =[[QuadCurveRadialDirector alloc] initWithMenuWholeAngle:M_PI*3/4 andInitialRotation:-0.9f];
    menuDirector.nearRadius = 100.0f;
    menuDirector.endRadius = 100.0f;
    menuDirector.farRadius = 120.0f;
    
    CBMenuItemDataSource *dataSource = [[CBMenuItemDataSource alloc] init];
    
   
//TODO: itswyy 可能需要改动 弹出小菜单的位置
    
    CGPoint center;
//    center.x = center.x;
    CGRect f = self.tabBar.frame;
    center.x = 160.0f;
    if (self.navigationController.navigationBarHidden) {
        center.y = f.origin.y;
    }
    else
    {
//        center.y = f.origin.y-44;
        center.y = f.origin.y;
    }
    CGRect  frame = CGRectMake(0,0,320 ,center.y );
    
    //NSLog(@"%f,%f",f.origin.x,f.origin.y);
    QuadCurveMenu *menu = [[QuadCurveMenu alloc]
                           initWithFrame:frame
                           centerPoint:center
                           dataSource:dataSource
                           mainMenuFactory:mainFactory
                           menuItemFactory:menuItemFactory
                           menuDirector:menuDirector];
    menu.tag = 1008;
    [menu setDelegate:self];
    self.menu = menu;
    self.menu.expanding = NO;
    //[self.view addSubview:self.menu];
}

//
/**
 *	Create a custom UIButton and add it to the center of our tab bar
 *
 *	@param 	buttonImage 	按钮的图片
 *	@param 	highlightImage 	点击后的图片
 */
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage

{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    button.tag = 1009;
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }

    //添加菜单视图
    
    [self addMenu];
    //给中间按钮添加事件
    [button addTarget:self action:@selector(mainMenuItemTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];   
   
}

/**
 *	中间键按下事件，当点击的时候再加上menu视图
 */
- (void)mainMenuItemTapped

{
    [self.view addSubview:self.menu];
    [self.menu mainMenuItemTapped];
}

#pragma mark- UITabBarController Delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0)
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.menu closeMenu];
}

#pragma mark- QuadCurveMenu Delegate
- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenu:(QuadCurveMenuItem *)mainMenuItem
{
    NSLog(@"mainMenuItem taped ,tag = %d",mainMenuItem.tag-1000);
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenu:(QuadCurveMenuItem *)mainMenuItem
{
    
}

//- (BOOL)quadCurveMenuShouldExpand:(QuadCurveMenu *)menu
//{
//    return YES;
//}
//- (BOOL)quadCurveMenuShouldClose:(QuadCurveMenu *)menu
//{
//    return YES;
//}

- (void)quadCurveMenuWillExpand:(QuadCurveMenu *)menu
{
    
}
- (void)quadCurveMenuDidExpand:(QuadCurveMenu *)menu
{
    
}

- (void)quadCurveMenuWillClose:(QuadCurveMenu *)menu
{
    
}
- (void)quadCurveMenuDidClose:(QuadCurveMenu *)menu
{
    
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didTapMenuItem:(QuadCurveMenuItem *)menuItem
{
    NSLog(@"MenuItem taped ,tag = %d",menuItem.tag-1000);
    [self.menuOperation centerMenuTappedAtIndex:menuItem.tag-1000];
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didLongPressMenuItem:(QuadCurveMenuItem *)menuItem
{
    
}
@end
