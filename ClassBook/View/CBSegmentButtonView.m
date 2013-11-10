//
//  CBSegmentButtonView.m
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBSegmentButtonView.h"
#define TOP_OFFSET 10    //按钮上边距
#define ANIMATION_DURATION 0.2 //切换选择方式动画时间

@interface CBSegmentButtonView ()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImage *normalImage;
@property(nonatomic, strong) UIImage *highlightImage;
@property(nonatomic, weak) id <CBSegmentButtonDelegate> delegate;
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *shadowColor;
@property(nonatomic, strong) UIColor *highlightShadowColor;

- (void)expandSegment:(BOOL)animation;
- (void)collapseSegment:(BOOL)animation;
- (void)segmentTapped;

@end


@implementation CBSegmentButtonView

@synthesize normalImage = _normalImage;
@synthesize highlightImage = _highlightImage;
@synthesize imageView = _imageView;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize delegate = _delegate;
@synthesize label = _label;
@synthesize textColor = _textColor;
@synthesize shadowColor = _shadowColor;
@synthesize highlightShadowColor = _highlightShadowColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *	初始化选择注册方式按钮
 *
 *	@param 	title 	按钮上的文字
 *	@param 	normalImage 	按钮正常状态图片
 *	@param 	highlightImage 	按钮高亮状态图片
 *	@param 	delegate 	按钮代理
 *
 *	@return	注册方式按钮
 */
- (CBSegmentButtonView *)initWithTitle:(NSString *)title
                           normalImage:(UIImage *)normalImage
                        highlightImage:(UIImage *)highlightImage
                              delegate:(id <CBSegmentButtonDelegate>)delegate

{
    if (self = [super init]) {
        self.normalImage = normalImage;
        self.highlightImage = highlightImage;
        self.delegate = delegate;
        self.textColor = [UIColor colorWithRed:51.0 / 255.0 green:26.0 / 255.0 blue:3.0 / 255.0 alpha:1.0];
        self.shadowColor = [UIColor colorWithRed:192.0 / 255.0 green:177.0 / 255.0 blue:161.0 / 255.0 alpha:1.0];
        self.highlightShadowColor = [UIColor colorWithRed:212.0 / 255.0 green:200.0 / 255.0 blue:187.0 / 255.0 alpha:1.0];
        
        //设置按钮高亮及普通状态图片
        self.imageView = [[UIImageView alloc] initWithImage:self.normalImage
                                           highlightedImage:self.highlightImage];
        self.imageView.frame = CGRectMake(0, -TOP_OFFSET,
                                          [[UIScreen mainScreen] applicationFrame].size.width/2+4, self.normalImage.size.height);
        [self addSubview:self.imageView];
        
        // 给按钮添加轻击事件
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(segmentTapped)];
        [self addGestureRecognizer:self.tapGestureRecognizer];
        
        // 设置按钮文字
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.normalImage.size.width, 20)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont boldSystemFontOfSize:13];
        self.label.textColor = self.textColor;
        self.label.shadowColor = self.shadowColor;
        self.label.shadowOffset = CGSizeMake(1, 1);
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.text = title;
        [self addSubview:self.label];
        
        self.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
 
    }
    return self;
}


/**
 *	设置按钮状态
 *
 *	@param 	highlighted 	是否为高亮状态
 *	@param 	animated 	是否需要动画切换
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
 {
    // 如果按钮本身状态就是被要求状态
    if (self.imageView.highlighted == highlighted) return;
    
    if (highlighted) {
        [self expandSegment:animated];//展开
    } else {
        [self collapseSegment:animated];//收起
    }
}


/**
 *	展开按钮，使其处于高亮状态
 *
 *	@param 	animation 	是否需要动画
 */
- (void)expandSegment:(BOOL)animation
 {
    NSTimeInterval animationDuration = animation ? ANIMATION_DURATION : 0;
    [UIView animateWithDuration:animationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^void() {
                            self.imageView.frame = CGRectOffset(self.imageView.frame, 0, TOP_OFFSET);
                            self.label.frame = CGRectOffset(self.label.frame, 0, TOP_OFFSET);
                        }                completion:^void(BOOL finished) {
                            self.imageView.highlighted = YES;
                            self.label.shadowColor = self.highlightShadowColor;
                        }];
}

/**
 *	收起按钮，并取消其高亮状态
 *
 *	@param 	animation 	是否需要动画
 */
- (void)collapseSegment:(BOOL)animation
 {
    NSTimeInterval animationDuration = animation ? ANIMATION_DURATION : 0;
    [UIView animateWithDuration:animationDuration delay:0
                        options:UIViewAnimationOptionCurveEaseIn animations:^void() {
                            self.imageView.frame = CGRectOffset(self.imageView.frame, 0, -TOP_OFFSET);
                            self.label.frame = CGRectOffset(self.label.frame, 0, -TOP_OFFSET);
                        }                completion:^void(BOOL finished) {
                            self.imageView.highlighted = NO;
                            self.label.shadowColor = self.shadowColor;
                        }];
}

/**
 *	轻击按钮触发事件
 */
- (void)segmentTapped
 {
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentButtonHighlighted:)]) {
        [self.delegate segmentButtonHighlighted:self];
    }
}

- (void)dealloc {
    [self removeGestureRecognizer:self.tapGestureRecognizer];
}
@end
