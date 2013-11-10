//
//  CBPersonalDetailViewController.h
//  ClassBook
//
//  Created by Parker on 16/4/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPersonalDetailViewController : UIViewController<UITextFieldDelegate>

@property (strong ,nonatomic) UITableView *detailTableView;
@property (strong ,nonatomic) NSDictionary *personalDetailDic;
@property (strong ,nonatomic) NSArray *dataSource;
@property (strong ,nonatomic) NSMutableDictionary *valueDic;
@property (strong ,nonatomic) UIImage *imageToSave;
@end
