//
//  CBProgressHUD.h
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "MBProgressHUD.h"

@interface CBProgressHUD : MBProgressHUD

- (void)showActivityTypeHUDViewWithText:(NSString *)aText;
- (void)showTextTypeHUDViewWithText:(NSString *)aText;

@end
