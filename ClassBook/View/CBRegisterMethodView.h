//
//  CBRegisterMethodView.h
//  ClassBook
//
//  Created by 小雨 on 13-3-6.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBSegmentButtonView.h"

@protocol CBAddRegisterViewDeleate;

@interface CBRegisterMethodView : UIView <CBSegmentButtonDelegate>
@property (nonatomic, retain) id<CBAddRegisterViewDeleate>delegate;
@property (nonatomic, strong) NSArray *segmentButtons;
@end


@protocol CBAddRegisterViewDeleate <NSObject>

- (void)addEmailRegisterView;
- (void)addPhoneRegisterView;

@end