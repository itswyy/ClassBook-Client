//
//  CBUserAdviceViewController.m
//  ClassBook
//
//  Created by Admin on 13-4-12.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBUserAdviceViewController.h"
#import "Utilities.h"
#import "CBCurrentUser.h"
#import "DDMenuController.h"
#import "CBViewController.h"
#import "CBDrawMenuViewController.h"
#import "ImageStore.h"

@interface CBUserAdviceViewController ()

@end

@implementation CBUserAdviceViewController

@synthesize user_id = _user_id;
@synthesize advices = _advices;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

- (void)loadView {
	[super loadView];
	leavesView.frame = self.view.bounds;
	leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:leavesView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (_user_id == 0)
    {
        //离线模式
        AdviceImagesAr = [[NSArray alloc]initWithObjects:[[ImageStore defaultImageStore] imageForKey:[[_advices objectAtIndex:0] objectForKey:@"advice"]],nil];
        DLog(@"advices = %@",_advices);
    }
    else
    {
        AdviceImagesAr = [[NSArray alloc] initWithObjects:
                      [UIImage imageNamed:@"kitten.jpg"],
                      [UIImage imageNamed:@"kitten2.jpg"],
                      [UIImage imageNamed:@"kitten3.jpg"],
                      nil];
        
        UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送赠言" style:UIBarButtonItemStylePlain target:self action:@selector(sendAdvice)];
        self.navigationItem.rightBarButtonItem = sendBtn;
    }
//    UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送赠言" style:UIBarButtonItemStylePlain target:self action:@selector(sendAdvice)];
//    self.navigationItem.rightBarButtonItem = sendBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor purpleColor];
    leavesView.dataSource = self;
	leavesView.delegate = self;
	[leavesView reloadData];

    
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:ISNAVIGATIONBAR_BACKIMAGE] forBarMetrics:UIBarMetricsDefault];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
}

- (void)sendAdvice
{
    DDMenuController *middleViewController = [[DDMenuController alloc] init];
    CBViewController *mainViewController =[[CBViewController alloc] init];
    
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    CBDrawMenuViewController *menuVC  = [storyboard instantiateViewControllerWithIdentifier:@"CBDrawMenuViewController"];
    
    middleViewController.leftViewController = menuVC;
//TODO:此处要放开，存入某个人的文件夹中
    middleViewController.userid2 = _user_id;
//    middleViewController.userid2 = 108132;
    middleViewController.rootViewController =mainNav ;
    [self presentModalViewController:middleViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize {
    leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
}


#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return AdviceImagesAr.count;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	UIImage *image = [AdviceImagesAr objectAtIndex:index];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}


@end
