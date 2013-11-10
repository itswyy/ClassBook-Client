//
//  CBDepthViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-7.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CBDepthViewDelegate;


@interface CBDepthViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, retain)UIView *mianView;
@property (nonatomic, retain)UIView *presentedView;
@property (nonatomic, weak) id<CBDepthViewDelegate> delegate;


- (id)init;
- (CBDepthViewController*)initWithGestureRecognizer:(UIGestureRecognizer*)gesRec;
- (void)presentViewController:(UIViewController*)topViewController inView:(UIView*)bottomView;
- (void)dismissPresentedViewInView:(UIView*)view;
- (void)presentView:(UIView*)topView inView:(UIView*)bottomView;

@end



/**
 * JFDepthViewDelegate Protocol
 */
@protocol CBDepthViewDelegate <NSObject>

@optional

/**
 * JFDepthViewDelegate - willPresentDepthView
 *
 * If you implement this method it will be called immediately
 * before the animation begins to present the view.
 */
- (void)willPresentDepthView:(CBDepthViewController*)depthView;

/**
 * JFDepthViewDelegate - didPresentDepthView
 *
 * If you implement this method it will be called immediately
 * after the animation ends which presented the view.
 */
- (void)didPresentDepthView:(CBDepthViewController*)depthView;

/**
 * JFDepthViewDelegate - willDismissDepthView
 *
 * If you implement this method it will be called immediately
 * before the animation begins to dismiss the view.
 */
- (void)willDismissDepthView:(CBDepthViewController*)depthView;

/**
 * JFDepthViewDelegate - didDismissDepthView
 *
 * If you implement this method it will be called immediately
 * after the animation ends which dismissed the view.
 */
- (void)didDismissDepthView:(CBDepthViewController*)depthView;

@end