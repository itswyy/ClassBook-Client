//
//  CBDetailSearchView.m
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBDetailSearchView.h"
#import "CBSearchViewController.h"

@interface CBDetailSearchView ()<UIGestureRecognizerDelegate>

@end

@implementation CBDetailSearchView

@synthesize searchBtn = _searchBtn;
@synthesize searchText = _searchText;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(CBSearchViewController *)aDelegate
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = aDelegate;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self formatViews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        //设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBack.png"]];
    }
    return self;
}

- (void)formatViews
{
    _searchText = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, 280, 30)];
    _searchText.placeholder = @"请输入对方的ID";
    _searchText.keyboardType = UIKeyboardTypeNumberPad;
    _searchText.borderStyle = UITextBorderStyleRoundedRect;
    _searchText.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_searchText];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setImage:[UIImage imageNamed:@"u10_normal.png"] forState:UIControlStateNormal];
    [_searchBtn setFrame:CGRectMake(0, 0, 99, 38)];
    [_searchBtn setCenter:CGPointMake(160, 200)];
    [_searchBtn addTarget:self action:@selector(detailSearchBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];

}

- (void)closeKeyboard
{
    [self.searchText resignFirstResponder];
}

- (void)detailSearchBtnTapped:(UIButton *)sender
{
    NSString *userId = [self.searchText text];
    [self.delegate detailSearchWithUserId:userId];
}

//UIGestureRecognizer delegate Method to avoid the tap gensture prevent the UIButton Event
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.searchBtn) {
        return NO;
    }
    return YES;
}



@end
