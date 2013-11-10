//
//  CBSegmentButtonView.h
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBSegmentButtonDelegate;
@interface CBSegmentButtonView : UIView

- (CBSegmentButtonView *)initWithTitle:(NSString *)title
                           normalImage:(UIImage *)normalImage
                        highlightImage:(UIImage *)highlightImage
                              delegate:(id <CBSegmentButtonDelegate>)delegate;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end

@protocol CBSegmentButtonDelegate <NSObject>

- (void)segmentButtonHighlighted:(CBSegmentButtonView *)highlightedSegmentButton;

@end