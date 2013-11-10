//
//  CBDrawMenuViewController.m
//  DrawPictures
//
//  Created by Parker on 30/3/13.
//  Copyright (c) 2013年 石家庄高新区萤火软件有限公司. All rights reserved.
//

#import "CBDrawMenuViewController.h"
static const int kTextViewTag = 1005;
//因为切割图片之前已经对图片进行了旋转，所以切割的图片是960*720格式
#define rectX 960*1/10    //720/320*70
#define rectY 720*1/10     //1280/480*150
#define rectWidth 960*4/5    //720/320*200
#define rectHeight 720*4/5    //1280/480*230

@interface CBDrawMenuViewController ()
@property (nonatomic , strong) NSMutableArray *dataSource;

/**
 *	获取AlertView中textView的信息
 */
- (void)getTextWordsFromAlertView;

/**
 *	获取照片
 */
- (void)getPhotoes;

/**
 *	从相册中选择图片
 */
- (void)localPhoto;

/**
 *	照相
 */
- (void)takePhoto;


@end

@implementation CBDrawMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@"画笔颜色",@"画笔粗细",@"画笔透明度",@"插入文字",@"插入图片",@"插入声音",nil];
    self.lineAlphaSlider.hidden = YES;
    self.lineWidthSlider.hidden = YES;
    self.lineAlpha = 1;
    self.lineWidth = 10;
    UIColor *c=[UIColor colorWithRed:(arc4random()%100)/100.0f
                               green:(arc4random()%100)/100.0f
                                blue:(arc4random()%100)/100.0f
                               alpha:1.0];
    
    _lineColorView.color=c;
    self.lineColor = self.lineColorView.color;
    self.lineColorView.hidden = NO;
    
    self.lineColorView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]];
    self.menuTableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    // Configure the cell...
    int row = [indexPath row];
    cell.textLabel.text = [self.dataSource objectAtIndex:row];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    int row = [indexPath row];
    switch (row)
    {
        //Color
        case 0:
            self.lineColorView.hidden = NO;
            self.lineAlphaSlider.hidden =YES;
            self.lineWidthSlider.hidden = YES;
            break;
        case 1://Width
            self.lineAlphaSlider.hidden = YES;
            self.lineWidthSlider.hidden = NO;
            self.lineColorView.hidden = YES;
            break;
        case 2://Alpha
            self.lineWidthSlider.hidden = YES;
            self.lineAlphaSlider.hidden = NO;
            self.lineColorView.hidden = YES;
            break;
        case 3://Words
            self.lineAlphaSlider.hidden = YES;
            self.lineWidthSlider.hidden = NO;
            self.lineColorView.hidden = YES;
            
            //获得文本框中输入的文本
            [self getTextWordsFromAlertView];
            break;
        case 4://Picture
            //获取图片
            [self getPhotoes];
            break;
        case 5://voice
            
            break;
        default:
            self.lineAlphaSlider.hidden = YES;
            self.lineWidthSlider.hidden = YES;
            self.lineColorView.hidden = YES;
            break;
    }
}

- (void)viewDidUnload {
    [self setView:nil];
    [self setLineWidthSlider:nil];
    [self setLineAlphaSlider:nil];
    [self setLineColorView:nil];
    [self setMenuTableView:nil];
    [self setLineWidthSlider:nil];
    [self setLineAlphaSlider:nil];
    [self setLineColorView:nil];
    [super viewDidUnload];
}


- (IBAction)widthChange:(UISlider *)sender
{
    self.lineWidth = sender.value;
}


- (IBAction)alphaChange:(UISlider *)sender
{
    self.lineAlpha = sender.value;
}

-(void)huePicked:(float)hue picker:(ILHuePickerView *)picker
{
    self.lineColor = [UIColor colorWithHue: hue
                                saturation: 1.0f
                                brightness: 1.0f
                                     alpha: 1.0];
    self.lineColor = picker.color;
}

#pragma mark - myself methods
/**
 *	获得AlertView中TextView的文本
 */
- (void)getTextWordsFromAlertView

{
    UIAlertView *textAlert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"True",nil];
    CGRect textRect = CGRectMake(10, 20, 220, 100);
    UITextView *textView = [[UITextView alloc] initWithFrame:textRect];
    textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg.jpg"]];
    textView.tag = kTextViewTag;
    [textAlert addSubview:textView];
    [textAlert show];
}

- (void)getPhotoes
{
    UIActionSheet *photoActionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选取照片",@"拍照",nil];
    photoActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [photoActionSheet showInView:self.view];
}
/**
 *	从相册中选择图片
 */
- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类图片为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = _pickerDelegate ;
//    NSLog(@"====== %@",_pickerDelegate);
    picker.editing = YES;
    picker.view.frame = CGRectMake(0, 0, 270, 440);
//    [self presentModalViewController:picker animated:YES];
    if ([_pickerDelegate respondsToSelector:@selector(presentModalViewController:animated:)]) {
        [_pickerDelegate performSelector:@selector(presentModalViewController:animated:) withObject:picker];
    }
}

/**
 *	照相
 */
- (void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = _pickerDelegate;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        picker.cameraOverlayView.frame = CGRectMake(0, 50, 270, 440);
//        [_pickerDelegate presentModalViewController:picker animated:YES];
        if ([_pickerDelegate respondsToSelector:@selector(presentModalViewController:animated:)]) {
            [_pickerDelegate performSelector:@selector(presentModalViewController:animated:) withObject:picker];
        }
    }else {
        NSLog(@"该设备无摄像头");
    }
    
}

#pragma mark - UIAlertView Delegate

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    alertView.frame = CGRectMake(40, 42, 240, 200);
    [alertView setBackgroundColor:[UIColor clearColor]];
    for (UIView *subView in alertView.subviews ) {
        if ([subView isKindOfClass:NSClassFromString(@"UIAlertButton")]) {
            UIButton *button = (UIButton *)subView;
            if (button.tag == 1)
            {
                button.frame = CGRectMake(10, 126, 100, 40);
                [button setTintColor:[UIColor grayColor]];
            }
            else
            {
                button.frame = CGRectMake(130, 126, 100, 40);
                [button setTintColor:[UIColor grayColor]];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        self.textWords = nil;
    }
    else
    {
        //此处要用alertView viewWithTag:才能获取到子视图
        UITextView *textView = (UITextView *)[alertView viewWithTag:kTextViewTag];
        self.textWords = textView.text;
//        NSLog(@"hello world = %@",self.textWords);
    }
}

#pragma mark - UIActionDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self localPhoto];
            break;
        case 1:
            [self takePhoto];
            break;
        default:
            break;
    }
}
//#pragma mark - UIImagePickerControllerDelegate
//#pragma Delegate method UIImagePickerControllerDelegate
////图像选取器的委托方法，选完图片后回调该方法
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    
//    //当图片不为空时显示图片并保存图片
//    if (image != nil) {
//        //把图片转成NSData类型的数据来保存文件
//        NSData *data;
//        //判断图片是不是png格式的文件
//        if (UIImagePNGRepresentation(image)) {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }else {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 1.0);
//        }
//        self.imageToShow = [UIImage imageWithData:data];
//        
//    }
//    //关闭相册界面
//    [picker dismissModalViewControllerAnimated:YES];
//}

@end
