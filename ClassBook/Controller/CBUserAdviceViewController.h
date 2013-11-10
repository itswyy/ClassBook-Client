//
//  CBUserAdviceViewController.h
//  ClassBook
//
//  Created by Admin on 13-4-12.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesView.h"

@interface CBUserAdviceViewController : UIViewController<LeavesViewDataSource, LeavesViewDelegate>
{
	NSArray *AdviceImagesAr;
    LeavesView *leavesView;
}
@property(nonatomic,assign)int user_id;
@property(nonatomic,strong)NSMutableArray * advices;
@end
