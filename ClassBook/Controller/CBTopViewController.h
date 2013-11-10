//
//  CBTopViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-7.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBDepthViewController.h"

@interface CBTopViewController : UIViewController

@property (weak, nonatomic) CBDepthViewController* depthViewReference;
@property (weak, nonatomic) UIView* presentedInView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic)IBOutlet UIWebView *protocolWebView;

- (IBAction)closeView:(id)sender;

@end
