//
//  CBViewController.m
//  DrawPictures
//
//  Created by Parker on 24/3/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CBViewController.h"
#import "ACEDrawingView.h"
#import "SPUserResizableView.h"

@interface CBViewController ()<ACEDrawingViewDelegate>

/**
 *	添加长按事件
 *
 *	@param 	view 	被添加的视图
 */
- (void)addLongGesture:(UIView *)view;

/**
 *	添加删除按钮
 *
 *	@param 	view 	被添加的视图
 */
- (void)addDeleteButtion:(UIView *)view;

/**
 *	删除视图
 *
 *	@param 	removeObj 	要删除的视图
 */
- (void)removeTheView:(UIView *)removeObj;



@end

@implementation CBViewController
@synthesize drawView = _drawView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.drawView = [[ACEDrawingView alloc] init];
    self.view = self.drawView;
    _drawView.delegate = self;
    self.drawView.lineColor = [UIColor blackColor];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"drawBackground.jpg"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDrawView:nil];
    [super viewDidUnload];
}



- (void)addTextLable:(NSString *)textToShow
{
    CGRect textFrame = CGRectMake(50, 100, 200, 200);
    SPUserResizableView *resizableView = [[SPUserResizableView alloc] initWithFrame:textFrame];
    UILabel *textLable = [[UILabel alloc] initWithFrame:textFrame];
    textLable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg.jpg"]];
    [textLable setNumberOfLines:0];
    [textLable setLineBreakMode:NSLineBreakByWordWrapping];
    textLable.text = textToShow;
    
    resizableView.contentView = textLable;
    [self.drawView addSubview:resizableView];
    
    [self addLongGesture:textLable];
    
    [self.view addSubview:resizableView];
}
/**
 *	添加图片
 *
 *	@param 	imageToShow 	要显示的图片
 */
- (void)addImageView:(UIImage *)imageToShow
{
    CGRect picFrame = CGRectMake(50, 50, 200, 150);
    SPUserResizableView *picture = [[SPUserResizableView alloc] initWithFrame:picFrame];
    
    UIImageView * pictureView = [[UIImageView alloc] initWithImage:imageToShow];
    picture.delegate = self;
    picture.contentView =pictureView;
    
    [self addLongGesture:picture];
    
    [self.view insertSubview:picture atIndex:1];
}

/**
 *	添加长按事件
 *
 *	@param 	view 	被添加的视图
 */
- (void)addLongGesture:(UIView *)view
{
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addDeleteButtion:)];
    lpress.minimumPressDuration = 1;
    lpress.delegate = self;
    [view addGestureRecognizer:lpress];
}


//TODO:itswyy 长按事件删除视图
/**
 *	添加删除按钮
 *
 *	@param 	view 	被添加的视图
 */
- (void)addDeleteButtion:(UIView *)view
{
    float width = self.view.frame.size.width - 35;
    float height = self.view.frame.size.height - 35;
    CGRect btnRect = CGRectMake(0, 0, width, height);
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = btnRect;
    delBtn.imageView.image = [UIImage imageNamed:@"007.jpg"];
    [self.view addSubview:delBtn];
}

/**
 *	删除视图
 *
 *	@param 	removeObj 	要删除的视图
 */
- (void)removeTheView:(UIView *)removeObj
{
    
}

@end
