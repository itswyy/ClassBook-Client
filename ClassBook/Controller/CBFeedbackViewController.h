//
//  CBFeedbackViewController.h
//  ClassBook
//
//  Created by wtlucky on 13-4-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFeedbackViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
