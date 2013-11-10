//
//  CBTopViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-7.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBTopViewController.h"

@interface CBTopViewController ()<UIWebViewDelegate>

@end

@implementation CBTopViewController
@synthesize protocolWebView;

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
    NSString *Path = [[NSBundle mainBundle] pathForResource:@"introduction" ofType:@"html"];
    NSURL* address = [[NSURL alloc] initFileURLWithPath:Path isDirectory:YES];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:address];
    
    //UIScrollView *scroll = [[protocolWebView subviews]objectAtIndex:0];
    //scroll.userInteractionEnabled = YES;
    [self.view setUserInteractionEnabled:YES];
    [protocolWebView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)closeView:(id)sender {
    [self.depthViewReference dismissPresentedViewInView:self.presentedInView];
}
@end
