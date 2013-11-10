//
//  CBNoteView.m
//  ClassBook
//
//  Created by 小雨 on 13-4-15.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBNoteView.h"

@implementation CBNoteView
@synthesize nameLable;
@synthesize timeLable;
@synthesize msgLable;
@synthesize tapTime;
@synthesize originalRect;
@synthesize originalTransform;
@synthesize originalFont;
@synthesize exchangeFont;
@synthesize delButton;
@synthesize isFirst;

- (id)initWithFrame:(CGRect)frame
{    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"notepad.png"];
        originalFont = [UIFont fontWithName:@"华文楷体" size:5];
        originalFont = [UIFont systemFontOfSize:7];
        exchangeFont = [UIFont fontWithName:@"华文楷体" size:10];
        exchangeFont = [UIFont systemFontOfSize:10];
        isFirst = YES;
        
        self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delButton.frame = CGRectMake(120, 15, 30, 30);
        self.delButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"u62_normal.png"]];
        [self.delButton addTarget:self action:@selector(deleteNote) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 25, 5)];
        self.msgLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 40, 40)];
        [self.msgLable setNumberOfLines:0];
        [self.msgLable setLineBreakMode:NSLineBreakByWordWrapping];
        self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 52, 30, 10)];
        
        self.nameLable.backgroundColor = [UIColor clearColor];
        self.msgLable.backgroundColor = [UIColor clearColor];
        self.timeLable.backgroundColor = [UIColor clearColor];
        
        self.nameLable.text = @"";
        self.msgLable.text = @"";
        self.timeLable.text = @"";
        
        self.timeLable.font = originalFont;
        self.nameLable.font = originalFont;
        self.msgLable.font = originalFont;
        
        tapTime = 0;
        [self addSubview:self.nameLable];
        [self addSubview:self.msgLable];
        [self addSubview:self.timeLable];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
   
    if (tapTime == 0) {//原始状态时轻击
        //存储原始位置数据
        if (isFirst == YES) {
            originalRect = self.frame;
            isFirst = NO;
        }
        originalTransform = self.transform;
        //NSLog(@"%f--%f--%f--%f",originalRect.origin.x,originalRect.origin.y,originalRect.size.width,originalRect.size.height);
        //轻击结果
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = CGRectMake(150, 50, 200, 200);
        self.nameLable.frame = CGRectMake(10, 35, 50, 10);
        self.msgLable.frame = CGRectMake(30, 40, 130, 120);
        self.timeLable.frame = CGRectMake(80, 165, 100, 15);
        
        self.nameLable.font = exchangeFont;
        self.msgLable.font = exchangeFont;
        self.timeLable.font = exchangeFont;
        
        [self.superview bringSubviewToFront:self];
        //[self addSubview:self.delButton];
        tapTime = 1;
    }
    else//放大状态时轻击
    {
        self.frame = CGRectMake(originalRect.origin.x, originalRect.origin.y, 70, 70);
        self.transform = originalTransform;
        self.nameLable.frame = CGRectMake(5, 15, 25, 5);
        self.msgLable.frame = CGRectMake(15, 20, 40, 40);
        self.timeLable.frame = CGRectMake(20, 52, 30, 10);
        self.timeLable.font = originalFont;
        self.nameLable.font = originalFont;
        self.msgLable.font = originalFont;
        //[self.delButton removeFromSuperview];
        tapTime = 0;
    }
    //NSLog(@"%f--%f--%f--%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    
    [UIView commitAnimations];
}

/**
 *	删除被选中的便签
 */
- (void)deleteNote

{
    //NSLog(@"shanchule");转到代理执行去
}

@end
