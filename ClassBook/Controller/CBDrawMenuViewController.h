//
//  CBDrawMenuViewController.h
//  DrawPictures
//
//  Created by Parker on 30/3/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILHuePickerView.h"

@interface CBDrawMenuViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate,
ILHuePickerViewDelegate,
UIAlertViewDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;
@property (weak, nonatomic) IBOutlet UISlider *lineAlphaSlider;
@property (weak, nonatomic) IBOutlet ILHuePickerView *lineColorView;

//待以后改进用
@property (weak, nonatomic) id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> pickerDelegate;
@property (strong , nonatomic) UIColor *lineColor;
@property (copy, nonatomic) NSString *textWords;
@property (strong , nonatomic) UIImage *imageToShow;
//没有必要
@property (assign , nonatomic) float lineWidth;
@property (assign , nonatomic) float lineAlpha;
- (IBAction)widthChange:(UISlider *)sender;
- (IBAction)alphaChange:(UISlider *)sender;

@end
