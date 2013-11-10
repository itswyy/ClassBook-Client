//
//  CBPostitNoteViewController.h
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addNoteDelegate <NSObject>

- (void) refreshBlackBoard;

@end

@interface CBPostitNoteViewController : UIViewController<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    UITextView *textView;
    NSString *dateString;
    UILabel *dateLabel;
}

@property (nonatomic,assign) id<addNoteDelegate>delegateForAdd;
@property (nonatomic ,assign) int groupid;
- (IBAction)saveNote;
- (IBAction)backToBlackboard:(id)sender;
@end
