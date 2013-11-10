//
//  CBNoteView.h
//  ClassBook
//
//  Created by 小雨 on 13-4-15.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBNoteView;

@protocol CBNoteAnimationDelegate <NSObject>



@end

@interface CBNoteView : UIImageView

@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *msgLable;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, assign) NSInteger tapTime;
@property (nonatomic, assign) CGRect originalRect;
@property (nonatomic, assign) CGAffineTransform originalTransform;
@property (nonatomic, strong) UIFont *originalFont;
@property (nonatomic, strong) UIFont *exchangeFont;
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, assign) BOOL isFirst;
@end
