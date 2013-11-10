//
//  CBHomeViewController.h
//  ClassBook
//
//  Created by wtlucky on 13-4-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBHomeBackView.h"

@interface CBHomeViewController : UIViewController<CBHomeBackViewDelegate, CBHomeBackViewDataSource>


@property (strong, nonatomic) CBHomeBackView *backgroundView;
@property (strong, nonatomic) NSMutableArray *userGroupsArr;


@end
