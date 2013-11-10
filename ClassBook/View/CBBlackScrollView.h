//
//  CBBlackScrollView.h
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CBBlackScrollView;

//定义scrollview的代理
@protocol BlackboardViewDelegate <NSObject>

@required
-(void)flipScrollView:(CBBlackScrollView *)flipScroll didSelectAtIndex:(NSInteger)index withLayer:(CALayer *)layer;

@end


@interface CBBlackScrollView : UIScrollView
{
    NSMutableArray *layersArray;
    //layer的数组，用来存放在scrollview中的layer，这里layer是自定义的
    NSInteger selectIndex;
    //确定所选定的layer是第几号，然后在关闭动画中确定动画layer的最终位置
}

@property (nonatomic,assign) id<BlackboardViewDelegate>delegateForBlackboard;
-(void)loadDataForView;
-(void)resetSelection;
-(void)loadViewData;


@end
