//
//  UIView+Screenshot.m
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

//获取nav的截屏以供动画使用
- (UIImage *)screenshot
{
	UIGraphicsBeginImageContext(self.bounds.size);
    //注释之后无变化
	[[UIColor clearColor] setFill];
	[[UIBezierPath bezierPathWithRect:self.bounds] fill];
    //end
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[self.layer renderInContext:ctx];
    
	UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return anImage;
}

@end
