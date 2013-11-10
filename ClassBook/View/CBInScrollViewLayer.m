//
//  CBInScrollViewLayer.m
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBInScrollViewLayer.h"

@implementation CBInScrollViewLayer

@synthesize image;

- (id)init
{
    self = [super init];
    if (self) {
		//image = nil;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    // self.backgroundColor = [UIColor redColor].CGColor;
	UIGraphicsPushContext(ctx);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0];
	CGContextSaveGState(ctx);
	CGContextAddPath(ctx, path.CGPath);
	CGContextClip(ctx);
	[image drawInRect:self.bounds];
	CGContextRestoreGState(ctx);
	UIGraphicsPopContext();
}
- (void)setImage:(UIImage *)inImage
{
	image = inImage;
	[self setNeedsDisplay];
}

- (UIImage *)image
{
	return image;
}
@end
