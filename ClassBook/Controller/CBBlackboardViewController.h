//
//  CBBlackboardViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBBlackScrollView.h"
#import "CBInScrollViewLayer.h"
#import "CBDetailMessageViewController.h"
#import "CBPostitNoteViewController.h"
#import "CBNoteView.h"

@interface CBBlackboardViewController : UIViewController

@property (nonatomic, retain)NSMutableArray *notesArray;
@property (nonatomic, retain)NSMutableArray *positionArray;
@property (nonatomic, retain)NSMutableArray *blackboardArray;
@property (nonatomic, assign)NSInteger theCurrentBlackboardIndex;
@property (nonatomic, retain)UIImageView *theCurrentNote;

@property (nonatomic, retain)IBOutlet UIButton *nextBlack;
@property (nonatomic, retain)IBOutlet UIButton *priorBlack;
@property (nonatomic, retain)IBOutlet UIButton *close;
@property (nonatomic, retain)IBOutlet UIButton *add;

//Modified by itswyy
@property (nonatomic, assign) int groupid;

- (IBAction)addNewMessage:(id)sender;
- (IBAction)backToGroupViewController:(id)sender;

//小黑板翻页
- (IBAction)gotoNextBlackboard:(id)sender;
- (IBAction)backtoPriorBlackboard:(id)sender;

//前往细节note
- (IBAction)jumpToDetailNote:(id)sender;
@end
