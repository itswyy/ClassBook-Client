//
//  CBSearchViewController.h
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBDetailSearchView, CBConditionSearchView;

@interface CBSearchViewController : UIViewController

@property (strong, nonatomic) UISegmentedControl *searchSegment;
@property (strong, nonatomic) CBDetailSearchView *detailView;
@property (weak, nonatomic) IBOutlet CBConditionSearchView *conditionView;

- (void)detailSearchWithUserId:(NSString *)aUserID;
- (void)conditionSearchWith:(NSString *)aKey andValue:(NSString *)aValue;

@end
