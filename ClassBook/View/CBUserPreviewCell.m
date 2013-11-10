//
//  CBUserPreviewCell.m
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBUserPreviewCell.h"

@implementation CBUserPreviewCell

@synthesize cellIndexPath = _cellIndexPath;
@synthesize userImageView = _userImageView;
@synthesize userName = _userName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        _userImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:ISDEFAULT_HEAD_MALE]];
        [_userImageView setFrame:CGRectMake(20, 5, 50, 50)];
        [self addSubview:_userImageView];
        
        _userName = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 170, 40)];
        _userName.adjustsFontSizeToFitWidth = NO;
        _userName.font = [UIFont systemFontOfSize:23.0];
        [self addSubview:_userName];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
