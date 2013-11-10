//
//  CBViewController.h
//  DrawPictures
//
//  Created by Parker on 24/3/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"

@class ACEDrawingView;

@interface CBViewController : UIViewController
<SPUserResizableViewDelegate,UIGestureRecognizerDelegate>

@property (strong ,nonatomic) ACEDrawingView *drawView;

/**
 *	添加文本lable
 *
 *	@param 	textToShow 	要显示的文字
 */
- (void)addTextLable:(NSString *)textToShow;

/**
 *	添加图片
 *
 *	@param 	imageToShow 	要显示的图片
 */
- (void)addImageView:(UIImage *)imageToShow;

@end
