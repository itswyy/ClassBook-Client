//
//  CBDepthViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-7.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBDepthViewController.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration  0.5
#define kPresentedViewWidth 280
#define kDefaultBlurAmount  0.2f

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

@implementation UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

@end


@interface CBDepthViewController (){
     CGRect preTopViewWrapperFrame;
     CGRect postTopViewWrapperFrame;
     CGRect preBottomViewFrame;
     CGRect postBottomViewFrame;
     CGRect bottomViewFrame;
}

@property (nonatomic, strong) UIView* topViewWrapper;
@property (nonatomic, strong) UIView* dimView;
@property (nonatomic, strong) UIImageView* blurredMainView;
@property (nonatomic, strong) UIGestureRecognizer* recognizer;
@property (nonatomic, strong) UIView* presentedViewContainer;
@property (nonatomic, strong) UIImage* viewImage;
@property (nonatomic, strong) UIViewController* presentedViewController;
@end

@implementation CBDepthViewController
@synthesize presentedViewController = _presentedViewController;
@synthesize mianView;
@synthesize presentedView;

- (CBDepthViewController *)init
{
    @throw [NSException exceptionWithName:@"CBDepthView Invalid Initialization"
                                   reason:@"CBDepthView must be initialized using initWithGestureRecognizer:"
                                 userInfo:nil];
    return nil;
}

- (CBDepthViewController*)initWithGestureRecognizer:(UIGestureRecognizer*)gesRec {
    if (self = [super init]) {
        NSLog(@"CBDepthView Initialized!");
        
        self.recognizer = gesRec;
    }
    return self;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *	将弹出视图显示出来
 *
 *	@param 	topViewController 	要显示的弹出视图的controller
 *	@param 	bottomView 	弹出的视图在哪个视图上显示
 */
- (void)presentViewController:(UIViewController*)topViewController inView:(UIView*)bottomView {
    self.presentedViewController = topViewController;
    [self presentView:self.presentedViewController.view inView:bottomView];
}

/**
 *	显示弹出试图
 *
 *	@param 	topView 	弹出视图
 *	@param 	bottomView 	弹出的视图在哪个视图上显示
 */

- (void)presentView:(UIView*)topView inView:(UIView*)bottomView {
    
    NSParameterAssert(topView);
    NSParameterAssert(bottomView);
    
    self.mianView      = bottomView;
    self.presentedView = topView;
    
    //clipsToBounds决定子视图显示范围，就是当取值为YES时，剪裁超出父视图范围的子视图部分
    //autoresizesMask自动调整子控件与父控件中间的位置，宽高
    self.presentedView.clipsToBounds = YES;
    self.presentedView.autoresizesSubviews = YES;
    self.presentedView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    self.presentedView.layer.cornerRadius  = 8;
    
    bottomViewFrame        = self.mianView.bounds;
    NSLog(@"bottomViewFrame:%f--%f--%f--%f",bottomViewFrame.origin.x,bottomViewFrame.origin.y,bottomViewFrame.size.width,bottomViewFrame.size.height);
    CGRect topViewFrame    = self.presentedView.bounds;
    NSLog(@":topViewFrame:%f--%f--%f--%f",topViewFrame.origin.x,topViewFrame.origin.y,topViewFrame.size.width,topViewFrame.size.height);
    CGRect newTopViewFrame = CGRectMake(topViewFrame.origin.x,
                                        topViewFrame.origin.y,
                                        kPresentedViewWidth,
                                        topViewFrame.size.height);
    NSLog(@"newTopViewFrame:%f--%f--%f--%f",newTopViewFrame.origin.x,newTopViewFrame.origin.y,newTopViewFrame.size.width,newTopViewFrame.size.height);
    self.presentedView.frame = newTopViewFrame;
    
    self.view.frame = bottomViewFrame;
    self.view.backgroundColor = [UIColor blackColor];
    
    preTopViewWrapperFrame = CGRectMake((bottomViewFrame.size.width / 2) - 130,
                                        bottomViewFrame.size.height + bottomViewFrame.origin.y,
                                        kPresentedViewWidth,
                                        bottomViewFrame.size.height - 100);
    NSLog(@"preTopViewWrapperFrame:%f--%f--%f--%f",preTopViewWrapperFrame.origin.x,preTopViewWrapperFrame.origin.y,preTopViewWrapperFrame.size.width,preTopViewWrapperFrame.size.height);
    
    postTopViewWrapperFrame = CGRectMake((bottomViewFrame.size.width / 2) - 130,
                                         40,
                                         kPresentedViewWidth,
                                         bottomViewFrame.size.height - 100);
    NSLog(@"postTopViewWrapperFrame:%f--%f--%f--%f",postTopViewWrapperFrame.origin.x,postTopViewWrapperFrame.origin.y,postTopViewWrapperFrame.size.width,postTopViewWrapperFrame.size.height);
    preBottomViewFrame = bottomViewFrame;
    
    postBottomViewFrame = CGRectMake(50,
                                     0,
                                     bottomViewFrame.size.width - 100,
                                     bottomViewFrame.size.height - 100);
    NSLog(@"postBottomViewFrame:%f--%f--%f--%f",postBottomViewFrame.origin.x,postBottomViewFrame.origin.y,postBottomViewFrame.size.width,postBottomViewFrame.size.height);
    
    self.topViewWrapper = [[UIView alloc] initWithFrame:preTopViewWrapperFrame];
    self.topViewWrapper.autoresizesSubviews = YES;
    //shadowOffset shadow 在 X 和 Y 轴 上延伸的方向，即 shadow 的大小
    //shadowRadius shadow 的渐变距离，从外围开始，往里渐变 shadowRadius 距离
    //shadowPath : 设置 CALayer 背景(shodow)的位置
    //shadowOpacity : shadow 的透明效果
    self.topViewWrapper.layer.shadowOffset  = CGSizeMake(0, 0);
    self.topViewWrapper.layer.shadowRadius  = 20;
    self.topViewWrapper.layer.shadowOpacity = 1.0;
    self.topViewWrapper.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.topViewWrapper.bounds].CGPath;
    self.topViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   |
    UIViewAutoresizingFlexibleBottomMargin|
    UIViewAutoresizingFlexibleHeight;
    
    self.presentedViewContainer = [[UIView alloc] initWithFrame:bottomViewFrame];
    self.presentedViewContainer.autoresizesSubviews = YES;
    self.presentedViewContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin   |
    UIViewAutoresizingFlexibleBottomMargin|
    UIViewAutoresizingFlexibleHeight      |
    UIViewAutoresizingFlexibleWidth;
    
    UIGraphicsBeginImageContext(self.mianView.bounds.size);
    [self.mianView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.blurredMainView = [[UIImageView alloc] initWithFrame:preBottomViewFrame];
    self.blurredMainView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |
    UIViewAutoresizingFlexibleRightMargin ;
    
    self.blurredMainView.image = [self getBlurredImage];
    
    self.dimView = [[UIView alloc] initWithFrame:bottomViewFrame];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = 0.0;
    [self.dimView addGestureRecognizer:self.recognizer];
    self.dimView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    [self.topViewWrapper addSubview:self.presentedView];
    [self.presentedViewContainer addSubview:self.blurredMainView];
    [self.presentedViewContainer addSubview:self.dimView];
    [self.view addSubview:self.presentedViewContainer];
    [self.view addSubview:self.topViewWrapper];
    
    [self hideSubviews];
    
    [self.mianView addSubview:self.view];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentDepthView:)]) {
        [self.delegate willPresentDepthView:self];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.topViewWrapper.frame  = postTopViewWrapperFrame;
        self.blurredMainView.frame = postBottomViewFrame;
        self.dimView.alpha         = 0.4;
    }
                     completion:^(BOOL finished){
                         NSLog(@"Present Animation Complete");
                         
                         if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentDepthView:)]) {
                             [self.delegate didPresentDepthView:self];
                         }
                     }];
}


/**
 *	将弹出的视图退出
 *
 *	@param 	view 	弹出试图的夫视图
 */
- (void)dismissPresentedViewInView:(UIView*)view {
    if ([self.mianView isEqual:view]) {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.topViewWrapper.frame  = preTopViewWrapperFrame;
            self.blurredMainView.frame = preBottomViewFrame;
            self.dimView.alpha         = 0.0;
        }
                         completion:^(BOOL finished){
                             NSLog(@"Dismiss Animation Complete");
                             
                             [self showSubviews];
                             
                             [self.dimView                removeFromSuperview];
                             [self.blurredMainView        removeFromSuperview];
                             [self.presentedViewContainer removeFromSuperview];
                             [self.presentedView          removeFromSuperview];
                             [self.topViewWrapper         removeFromSuperview];
                             [self.view                   removeFromSuperview];
                             
                             [self.view.layer                   removeAllAnimations];
                             [self.presentedView.layer          removeAllAnimations];
                             [self.presentedViewContainer.layer removeAllAnimations];
                             [self.topViewWrapper.layer         removeAllAnimations];
                             [self.blurredMainView.layer        removeAllAnimations];
                             [self.dimView.layer                removeAllAnimations];
                             
                             self.presentedViewContainer = nil;
                             self.mianView        = nil;
                             self.dimView         = nil;
                             self.blurredMainView = nil;
                             self.topViewWrapper  = nil;
                             self.viewImage       = nil;
                             self.presentedView   = nil;
                         }];
    }
}

- (UIImage*)getBlurredImage {
    NSData *imageData = UIImageJPEGRepresentation(self.viewImage, 1);     UIImage* image = [UIImage imageWithData:imageData];
    return [image boxblurImageWithBlur:kDefaultBlurAmount];
}

- (void)hideSubviews {
    for (UIView* subview in self.mianView.subviews) {
        if (subview) {
            subview.hidden = YES;
        }
    }
}

- (void)showSubviews {
    for (UIView* subview in self.mianView.subviews) {
        if (subview) {
            subview.hidden = NO;
        }
    }
}

@end


