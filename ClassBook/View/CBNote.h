//
//  CBNote.h
//  ClassBook
//
//  Created by 小雨 on 13-4-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBNote;

@protocol CBNoteDelega <NSObject>

- (void)gotoDetail:(CBNote *)aNote;

@end 


@interface CBNote : UIView

@property (nonatomic , strong) UITextView *textView;
@property (nonatomic , strong) UIImage *backgroundImage;
@property (nonatomic , strong) id delegate;

- (id)initWithBackgroundImage:(UIImage *)image text:(NSString*)text delegate:(id)aDel;

@end
