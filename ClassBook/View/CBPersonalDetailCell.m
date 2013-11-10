//
//  CBPersonalDetailCell.m
//  CBPersonalDetail
//
//  Created by Parker on 16/4/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import "CBPersonalDetailCell.h"

@implementation CBPersonalDetailCell

- (void)configeCell
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]];
    CGRect imageViewRect = CGRectMake(14, 4, 24, 22);
    CGRect myLableRect = CGRectMake(45, 4, 94, 22);
    CGRect textViewRect = CGRectMake(136, 2, 164, 27);
    self.myImageView = [[UIImageView alloc] initWithFrame:imageViewRect];
    self.myImageView.backgroundColor = [UIColor clearColor];
    
    self.myLable = [[UILabel alloc] initWithFrame:myLableRect];
    self.myLable.font = [UIFont systemFontOfSize:13.0];
    self.myLable.backgroundColor = [UIColor clearColor];
    
    self.myTextView = [[UITextView alloc] initWithFrame:textViewRect];
    self.myTextView.font = [UIFont systemFontOfSize:13.0];
    self.myTextView.textAlignment = NSTextAlignmentCenter;
    self.myTextView.backgroundColor = [UIColor clearColor];
    self.myTextView.returnKeyType  = UIReturnKeyDone;
    self.myTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [self addSubview:self.myImageView];
    [self addSubview:self.myLable];
    [self addSubview:self.myTextView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self configeCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}



@end
