//
//  CBRegisterMethodView.m
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBRegisterMethodView.h"
#import <QuartzCore/QuartzCore.h>

@interface CBRegisterMethodView()



- (void)setUpSegmentButtons;

@end


@implementation CBRegisterMethodView
@synthesize segmentButtons;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *	初始化选型卡
 *
 *	@return	选项卡
 */
- (id)init
 {
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        
        // Set up segment buttons
        [self setUpSegmentButtons];
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 40,
                                [[UIScreen mainScreen] applicationFrame].size.width,
                                [UIImage imageNamed:@"recipe_tab_1.png"].size.height-8);
    }
    return self;
}


/**
 *	设置选项卡按钮
 */
- (void)setUpSegmentButtons
 {
    CBSegmentButtonView *segment1 = [[CBSegmentButtonView alloc] initWithTitle:@"邮箱注册"
                                                                   normalImage:[UIImage imageNamed:@"recipe_tab_1.png"]
                                                                highlightImage:[UIImage imageNamed:@"recipe_tab_1_active.png"]
                                                                      delegate:self];
    CBSegmentButtonView *segment2 = [[CBSegmentButtonView alloc] initWithTitle:@"手机注册"
                                                                   normalImage:[UIImage imageNamed:@"recipe_tab_2.png"]
                                                                highlightImage:[UIImage imageNamed:@"recipe_tab_2_active.png"]
                                                                      delegate:self];
     
    segment1.frame = CGRectOffset(segment1.frame, 0, 0);
    segment2.frame = CGRectOffset(segment2.frame, [[UIScreen mainScreen] applicationFrame].size.width/2, 0);
    segment1.tag = 1000;
    segment2.tag = 1001;
    
    // Highlight the first segment
    [segment1 setHighlighted:YES animated:NO];
    
    [self addSubview:segment1];
    [self addSubview:segment2];
    
    self.segmentButtons = [NSArray arrayWithObjects:segment1, segment2,nil];
}

#pragma mark - SegmentButtonViewDelegate
/**
 *	提示手机注册暂时无法使用
 */
- (void)noticePhoneRegesterNotWork
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲，手机注册功能暂时无法使用！" message:@"" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Sure", nil];
    [alert show];
}

- (void)segmentButtonHighlighted:(CBSegmentButtonView *)highlightedSegmentButton {
    if (highlightedSegmentButton.tag == 1000) {
        [self.delegate addEmailRegisterView];
    }
    else
    {
//        [self noticePhoneRegesterNotWork];
        [self.delegate addPhoneRegisterView];
    }
    
    for (CBSegmentButtonView *segmentButton in self.segmentButtons) {
        if ([segmentButton isEqual:highlightedSegmentButton]) {
            [segmentButton setHighlighted:YES animated:YES];
        } else {
            [segmentButton setHighlighted:NO animated:YES];
        }
    }
}


@end
