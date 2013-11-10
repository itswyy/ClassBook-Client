//
//  CBLoginViewController.h
//  ClassBook
//
//  Created by wtlucky on 13-3-3.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *pswLable;
@property (weak, nonatomic) IBOutlet UITextField *loginText;
@property (weak, nonatomic) IBOutlet UITextField *pswText;
@property (weak, nonatomic) IBOutlet UILabel *regestLable;

@property (nonatomic, retain) UITapGestureRecognizer *regestGesture;

- (void)loginByLoginID:(NSString *)aLoginID andPassword:(NSString *)aPassword;

@end
