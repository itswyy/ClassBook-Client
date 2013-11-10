//------------------------------------------------------------------------------
// Copyright (c)2013, FireFly Software
// Filename: DDMenuController.m
// Description: 订制菜单栏的单元格
// Author: Li Rui
// Date: 1/3/2013
// Version: 1.0
// Revise: Li Rui
//------------------------------------------------------------------------------

#import <QuartzCore/QuartzCore.h>
#import "DDMenuController.h"
#import "CBDrawMenuViewController.h"
#import "CBViewController.h"
#import "ACEDrawingView.h"

static float kMenuFullWidth = 320.0f;
static float kMenuDisplayedWidth = 280.0f;
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
static float kMenuBounceOffset = 10.0f;
static float kMenuBounceDuration = .3f;
static float kMenuSlideDuration = .3f;
#define kDeviceHeight [[UIScreen mainScreen]bounds].size.height//当前设备的高
#define kDeviceWidth [[UIScreen mainScreen]bounds].size.width//当前设备的宽
static NSString *kNavBarItemImage = @"nav_menu_button.png";
static NSString *kAnimationKeyPath = @"position";
static NSString *kKeyOfTimingFunctions = @"timingFunctions";
static NSString *kKeyOfValues = @"values";
static NSString *kKeyOfKeyTimes = @"keyTimes";
const static int kMenuButtonTag =1111;
const static int kNavBarLeftBtnTag = 2002;
const static int kNotifyviewTag =2003;
const static float kLowestVelocityX = 800;
const static float kPrimaryDuration = 1.0f;
const static float kShadowOpacityValue = 0.8f;
const static float kShadowOpacityNone = 0.0f;
const static float kCornerRadius = 8.0f;
const static float kShadowRadius = 8.0f;
static float kShadowOffsetX = -6.0f;
static float kShadowOffsetY = 1.0f;
static float kZero = 0.0f;
static float kNavBarButtonX = 0;
static float kNavBarButtonY = 0;
static float kNavBarButtonWidth = 40;
static float kNavBarButtonHeight = 30;
static float kShowRootAnimationDuration = .1f;
//static float kShowRightAnimationDuration = .3f;
static int kArrCountForBounceTrue = 3;
static int kArrCountForBounceFalse = 2;
const static int kRedoBtnTag = 3001;
const static int kUndoBtnTag = 3002;

@interface DDMenuController (Internal)
@property (copy, nonatomic) NSString *textToShow;

- (void)showShadow:(BOOL)val;

/*
 @method     formatNavBarLeftItem
 @abstract   UIBarButtonItem 定制
 @result     UIBarButtonItem*
 */
- (UIBarButtonItem *)formatNavBarLeftItem;

/*
 @method     showLeftOrRightView：
 @abstract   根据_root的位置，确定当点击左上角的navgationButton时应进行何种处理
 @result     void
 */
- (void)showLeftOrRightView;

/*
 @method     panBegin:
 @abstract   拖动手势开始的时候
 @result     void
 */
- (void)panBegin:(UIPanGestureRecognizer*)gesture;

/*
 @method     panChange：
 @abstract   拖动手势改变的过程中
 @result     void
 */
- (void)panChange:(UIPanGestureRecognizer*)gesture;

/*
 @method     panEnd：
 @abstract   拖动手势结束的时候
 @result     void
 */
- (void)panEnd:(UIPanGestureRecognizer*)gesture;

/*
 @method     panChangeTowardsToLeft: withOldFrame:
 @abstract   向左拖动时的处理事件（第一次进入）
 @result     CGRcet
 */
- (CGRect)panChangeTowardsToLeft:(UIPanGestureRecognizer*)gesture
    withOldFrame:(CGRect)aFrame;

/*
 @method     panChangeTowardsToRight: withOldFrame:
 @abstract   向右拖动时的处理事件（第一次进入）
 @result     CGRect
 */
- (CGRect)panChangeTowardsToRight:(UIPanGestureRecognizer*)gesture
    withOldFrame:(CGRect)aFrame;

/**
 *	将当前界面形成为一个图片
 */
- (void)getAdviceImage;

- (void)undoAction;
- (void)redoAction;
- (void)clearAction;
- (void)backBtnPressed;
- (void)sendBtnPressed;
- (void)saveBtnPressed;
/**
 *	更新navigationBar上redo 和 undo按钮状态
 */
- (void)updateButtonStates;

/**
 *	向服务器上传图片
 */
- (void) imageUpload:(UIImage *) image;


@end

@implementation DDMenuController

//@synthesize delegate;

@synthesize leftViewController=_left;
@synthesize rightViewController=_right;
@synthesize rootViewController=_root;

@synthesize tap=_tap;
@synthesize pan=_pan;
@synthesize mainController = _mainController;

/*
 @method     initWithRootViewController：
 @abstract   init the rootViewController
 @result     id
 */
- (id)initWithRootViewController:(UIViewController *)controller
{
    if ((self = [super init]))
    {
        _root = controller;
    }
    return self;
}
- (id)init
{
    if ((self = [super init])) {
     
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)formatLeftToolBar
{
    //    //左边视图
    UIBarButtonItem *showLeftNavBarBtn = [self formatNavBarLeftItem];
       
    //    self.navigationItem.leftBarButtonItem = showLeftNavBarBtn;
    UIToolbar* leftToolBar = [[UIToolbar alloc]
                              initWithFrame:CGRectMake(0, 0, 230, 45)];
    UIToolbar* rightToolBar = [[UIToolbar alloc]
                              initWithFrame:CGRectMake(230, 0, 100, 45)];
    
    //设置背景色
    [leftToolBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE]  forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [rightToolBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE]  forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSMutableArray* leftBarButtons = [[NSMutableArray alloc] initWithCapacity:4];
    [leftBarButtons addObject:showLeftNavBarBtn];
    NSMutableArray *rightBarButtons = [[NSMutableArray alloc] initWithCapacity:2];

     UIBarButtonItem *undo = [[UIBarButtonItem alloc] initWithTitle:@"Undo" style:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undo.tintColor = [UIColor purpleColor];
    undo.style = UIBarButtonItemStyleBordered;
    undo.tag = kUndoBtnTag;
    undo.width = 40.0;
    [leftBarButtons addObject:undo];
    
    UIBarButtonItem *redo = [[UIBarButtonItem alloc] initWithTitle:@"Redo" style:UIBarButtonSystemItemRedo target:self action:@selector(redoAction)];;
    redo.style = UIBarButtonItemStyleBordered;
    redo.tintColor = [UIColor purpleColor];
    redo.tag = kRedoBtnTag;
    redo.width = 40.0;
    [leftBarButtons addObject:redo];

    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonSystemItemFastForward target:self action:@selector(clearAction)];
    clear.width =40.0;
    clear.tintColor = [UIColor purpleColor];
    [leftBarButtons addObject:clear];
    
//    
   
    
    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonSystemItemFastForward target:self action:@selector(sendBtnPressed)];
    sendBtn.width = 40.0;
    sendBtn.tintColor = [UIColor purpleColor];
        
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed)];
    saveBtn.width = 40.0;
    saveBtn.tintColor = [UIColor purpleColor];
    if (self.outlineAddAdvice) {
        [rightBarButtons addObject:saveBtn];
    }
    else
    {
        [rightBarButtons addObject:sendBtn];
    }
     UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemFastForward target:self action:@selector(backBtnPressed)];
    backBtn.width = 40.0;
    backBtn.tintColor = [UIColor purpleColor];
    [rightBarButtons addObject:backBtn];
    // put the buttons in the toolbar and release them
    
    [leftToolBar setItems:leftBarButtons animated:NO];
    [rightToolBar setItems:rightBarButtons animated:NO];
    
    // place the toolbar into the navigation bar
    UINavigationController *topController = nil;
    UINavigationController *navController = (UINavigationController*)_root;
    if ([[navController viewControllers] count] > 0)
    {
        topController = [[navController viewControllers] objectAtIndex:0];
    }
    topController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:leftToolBar];
    topController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolBar];
}

/*
 @method     viewDidUnload
 @abstract   Called after the controller’s view is loaded into memory.
 @result     void
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationController *rootNav = (UINavigationController *)self.rootViewController;
    self.mainController = (CBViewController*)[rootNav topViewController];
    
    CBDrawMenuViewController *menuVC =(CBDrawMenuViewController *)self.leftViewController;
    menuVC.pickerDelegate = self;
    
//    //添加_tap手势
//    if (!_tap)
//    {
//         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//            initWithTarget:self action:@selector(tap:)];
//         tap.delegate = (id<UIGestureRecognizerDelegate>)self;
//         [self.view addGestureRecognizer:tap];//将tap手势加在left/root/right上
//         [tap setEnabled:NO];//开始的时候设置不响应_tap手势
//         _tap = tap;
//    }
    //设置导航条
    [rootNav.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
//    if (self.imageToSave) {
//        UIImageView *backImageView = [[UIImageView alloc] initWithImage:self.imageToSave];
//        [self.mainController.view insertSubview:backImageView belowSubview:self.mainController.view];
//    }    
}

/*
 @method     viewDidUnload
 @abstract   Called when the controller’s view is released from memory.
 @result     void
 */
- (void)viewDidUnload
{
    _tap = nil;
    _pan = nil;
    _root = nil;
    _left =  nil;
    _right = nil;
    [super viewDidUnload];
}

/*
 @method     shouldAutorotateToInterfaceOrientation:
 @abstract   Returns a Boolean value indicating whether the view controller 
             supports the specified orientation
 @result     void
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

//目前暂且用不到
- (void)willRotateToInterfaceOrientation:
    (UIInterfaceOrientation)toInterfaceOrientation
    duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation
        duration:duration];
    
    if (_root)
    {
        [_root willRotateToInterfaceOrientation:toInterfaceOrientation
            duration:duration];
        UIView *view = _root.view;
        
        if (_menuFlags.showingRightView)
        {
            view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        }
        else if (_menuFlags.showingLeftView)
        {
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        }
        else
        {
            view.autoresizingMask = UIViewAutoresizingFlexibleHeight |
                UIViewAutoresizingFlexibleWidth;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:
    (UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (_root)
    {
        [_root didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        
        CGRect frame = self.view.bounds;
        if (_menuFlags.showingLeftView)
        {
            frame.origin.x = frame.size.width - kMenuOverlayWidth;
        }
        else if (_menuFlags.showingRightView)
        {
            frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
        }
        _root.view.frame = frame;
        _root.view.autoresizingMask = self.view.autoresizingMask;
        
        [self showShadow:(_root.view.layer.shadowOpacity != kZero)];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:
    (UIInterfaceOrientation)toInterfaceOrientation
    duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
        duration:duration];
    if (_root)
    {
        [_root willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
            duration:duration];
    }
}


#pragma mark - GestureRecognizers
/*
 @method     pan:
 @abstract   滑动手势的处理
 @result     void
 */
- (void)pan:(UIPanGestureRecognizer*)gesture
{
//    //拖动开始的状态
//    if (gesture.state == UIGestureRecognizerStateBegan)
//    {
//        [self panBegin:gesture];
//    }
//    
//    //拖动的过程中的处理
//    if (gesture.state == UIGestureRecognizerStateChanged)
//    {
//        [self panChange:gesture];
//    }
//    
//    //拖动结束的时候
//    else if (gesture.state == UIGestureRecognizerStateEnded ||
//        gesture.state == UIGestureRecognizerStateCancelled)
//    {
//        [self panEnd:gesture];
//    }
}

/*
 @method     tap:
 @abstract   点击手势的处理（只有当_root在侧面的时候才允许点击事件）
 @result     void
 */
- (void)tap:(UITapGestureRecognizer*)gesture
{
    [gesture setEnabled:NO];
    [self showRootController:YES];
}

/*
 @method     panBegin:
 @abstract   拖动手势开始的时候，获得初始状态的数据
 @result     void
 */
- (void)panBegin:(UIPanGestureRecognizer*)gesture
{
    [self showShadow:YES];
    
    _panOriginX = _root.view.frame.origin.x;//_root的原点坐标的x
    _panVelocity = CGPointMake(kZero, kZero);//拖动的速率(向右为正，向左为负)
    
    if([gesture velocityInView:self.view].x > 0)
    {
        _panDirection = DDMenuPanDirectionRight;//1
    }
    else
    {
        _panDirection = DDMenuPanDirectionLeft;//2
    }
}

/*
 @method     panChange：
 @abstract   拖动手势改变的过程中，对_root的位置进行改变
 @result     void
 */
- (void)panChange:(UIPanGestureRecognizer*)gesture
{
    CGPoint velocity = [gesture velocityInView:self.view];
    
    if((velocity.x*_panVelocity.x) < 0)
    {
        //方向改变
        _panDirection = (_panDirection == DDMenuPanDirectionRight) ?
            DDMenuPanDirectionLeft : DDMenuPanDirectionRight;
    }
    
    _panVelocity = velocity;
    //滑动过程中改变的坐标
    CGPoint translation = [gesture translationInView:self.view];
    CGRect frame = _root.view.frame;
    //重新获得frame的位置
    frame.origin.x = _panOriginX + translation.x;
    
    //1.向右滑动的处理
    if (frame.origin.x > kZero && !_menuFlags.showingLeftView)
    {
        frame = [self panChangeTowardsToRight:gesture withOldFrame:frame];
    }
    //2.向左滑动
    else if (frame.origin.x < kZero && !_menuFlags.showingRightView) //2
    {
        frame = [self panChangeTowardsToLeft:gesture withOldFrame:frame];
    }
    _root.view.frame = frame;
}

/*
 @method     panEnd：
 @abstract   拖动手势结束的时候
 @result     void
 */
- (void)panEnd:(UIPanGestureRecognizer*)gesture
{
    //!!![self.view setUserInteractionEnabled:NO];
    
    // by default animate back to the root
    DDMenuPanCompletion completion = DDMenuPanCompletionRoot; 
    
    if (_panDirection == DDMenuPanDirectionRight && _menuFlags.showingLeftView)
    {
        completion = DDMenuPanCompletionLeft;//1
    }
    else if (_panDirection == DDMenuPanDirectionLeft && _menuFlags.showingRightView)
    {
        completion = DDMenuPanCompletionRight;
    }
    
    CGPoint velocity = [gesture velocityInView:self.view];
    velocity.x = fabsf(velocity.x);
    BOOL bounce = (velocity.x > kLowestVelocityX);
    CGFloat originX = _root.view.frame.origin.x;
    CGFloat width = _root.view.frame.size.width;
    CGFloat span = (width - kMenuOverlayWidth); //280
    CGFloat duration =
        bounce ? (span / velocity.x) : ((span - originX) / span) * duration;

    //动画开始
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completion == DDMenuPanCompletionLeft)
        {
            [self showLeftController:NO];//1
        }
        else if (completion == DDMenuPanCompletionRight)
        {
            [self showRightController:NO];
        }
        else
        {
            [self showRootController:NO];//2
        }
        [_root.view.layer removeAllAnimations];
        [self.view setUserInteractionEnabled:YES];
    }];
    
    CGPoint pos = _root.view.layer.position;
    CAKeyframeAnimation *animation =
        [CAKeyframeAnimation animationWithKeyPath:kAnimationKeyPath];
    
    //获得动画参数（keyTimes,values,timingFunctions）
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:
        [self setAnimationParameterWithBounce:bounce Duration:duration
        Pos:pos Completion:completion Span:span Width:width]];
    
    animation.timingFunctions = [dic objectForKey:kKeyOfTimingFunctions];
    animation.keyTimes = [dic objectForKey:kKeyOfKeyTimes];
    //animation.calculationMode = @"cubic";
    animation.values = [dic objectForKey:kKeyOfValues];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_root.view.layer addAnimation:animation forKey:nil];
    [CATransaction commit];
}

/*
 @method     panChangeTowardsToLeft: withOldFrame:
 @abstract   向左拖动时的处理事件（第一次进入）
 @result     CGRcet
 */
- (CGRect)panChangeTowardsToLeft:(UIPanGestureRecognizer*)gesture
    withOldFrame:(CGRect)aFrame
{
    if(_menuFlags.showingLeftView) //2.1
    {
        _menuFlags.showingLeftView = NO;
        //?
        [self.leftViewController.view removeFromSuperview];
    }
    
    if (_menuFlags.canShowRight)
    {
        _menuFlags.showingRightView = YES;
        CGRect frame = self.view.bounds;
        frame.origin.x += frame.size.width - kMenuFullWidth;
        frame.size.width = kMenuFullWidth;
        self.rightViewController.view.frame = frame;
        [self.view insertSubview:self.rightViewController.view atIndex:0];
    }
    else
    {
        aFrame.origin.x = kZero; // ignore left view if it's not set
    }
    return aFrame;
}

/*
 @method     panChangeTowardsToRight: withOldFrame:
 @abstract   向右拖动时的处理事件（第一次进入）
 @result     CGRect
 */
- (CGRect)panChangeTowardsToRight:(UIPanGestureRecognizer*)gesture
    withOldFrame:(CGRect)aFrame
{
    if(_menuFlags.showingRightView)
    {
        _menuFlags.showingRightView = NO;
        [self.rightViewController.view removeFromSuperview];
    }
    
    if (_menuFlags.canShowLeft) //1
    {
      
        _menuFlags.showingLeftView = YES;
        //?insert leftViewController
        CGRect frame = self.view.bounds;
        frame.size.width = kDeviceWidth;
        self.leftViewController.view.frame = frame;
        [self.view insertSubview:self.leftViewController.view atIndex:0];
    }
    else
    {
        aFrame.origin.x = kZero; //ignore right view if it's not set
    }
    return aFrame;
}

/*
 @method     setAnimationParameterWithBounce: Duration: 
             Pos: Completion: Span: Width:
 @abstract   设置动画参数（keyTimes,values,timingFunctions）
 @result     NSArray *       
 */
- (NSDictionary *)setAnimationParameterWithBounce:(BOOL)bounce
    Duration:(float)duration Pos:(CGPoint)pos
    Completion:(DDMenuPanCompletion)completion Span:(float)span
    Width:(float)width
{
    NSMutableArray *keyTimes =
        [[NSMutableArray alloc] initWithCapacity:bounce ?
        kArrCountForBounceTrue : kArrCountForBounceFalse];
    NSMutableArray *values =
        [[NSMutableArray alloc] initWithCapacity:bounce ?
        kArrCountForBounceTrue : kArrCountForBounceFalse];
    NSMutableArray *timingFunctions =
        [[NSMutableArray alloc] initWithCapacity:bounce ?
        kArrCountForBounceTrue : kArrCountForBounceFalse];
    
    [values addObject:[NSValue valueWithCGPoint:pos]];
    [timingFunctions addObject:[CAMediaTimingFunction
        functionWithName:kCAMediaTimingFunctionEaseIn]];
    [keyTimes addObject:[NSNumber numberWithFloat:kZero]];
    if (bounce)
    {
        duration += kMenuBounceDuration;
        [keyTimes addObject: [NSNumber numberWithFloat:
            kPrimaryDuration - ( kMenuBounceDuration / duration)]];
        if (completion == DDMenuPanCompletionLeft)
        {
            [values addObject:[NSValue valueWithCGPoint:
                CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
        }
        else if (completion == DDMenuPanCompletionRight)
        {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake
                (-((width/2) - (kMenuOverlayWidth-kMenuBounceOffset)), pos.y)]];
        }
        else
        {
            // depending on which way we're panning add a bounce offset
            if (_panDirection == DDMenuPanDirectionLeft)
            {
                [values addObject:[NSValue valueWithCGPoint:
                    CGPointMake ((width/2) - kMenuBounceOffset, pos.y)]];
            }
            else
            {
                [values addObject:[NSValue valueWithCGPoint:
                    CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
            }
        }
        [timingFunctions addObject:[CAMediaTimingFunction
            functionWithName:kCAMediaTimingFunctionEaseOut]];
    }
    if (completion == DDMenuPanCompletionLeft)
    {
        [values addObject:[NSValue valueWithCGPoint:
            CGPointMake((width/2) + span, pos.y)]];//1
    }
    else if (completion == DDMenuPanCompletionRight)
    {
        [values addObject:[NSValue valueWithCGPoint:
            CGPointMake(-((width/2) - kMenuOverlayWidth), pos.y)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
    }
    
    [timingFunctions addObject:
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [keyTimes addObject:[NSNumber numberWithFloat:kPrimaryDuration]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
        keyTimes,kKeyOfKeyTimes,values,kKeyOfValues,
        timingFunctions,kKeyOfTimingFunctions, nil];
    return dic;
}
#pragma mark - UIGestureRecognizerDelegate

/*
 @method     gestureRecognizerShouldBegin:
 @abstract   当有手势的时候，判断手势类型
 @result     BOOL
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan)
    {
        UIPanGestureRecognizer *panGesture =
            (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if (sqrt(translation.x * translation.x) /
            sqrt(translation.y * translation.y) > 1)
        {
            return YES;
        }        
        return NO;
    }
    
    if (gestureRecognizer == _tap)
    {
        if (_root && (_menuFlags.showingRightView || _menuFlags.showingLeftView))
        {
            return CGRectContainsPoint
                (_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}

/*
 @method     gestureRecognizer: 
             shouldRecognizeSimultaneouslyWithGestureRecognizer:
 @abstract   Asks the delegate if two gesture recognizers 
             should be allowed to recognize gestures simultaneously.
 @result     BOOL
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:
    (UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer==_tap)
    {
        return YES;
    }
    return NO;
}


#pragma Internal Nav Handling

/*
 @method     resetNavButtons
 @abstract   设置导航栏的按钮
 @result     void
 */
- (void)resetNavButtons
{
    if (!_root) return;
    
    UIViewController *topController = nil;
    //判断_root是什么样的视图，获得上层视图
    if ([_root isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController*)_root;
        if ([[navController viewControllers] count] > 0)
        {
            topController = [[navController viewControllers] objectAtIndex:0];
        }
    }
    else if ([_root isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabController = (UITabBarController*)_root;
        topController = [tabController selectedViewController];
    }
    else
    {
        topController = _root;
    }
    //显示导航栏的按钮
    if (_menuFlags.canShowLeft)
    {
        UIBarButtonItem *menuButton = [self formatNavBarLeftItem];
        menuButton.tag = kMenuButtonTag;
        topController.navigationItem.leftBarButtonItem = menuButton;
    }
    else
    {
        topController.navigationItem.leftBarButtonItem = nil;
    }
    
    if (_menuFlags.canShowRight)
    {
        UIImage *image = [UIImage imageNamed:kNavBarItemImage];
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image
            style:UIBarButtonItemStyleBordered
            target:self action:@selector(showRight:)];
        topController.navigationItem.rightBarButtonItem = button;
    }
    else
    {
        topController.navigationItem.rightBarButtonItem = nil;
    }
    
    [self formatLeftToolBar];    
    [self updateButtonStates];
}


/*
 @method     showShadow:
 @abstract   设置拖动过程中的视图阴影效果
 @result     void
 */
- (void)showShadow:(BOOL)val
{
    if (!_root) return;
    
    //透明度
    _root.view.layer.shadowOpacity =
        val ? kShadowOpacityValue : kShadowOpacityNone;
    
    if (val)
    {
        _root.view.layer.cornerRadius = kCornerRadius;
        _root.view.layer.shadowOffset = CGSizeMake(kShadowOffsetX, kShadowOffsetY);
        _root.view.layer.shadowRadius = kShadowRadius;
        _root.view.layer.shadowPath =
            [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        self.view.layer.masksToBounds = YES;
        self.view.layer.shadowColor = [UIColor grayColor].CGColor;
    }
}

/*
 @method     showRootController:
 @abstract   显示_root视图
 @result     void
 */
- (void)showRootController:(BOOL)animated
{
    [_tap setEnabled:NO];
    _root.view.userInteractionEnabled = YES;
    
    CGRect frame = _root.view.frame;
    frame.origin.x = kZero;
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated)
    {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:kMenuSlideDuration animations:^{
        
        _root.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (_left && _left.view.superview)
        {
            [_left.view removeFromSuperview];
        }
        
        if (_right && _right.view.superview)
        {
            [_right.view removeFromSuperview];
        }
        
        _menuFlags.showingLeftView = NO;
        _menuFlags.showingRightView = NO;
        
        [self showShadow:NO];
    }];
    
    if (!animated)
    {
        [UIView setAnimationsEnabled:_enabled];
    }
}

/*
 @method     showLeftController:
 @abstract   显示_left视图
 @result     void
 */
- (void)showLeftController:(BOOL)animated
{
    if (!_menuFlags.canShowLeft) return;
    
    if (_right && _right.view.superview)
    {
        [_right.view removeFromSuperview];
        _menuFlags.showingRightView = NO;
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];
    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    //NSLog(@"retainCount:%d",_left.retainCount);//1
    [self.view insertSubview:view atIndex:0];
    //NSLog(@"retainCount:%d",_left.retainCount);//3
    //NSLog(@"retainCount:%d",self.view.retainCount);
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x =
        CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);//280
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated)
    {
        [UIView setAnimationsEnabled:NO];
    }
    //!!!_root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:kMenuSlideDuration animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        //取消tap效果
        [_tap setEnabled:YES];
    }];
    
    if (!animated)
    {
        [UIView setAnimationsEnabled:_enabled];
    }
}

/*
 @method     showRightController:
 @abstract   显示_right视图
 @result     void
 */
- (void)showRightController:(BOOL)animated
{
    if (!_menuFlags.canShowRight) return;
    
    if (_left && _left.view.superview)
    {
        [_left.view removeFromSuperview];
        _menuFlags.showingLeftView = NO;
    }

    _menuFlags.showingRightView = YES;
    [self showShadow:YES];
    
    UIView *view = self.rightViewController.view;
    CGRect frame = self.view.bounds;
	frame.origin.x += frame.size.width - kMenuFullWidth;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    frame = _root.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated)
    {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:kMenuSlideDuration animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated)
    {
        [UIView setAnimationsEnabled:_enabled];
    }
}


#pragma mark Setters

/*
 @method     setRightViewController:
 @abstract   显示_right视图
 @result     void
 */
- (void)setRightViewController:(UIViewController *)rightController
{
    _right = rightController;
    _menuFlags.canShowRight = (_right!=nil);
    [self resetNavButtons];
}

/*
 @method     setLeftViewController:
 @abstract   显示_left视图
 @result     void
 */
- (void)setLeftViewController:(UIViewController *)leftController
{
    _left = leftController;
    _menuFlags.canShowLeft = (_left!=nil);
    [self resetNavButtons];
}

/*
 @method     setRootViewController:
 @abstract   显示_root视图
 @result     void
 */
- (void)setRootViewController:(UIViewController *)rootViewController
{
    UIViewController *tempRoot = _root;
    _root = rootViewController;
    
    if (_root)
    {
        if (tempRoot)
        {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
            initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        //将滑动的手势加在了rootView上
        [view addGestureRecognizer:pan];
        _pan = pan;        
    }
    else
    {
        if (tempRoot)
        {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
    }
    //设置导航栏的按钮
    [self resetNavButtons];
}

/*
 @method     setRootViewController:
 @abstract   显示_root视图
 @result     void
 */
- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated
{    
    if (!controller)
    {
        [self setRootViewController:controller];
        return;
    }
    
    if (_menuFlags.showingLeftView)
    {        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
        frame.origin.x = rootRef.view.bounds.size.width;
        
        [UIView animateWithDuration:kShowRootAnimationDuration animations:^{
            
            rootRef.view.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [selfRef setRootViewController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
            
        }];
    }
    else
    {
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
    }
}


#pragma mark - Root Controller Navigation
/*//留作扩展
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSAssert((_root!=nil), @"no root controller set");
    
    UINavigationController *navController = nil;
    
    if ([_root isKindOfClass:[UINavigationController class]]) {
        
        navController = (UINavigationController*)_root;
        
    } else if ([_root isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *topController = [(UITabBarController*)_root selectedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)topController;
        }
        
    }
    
    if (navController == nil)
    {
        NSLog(@"root controller is not a navigation controller.");
        return;
    }
    
    
    if (_menuFlags.showingRightView) {
        
        // if we're showing the right it works a bit different, we'll make a screen shot of the menu overlay, then push, and move everything over
        __block CALayer *layer = [CALayer layer];
        CGRect layerFrame = self.view.bounds;
        layer.frame = layerFrame;
        
        UIGraphicsBeginImageContextWithOptions(layerFrame.size, YES, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        layer.contents = (id)image.CGImage;
        
        [self.view.layer addSublayer:layer];
        [navController pushViewController:viewController animated:NO];
        CGRect frame = _root.view.frame;
        frame.origin.x = frame.size.width;
        _root.view.frame = frame;
        frame.origin.x = 0.0f;
        
        CGAffineTransform currentTransform = self.view.transform;
        
        [UIView animateWithDuration:0.25f animations:^{
            
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                
                self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0, -[[UIScreen mainScreen] applicationFrame].size.height));
                
            } else {
                
                self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(-[[UIScreen mainScreen] applicationFrame].size.width, 0));
            }
            
            
        } completion:^(BOOL finished) {
            
            [self showRootController:NO];
            self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0.0f, 0.0f));
            [layer removeFromSuperlayer];
            
        }];
    }
    else
    {
        [navController pushViewController:viewController animated:animated];
    }
}
*/

#pragma mark - Actions

/*
 @method     showLeft:
 @abstract   显示_left视图
 @result     void
 */
- (void)showLeft:(id)sender
{
    [self showLeftController:YES];
    
}

/*
 @method     showRight:
 @abstract   显示_right视图
 @result     void
 */
- (void)showRight:(id)sender
{
    [self showRightController:YES];
}

/*
 @method     showRoot:
 @abstract   显示_root视图
 @result     void
 */
- (void)showRoot:(id)sender
{
    [self showRootController:YES];
}

#pragma mark-formatnavbarbuttonItem methods

/*
 @method     formatNavBarLeftItem：
 @abstract   UIBarButtonItem 定制
 @result     UIBarButtonItem*
 */
- (UIBarButtonItem *)formatNavBarLeftItem
{
    //标题栏中的左边按钮
    UIButton *navBarLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBarLeftBtn setBackgroundImage:[UIImage imageNamed:kNavBarItemImage]       
                             forState:UIControlStateNormal];
    navBarLeftBtn.frame = CGRectMake(kNavBarButtonX, kNavBarButtonY,
        kNavBarButtonWidth, kNavBarButtonHeight);
    navBarLeftBtn.tag = kNavBarLeftBtnTag;
    
    [navBarLeftBtn addTarget:self
                      action:@selector(showLeftOrRightView)                                                         
            forControlEvents:UIControlEventTouchUpInside];
       
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
        initWithCustomView:navBarLeftBtn];
    
    return menuButton;
}

/*
 @method     showLeftOrRightView：
 @abstract   根据_root的位置，确定当点击左上角的navgationButton时应进行何种处理
 @result     void
 */
- (void)showLeftOrRightView
{
    //当_root在正中间的时候，点击NavButton时调用ShowLeft:
    if(0 == _root.view.frame.origin.x)
    {
        [self showLeft:nil];
    }
    
    //当_root在右侧边栏的时候，点击NavButtion时调用ShowRoot
    else
    {
        CBDrawMenuViewController *menuVC =(CBDrawMenuViewController *)self.leftViewController;
        self.mainController.drawView.lineWidth = menuVC.lineWidth;
        self.mainController.drawView.lineAlpha = menuVC.lineAlpha;    
        self.mainController.drawView.lineColor = menuVC.lineColor;
        
        if (self.imageToShow) {
            //添加图片
            [self.mainController addImageView:self.imageToShow];
            self.imageToShow = nil;
        }
        if (menuVC.textWords) {
            [self.mainController addTextLable:menuVC.textWords];
            menuVC.textWords = nil;
        }
       
        [self showRoot:nil];
    }
}

#pragma mark - itswyy 绘图页面操作事件

- (void)undoAction
{
    [self.mainController.drawView undoLatestStep];
    [self updateButtonStates];
}
- (void)redoAction
{
    [self.mainController.drawView redoLatestStep];
    [self updateButtonStates];
}

-(void)clearAction
{
    //将所有子视图都清空，文本和图片
    for (UIView *subView  in self.mainController.view.subviews) {
        [subView removeFromSuperview];
    }
    //画板清空
    [self.mainController.drawView clear];
}

- (void)getAdviceImage
{
    CGSize photoSize = self.view.bounds.size;
    UIGraphicsBeginImageContext(photoSize);    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //对得到的图片进行裁剪
    CGRect rect = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44);
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
    //放到了相册里
//    UIImageWriteToSavedPhotosAlbum(resultImg, self, nil, nil);
    
    self.imageToSave = resultImg;
}

- (void)backBtnPressed
{
    //TODO:返回的时候可能需要一些操作
//    [self getAdviceImage];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)saveBtnPressed
{
    //得到当前界面形成的图片
    [self getAdviceImage];
    [self imageUpload:self.imageToSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendBtnPressed

{    
    //得到当前界面形成的图片
    [self getAdviceImage];
    [self imageUpload:self.imageToSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *	更新navigationBar上redo 和 undo按钮状态
 */
- (void)updateButtonStates
{
    UIButton *redoBtn = (UIButton *)[self.view viewWithTag:kRedoBtnTag];
    UIButton *undoBtn = (UIButton *)[self.view viewWithTag:kUndoBtnTag];
    
    if (!self.mainController.drawView.canRedo) {
        redoBtn.enabled = YES;
    }
    if (!self.mainController.drawView.canUndo) {
        undoBtn.enabled = YES;
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        self.imageToShow = [UIImage imageWithData:data];
        
    }
    [self showLeftOrRightView];
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];    
}

//上传图片方法
- (void) imageUpload:(UIImage *) image
{
    
    ClassBookAPIClient *httpClient = [ClassBookAPIClient sharedClient];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss"];
    date = [formatter stringFromDate:[NSDate date]];

    NSString *photoName = [NSString stringWithFormat:@"%@.png",date];
    int userid = [[CBCurrentUser currentUser] user_id];
    NSString *photoPath = [NSString stringWithFormat:@"Users/%d/images/%@",userid,photoName];
    NSString *vedioName = [NSString stringWithFormat:@"default.wav"];
    NSString *vedioPath = [NSString stringWithFormat:@"Users/%d/vedios/%@",userid,vedioName];
    //要传的其他字段
    
    NSDictionary * parameters = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:userid],@"user_id",
        [NSNumber numberWithInt:self.userid2] ,@"user_id2",
        photoPath,@"advice_add",
        vedioPath,@"advice_vedio_add",nil];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"uploadAdviceMsg.php" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:photoName mimeType:@"image/jpeg"];
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    NSLog(@"%@", operation.request.URL);
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlock:^()
    {
            NSLog(@"%@",operation.responseString);
    }];
    [operation start];    

}
@end

