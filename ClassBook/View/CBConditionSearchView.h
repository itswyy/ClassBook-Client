//
//  CBConditionSearchView.h
//  ClassBook
//
//  Created by wtlucky on 13-4-17.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBSearchViewController;

@interface CBConditionSearchView : UIView

@property (strong, nonatomic) IBOutlet UITextField *searchNameText;
@property (strong, nonatomic) IBOutlet UITextField *searchEmailText;
@property (strong, nonatomic) UIButton *searchBtn;
@property (weak, nonatomic) CBSearchViewController *delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(CBSearchViewController *)aDelegate;

- (void)formatViewsAndSetDelegate:(CBSearchViewController *)aDelegate;

- (void)closeKeyboard;

@end
