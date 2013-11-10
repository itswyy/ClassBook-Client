//
//  CBGroupIconView.m
//  ClassBook
//
//  Created by wtlucky on 13-4-11.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBGroupIconView.h"

@implementation CBGroupIconView

@synthesize groupName = _groupName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFootType:(NSInteger)index
{
    if (self = [super init]) {
        [self setFrame:CGRectMake(0, 0, 100, 100)];
        
        switch (index) {
            case 0:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"xiaoxue.png"]]];
                break;
            case 1:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"chuzhong.png"]]];
                break;
            case 2:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gaozhong.png"]]];
                break;
            case 3:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"daxue.png"]]];
                break;
            case 4:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"haoyou.png"]]];
                break;
            default:
                [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"haoyou.png"]]];
                break;

        }
        
        
//        //设置组名
//        _groupName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 52, 52)];
//        [_groupName setCenter:self.center];
//        _groupName.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:20];
//        [_groupName setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:_groupName];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
