//
//  CBConditionSearchView.m
//  ClassBook
//
//  Created by wtlucky on 13-4-17.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBConditionSearchView.h"
#import "CBSearchViewController.h"

@interface CBConditionSearchView ()<UIGestureRecognizerDelegate, UITextFieldDelegate>

@end

@implementation CBConditionSearchView

@synthesize searchNameText = _searchNameText;
@synthesize searchEmailText = _searchEmailText;
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
//        [self setBackgroundColor:[UIColor whiteColor]];
//        [self formatViews];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
//        tap.delegate = self;
//        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)formatViewsAndSetDelegate:(CBSearchViewController *)aDelegate
{
//    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 42, 21)];
//    nameLbl.text = @"昵称";
//    UILabel *ageLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 42, 21)];
//    ageLbl.text = @"年龄";
//    UILabel *sexLbl = [[UILabel alloc]initWithFrame:CGRectMake(150, 60, 42, 21)];
//    sexLbl.text = @"性别";
//    UILabel *constellationLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 98, 42, 21)];
//    constellationLbl.text = @"星座";
//    UILabel *bloodTypeLbl = [[UILabel alloc]initWithFrame:CGRectMake(150, 98, 42, 21)];
//    bloodTypeLbl.text = @"血型";
    
//    _searchNameText = [[UITextField alloc]initWithFrame:CGRectMake(20, 40, 280, 30)];
    _searchNameText.placeholder = @"请输入对方的昵称";
    _searchNameText.keyboardType = UIKeyboardTypeDefault;
    _searchNameText.borderStyle = UITextBorderStyleRoundedRect;
    _searchNameText.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:_searchNameText];
    
    _searchEmailText.placeholder = @"请输入对方的电话号码";
    _searchEmailText.keyboardType = UIKeyboardTypeNumberPad;
    _searchEmailText.borderStyle = UITextBorderStyleRoundedRect;
    _searchEmailText.adjustsFontSizeToFitWidth = YES;
    _searchEmailText.delegate = self;
//    [self addSubview:_searchEmailText];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setImage:[UIImage imageNamed:@"u10_normal.png"] forState:UIControlStateNormal];
    [_searchBtn setFrame:CGRectMake(0, 0, 99, 38)];
    [_searchBtn setCenter:CGPointMake(160, 260)];
    [_searchBtn addTarget:self action:@selector(conditionSearchBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
    
    self.delegate = aDelegate;
    [self setBackgroundColor:[UIColor whiteColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //设置背景
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBack.png"]];
    
}

- (void)closeKeyboard
{
    [self.searchEmailText resignFirstResponder];
    [self.searchNameText resignFirstResponder];
    [[self viewWithTag:11] resignFirstResponder];
    [[self viewWithTag:22] resignFirstResponder];
    [[self viewWithTag:33] resignFirstResponder];
    [[self viewWithTag:44] resignFirstResponder];
}

- (void)conditionSearchBtnTapped:(UIButton *)sender
{
    if (nil == self.searchNameText.text) {
        [self.delegate conditionSearchWith:@"tel_num" andValue:self.searchEmailText.text];
    }
    [self.delegate conditionSearchWith:@"name" andValue:self.searchNameText.text];
}

//UIGestureRecognizer delegate Method to avoid the tap gensture prevent the UIButton Event
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.searchBtn) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        [self setCenter:CGPointMake(self.center.x, self.center.y - 15)];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        [self setCenter:CGPointMake(self.center.x, self.center.y + 15)];
    }];
}


@end
