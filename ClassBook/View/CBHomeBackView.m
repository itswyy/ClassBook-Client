//
//  CBHomeBackView.m
//  ClassBook
//
//  Created by wtlucky on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBHomeBackView.h"
#import <QuartzCore/QuartzCore.h>

//CGPoint point[5] = {
//    {80, 845},
//    {240, 655},
//    {80, 465},
//    {240, 275},
//    {80, 85}
//};
CGPoint point[5] = {
    {80, 310},
    {240, 195},
    {80, 195},
    {240, 80},
    {80, 80}
};

@interface CBHomeBackView ()

- (void)groupViewResizeLayer:(CALayer *)aLayer toSize:(CGSize)aSize;

@end

@implementation CBHomeBackView

@synthesize cbDegelate = _cbDegelate;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setContentSize:CGSizeMake(320, 440)];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"commonBack.png"]]];
        self.delegate = self;
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentOffset = CGPointMake(0, 10);
        
    }
    return self;
}

- (void)setDatasource:(id<CBHomeBackViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
    self.groupCount = [self.dataSource numberOfGroups];
    for (int i = 0; i < self.groupCount; i ++)
    {
        CBGroupIconView *groupView = [self.dataSource viewAtIndex:i];
        groupView.tag = i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(groupViewDidTaped:)];
        [groupView addGestureRecognizer:tap];
        
        [groupView setCenter:point[i]];
        
        [self addSubview:groupView];
    }
}

- (void)groupViewDidTaped:(UIGestureRecognizer *)gesture
{
    [self groupViewResizeLayer:gesture.view.layer toSize:CGSizeMake(200, 200)];
    if ([_cbDegelate respondsToSelector:@selector(groupDidTapedAtIndex:)]) {
//        [(NSObject *)self.cbDegelate performSelector:@selector(groupDidTapedAtIndex:) withObject:[NSNumber numberWithInt:gesture.view.tag] afterDelay:0.1];

        [self.cbDegelate groupDidTapedAtIndex:gesture.view.tag];
    }
}

- (void)groupViewResizeLayer:(CALayer *)aLayer toSize:(CGSize)aSize
{
    CGRect oldBounds = aLayer.bounds;
    CGRect newBounds = oldBounds;
    newBounds.size = aSize;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    animation.fromValue = [NSValue valueWithCGRect:oldBounds];
    animation.toValue = [NSValue valueWithCGRect:newBounds];
    animation.duration = 0.4;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithInt:0];
    opacityAnimation.toValue = [NSNumber numberWithInt:1];
    animation.duration = 0.4;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:animation, opacityAnimation, nil];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    [aLayer addAnimation:animationGroup forKey:@"bounds"];
}


@end
