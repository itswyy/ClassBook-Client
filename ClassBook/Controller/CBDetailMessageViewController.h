//
//  CBDetailMessageViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBDetailMessageViewController;

@protocol DetailViewControllerDelegate <NSObject>
//这里是关闭的代理，貌似也可以用通知来实现代理方法
-(void)DetailViewControllerClose:(CBDetailMessageViewController *)detailViewController;
-(void)refreshBlackboardViewForDelete;

@end

@interface CBDetailMessageViewController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UITextView *textView;
    UILabel *dateLabel;
}

@property (nonatomic,assign) id<DetailViewControllerDelegate>delegate;
@property (nonatomic) NSInteger indexNumber;

- (IBAction)backToBlackboard:(id)sender;
@end
