//
//  AppDelegate.m
//  UIAnimation
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "iCarouselViewController.h"
#import "PhotoStore.h"
#import "Photo.h"
#import "ImageStore.h"
#import "FileHelpers.h"
#import "EditICarouseViewController.h"
#define ITEM_SPACING 200

@implementation iCarouselViewController

@synthesize carousel;
@synthesize navItem;
@synthesize wrap;
@synthesize groupId;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        wrap = YES;
    }
    
    return self;
}

- (void)dealloc
{
    [carousel release];
    [navItem release];
    [groupId release];
    [_toolBar release];
    [super dealloc];
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    carousel.delegate = self;
    carousel.dataSource = self;

    carousel.type = iCarouselTypeCoverFlow;
    navItem.title = @"分组相册";
    
}

- (void)viewDidUnload
{
    [self setToolBar:nil];
    [self setDeleteButton:nil];
    [self setAddButton:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
    
    self.carousel = nil;
    self.navItem = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[PhotoStore defaultStore] saveChanges];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)switchCarouselType
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌", nil];
//    [sheet showInView:self.view];
//    [sheet release];
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：是否循环显示
 ****************************************/
- (IBAction)toggleWrap
{
    wrap = !wrap;
    navItem.rightBarButtonItem.title = wrap? @"边界:ON": @"边界:OFF";
    [carousel reloadData];
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：删除图片
 ****************************************/
- (IBAction)removeImage:(id)sender {

    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定删除图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex == 1) {
        Photo * currentPhoto = [[[PhotoStore defaultStore]allPhotosForGroupId:[self.groupId integerValue]] objectAtIndex:carousel.currentItemIndex];
        [[PhotoStore defaultStore]removePhoto:currentPhoto];
        
        [carousel reloadData];
    }
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：添加图片   -- 照相机
 ****************************************/
- (IBAction)addImage:(id)sender {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    // Place image picker on the screen
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc]
                              initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller, sender
        // is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self presentModalViewController:imagePicker animated:YES];
    }
    
    // The image picker will be retained by ItemDetailViewController
    // until it has been dismissed
    [imagePicker release];
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    Photo * newPhoto = [[PhotoStore defaultStore]createPhotoForGroupId:[self.groupId integerValue]];
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    
    // Store image in the ImageStore with this key
    [[ImageStore defaultImageStore] setImage:image
                                      forKey:[newPhoto imagekey]];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [imagePickerPopover dismissPopoverAnimated:YES];
        [imagePickerPopover autorelease];
        imagePickerPopover = nil;
    }
    
    [carousel reloadData];
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePickerPopover autorelease];
    imagePickerPopover = nil;
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：编辑图片
 ****************************************/
- (IBAction)editImage:(id)sender {
    //modal
    NSLog(@"%d",carousel.currentItemIndex);
}

/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：  响应Segue跳转
 ****************************************/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editImage"]) {
        Photo * currentPhoto = [[[PhotoStore defaultStore]allPhotosForGroupId:[self.groupId integerValue]] objectAtIndex:carousel.currentItemIndex];
        EditICarouseViewController * editView = (EditICarouseViewController *)segue.destinationViewController;
        editView.photo = currentPhoto;
    }
}

//#pragma mark - iCarousel delegate
//
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    for (UIView *view in carousel.visibleItemViews)
//    {
//        view.alpha = 1.0;
//    }
//    
//    [UIView beginAnimations:nil context:nil];
//    carousel.type = buttonIndex;
//    [UIView commitAnimations];
//    
//    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
//}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    int count = [[[PhotoStore defaultStore]allPhotosForGroupId:[self.groupId integerValue]] count];
    if (count == 0) {
        [_editButton setEnabled:NO];
        [_deleteButton setEnabled:NO];
    }
    else
    {
        [_editButton setEnabled:YES];
        [_deleteButton setEnabled:YES];
    }
    return count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    NSArray * photos = [[PhotoStore defaultStore]allPhotosForGroupId:[self.groupId integerValue]];
    NSString * path = pathInDocumentDirectory([[photos objectAtIndex:index]imagekey]);
    UIView *view = [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]] autorelease];
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}


- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger num  = [[[PhotoStore defaultStore]allPhotosForGroupId:[self.groupId integerValue]] count];
    if (num<3) {
        return 1;
    }
    return num;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

@end
