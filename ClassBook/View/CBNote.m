//
//  CBNote.m
//  ClassBook
//
//  Created by 小雨 on 13-4-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBNote.h"

@implementation CBNote
@synthesize backgroundImage;
@synthesize textView;
@synthesize delegate;

- (id)initWithBackgroundImage:(UIImage *)image text:(NSString*)text delegate:(id)aDel
{
    if (self = [super init]) {
        UIImageView *back = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50,50)];
        self.backgroundImage = image;
        back.image = self.backgroundImage;
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        self.textView.font = [UIFont fontWithName:@"宋体" size:4];
        self.textView.text = text;
        self.textView.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        [back addSubview:textView];
        [self addSubview:back];
        
        self.delegate = aDel;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(gotoDetail:)]) {
        [self.delegate gotoDetail:self];
    }
}

@end
