//
//  CBPersonalDetailCell.h
//  CBPersonalDetail
//
//  Created by Parker on 16/4/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPersonalDetailCell : UITableViewCell
<UITextViewDelegate>
@property (strong ,nonatomic) UIImageView *myImageView;
@property (strong ,nonatomic) UILabel *myLable;
@property (strong ,nonatomic) UITextView *myTextView;

@end
