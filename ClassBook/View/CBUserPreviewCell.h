//
//  CBUserPreviewCell.h
//  ClassBook
//
//  Created by wtlucky on 13-4-16.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBUserPreviewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *cellIndexPath;
@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *userName;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withAddButton:(BOOL)isHaveButton;

@end
