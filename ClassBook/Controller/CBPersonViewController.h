//
//  CBPersonViewController.h
//  ClassBook
//
//  Created by Admin on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPersonViewController : UIViewController

@property(nonatomic,assign)int user_id; //用户ID

@property(nonatomic,strong)NSDictionary * userInfoDic; //用户的信息

@end
