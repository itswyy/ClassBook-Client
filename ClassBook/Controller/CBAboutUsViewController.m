//
//  CBAboutUsViewController.m
//  ClassBook
//
//  Created by wtlucky on 13-4-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBAboutUsViewController.h"

@interface CBAboutUsViewController ()

@end

@implementation CBAboutUsViewController

@synthesize webView = _webView;

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
	
    self.navigationItem.title = @"关于我们";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    [self.view addSubview:_webView];
    
    [self loadAboutUsHTML];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAboutUsHTML
{
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"introduction" ofType:@"html"];
    NSURL *htmlUrl = [NSURL fileURLWithPath:htmlPath isDirectory:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:htmlUrl];
    [self.webView loadRequest:request];
}

@end
