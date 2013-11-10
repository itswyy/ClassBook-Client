//
//  EditViewController.m
//  UIAnimation
//
//  Created by Admin on 13-2-17.
//
//

#import "EditICarouseViewController.h"
#import "Photo.h"
#import "ImageStore.h"

@interface EditICarouseViewController ()

@end

@implementation EditICarouseViewController

@synthesize photo = _photo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_imageName setText:_photo.name];
    [_imageIntro setText:_photo.info];
    
    NSString *imageKey = [_photo imagekey];
    if (imageKey) {
        UIImage * image = [[ImageStore defaultImageStore]imageForKey:imageKey];
        [_imageView setImage:image];
    }
    else
    {
        [_imageView setImage:nil];
    }
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：保存更改
 ****************************************/
- (IBAction)saveEdit:(id)sender {
    
    [_photo setName:[_imageName text]];
    [_photo setInfo:[_imageIntro text]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*****************************************
 *函数名：
 *参数：
 *返回值：
 *功能：取消编辑
 ****************************************/
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_imageName release];
    [_imageView release];
    [_imageIntro release];
    [_photo release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageName:nil];
    [self setImageView:nil];
    [self setImageIntro:nil];
    [self setPhoto:nil];
    [super viewDidUnload];
}

#pragma mark -- textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect newFrame = textView.frame;
    newFrame.origin.y = 70;
    textView.frame = newFrame;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    CGRect newFrame = textView.frame;
    newFrame.origin.y = 312;
    textView.frame = newFrame;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if ([text isEqualToString:@"\n"])
    {
        //这里隐藏键盘，不做任何处理
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
@end
