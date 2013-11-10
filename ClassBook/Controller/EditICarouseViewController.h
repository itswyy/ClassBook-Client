//
//  EditViewController.h
//  UIAnimation
//
//  Created by Admin on 13-2-17.
//
//

#import <UIKit/UIKit.h>
@class Photo;

@interface EditICarouseViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (retain, nonatomic) Photo *photo;
@property (retain, nonatomic) IBOutlet UITextField *imageName;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UITextView *imageIntro;
- (IBAction)saveEdit:(id)sender;
- (IBAction)cancel:(id)sender;

@end
