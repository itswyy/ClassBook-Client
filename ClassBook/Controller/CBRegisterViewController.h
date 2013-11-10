//
//  CBRegisterViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CBRegisterMethodView.h"
#import "CBTopViewController.h"


@interface CBRegisterViewController: UIViewController <CBAddRegisterViewDeleate>

@property (nonatomic, assign)NSInteger registerOption;
@property (nonatomic, retain)IBOutlet UIView *bottomView;
@property(nonatomic, retain)IBOutlet UILabel *protocolLable;
@property(nonatomic, retain)IBOutlet UILabel *methodLale;
@property(nonatomic, retain)IBOutlet UITextField *emailOrTelText;
@property(nonatomic, retain)IBOutlet UITextField *nameText;
@property(nonatomic, retain)IBOutlet UITextField *pswdText;
@property(nonatomic, retain)IBOutlet UITextField *repswdText;
@property(nonatomic, retain)IBOutlet UIButton *cancelButton;
@property(nonatomic, retain)IBOutlet UIButton *sureButton;
@property (nonatomic, retain)IBOutlet UIButton *protocolImage;
@property (nonatomic, retain)IBOutlet UIImageView *checkEoTImage;
@property (nonatomic, retain)IBOutlet UIImageView *checkNameImage;
@property (nonatomic, retain)IBOutlet UIImageView *checkPswdImage;
@property (nonatomic, retain)IBOutlet UIImageView *checkRepswdImage;
@property (nonatomic, assign)BOOL isAgreeProtocol;
@property (nonatomic, retain) UITapGestureRecognizer *res_agreeProtocol;

- (IBAction)checkEmailoPhone:(id)sender;
- (IBAction)checkName:(id)sender;
- (IBAction)checkPswd:(id)sender;
- (IBAction)checkRepswd:(id)sender;
- (IBAction)changeAgreeProtocolImage;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)textFiledReturnEditing:(id)sender;

- (IBAction)upViews:(id)sender;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)sureButtonPressed:(id)sender;

- (IBAction)presentView:(id)sender;
@end
