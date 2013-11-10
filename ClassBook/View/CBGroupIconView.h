//
//  CBGroupIconView.h
//  ClassBook
//
//  Created by wtlucky on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBGroupIconView : UIView

@property (strong, nonatomic) UILabel *groupName;

- (id)initWithFootType:(NSInteger)index;

@end
