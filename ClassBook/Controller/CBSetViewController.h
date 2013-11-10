//
//  CBSetViewController.h
//  ClassBook
//
//  Created by Admin on 13-3-30.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBSetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain)NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *iconList;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
