//
//  CBViewControllerTwo.h
//  GMGridDemoTwo
//
//  Created by Admin on 13-3-6.
//  Copyright (c) 2013年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGroupViewController : UIViewController

@property(nonatomic,assign)int group_id;

@property(nonatomic,strong)NSMutableArray * personAr;//该分组的所有用户

@end
