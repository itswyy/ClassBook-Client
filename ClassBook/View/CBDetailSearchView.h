//
//  CBDetailSearchView.h
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBSearchViewController;

@interface CBDetailSearchView : UIView

@property (strong, nonatomic) UITextField *searchText;
@property (strong, nonatomic) UIButton *searchBtn;
@property (weak, nonatomic) CBSearchViewController *delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(CBSearchViewController *)aDelegate;

- (void)closeKeyboard;

@end
