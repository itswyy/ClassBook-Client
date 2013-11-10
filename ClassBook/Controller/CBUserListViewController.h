//
//  CBUserListViewController.h
//  ClassBook
//
//  Created by wtlucky on 13-4-18.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPersonViewController;

@interface CBUserListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *classMatesArr;
@property (strong, nonatomic) NSMutableArray *outLineClassMatesArr;
@property (strong, nonatomic) CBPersonViewController *personViewController;


@end
