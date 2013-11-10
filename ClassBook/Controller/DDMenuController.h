//------------------------------------------------------------------------------
// Copyright (c)2013, FireFly Software
// Filename: DDMenuController.h
// Description: 菜单控制器，控制左边、中间的视图
// Author: Li Rui
// Date: 27/2/2013
// Version: 1.0
// Revise: Li Rui
//------------------------------------------------------------------------------

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CBViewController.h"

typedef enum
{
    DDMenuPanDirectionLeft = 0,
    DDMenuPanDirectionRight,
} DDMenuPanDirection;

typedef enum
{
    DDMenuPanCompletionLeft = 0,
    DDMenuPanCompletionRight,
    DDMenuPanCompletionRoot,
} DDMenuPanCompletion;

/*
 @class        DDMenuController
 @superclass   UIViewController
 @abstract     the controller of leftViewController and middleViewController
 */
@interface DDMenuController : UIViewController
<UIGestureRecognizerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
{ 
    CGFloat _panOriginX;//拖动时原点X坐标
    CGPoint _panVelocity;//滑动速率
    DDMenuPanDirection _panDirection;//拖动方向
    
    struct
    {
        unsigned int showingLeftView:1;
        unsigned int showingRightView:1;
        unsigned int canShowRight:1;
        unsigned int canShowLeft:1;
    } _menuFlags;//菜单状态
}

- (id)initWithRootViewController:(UIViewController*)controller;

@property(nonatomic,strong) UIViewController *leftViewController;
@property(nonatomic,strong) UIViewController *rightViewController;
@property(nonatomic,strong) UIViewController *rootViewController;
@property (nonatomic , strong) CBViewController *mainController;
@property (nonatomic , strong) UIImage *imageToShow;
@property(nonatomic,readonly) UITapGestureRecognizer *tap;
@property(nonatomic,readonly) UIPanGestureRecognizer *pan;
@property (nonatomic, retain) UIImage *imageToSave;
@property (assign, nonatomic) BOOL outlineAddAdvice;
@property (nonatomic,assign) int userid2;

//used to push a new controller on the stack
- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated;  
- (void)showRootController:(BOOL)animated;   //reset to "home" view controller
- (void)showRightController:(BOOL)animated;  //show right
- (void)showLeftController:(BOOL)animated;   //show left

@end