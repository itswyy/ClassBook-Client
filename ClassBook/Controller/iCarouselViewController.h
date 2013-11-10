//
//  AppDelegate.m
//  UIAnimation
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface  iCarouselViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *imagePickerPopover;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;   //中间显示图片的视图
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;   //下方的工具栏

@property (retain, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic,assign) BOOL wrap;
@property (nonatomic, retain) NSNumber * groupId;  //分组id

- (IBAction)switchCarouselType;
- (IBAction)toggleWrap;
- (IBAction)removeImage:(id)sender;
- (IBAction)addImage:(id)sender;
- (IBAction)editImage:(id)sender;


@end
