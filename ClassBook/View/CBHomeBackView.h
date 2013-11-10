//
//  CBHomeBackView.h
//  ClassBook
//
//  Created by wtlucky on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBGroupIconView.h"

@protocol CBHomeBackViewDelegate <NSObject>

- (void)groupDidTapedAtIndex:(NSInteger)aIndex;

@end

@protocol CBHomeBackViewDataSource <NSObject>

- (NSInteger)numberOfGroups;
- (CBGroupIconView *)viewAtIndex:(NSInteger)aIndex;

@end


@interface CBHomeBackView : UIScrollView<UIScrollViewDelegate>

@property (weak, nonatomic) id<CBHomeBackViewDelegate> cbDegelate;
@property (weak, nonatomic, setter = setDatasource:) id<CBHomeBackViewDataSource> dataSource;
@property (assign, nonatomic) NSInteger groupCount;

- (void)reloadData;
- (void)groupViewDidTaped:(UIGestureRecognizer *)gesture;

@end
