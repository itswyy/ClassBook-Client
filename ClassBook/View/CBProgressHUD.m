//
//  CBProgressHUD.m
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBProgressHUD.h"

@implementation CBProgressHUD

- (void)showActivityTypeHUDViewWithText:(NSString *)aText
{
    self.animationType = MBProgressHUDAnimationFade;
    self.labelText = aText;
    self.mode = MBProgressHUDModeIndeterminate;
    self.margin = 20.f;
    self.yOffset = 0;
    self.labelFont = [UIFont boldSystemFontOfSize:16];
    [self show:YES];
}

- (void)showTextTypeHUDViewWithText:(NSString *)aText
{
    self.mode = MBProgressHUDModeText;
    self.labelText = aText;
    self.labelFont = [UIFont systemFontOfSize:10];
    self.yOffset = 150.f;
    self.margin = 10.f;
    [self show:YES];
    [self hide:YES afterDelay:1.5];
}

@end
