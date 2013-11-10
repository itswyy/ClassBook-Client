//
//  CBSetPersonalInfoController.m
//  ClassBook
//
//  Created by Admin on 13-4-19.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBSetPersonalInfoController.h"
#import "ImageStore.h"

#define DefaultImage @"t_1.png"

@interface CBSetPersonalInfoController ()
<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    float offSet; //临时变量
    NSArray * headerKeys; //临时变量
}

@end

@implementation CBSetPersonalInfoController

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
    
    self.title = @"个人信息";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.detailTableView.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - 60);
    
    self.detailTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.detailTableView];
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.separatorColor = [UIColor clearColor];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SetPersonalInfoMenu" ofType:@"plist"];
    self.dataSource = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    //设置背景
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBack.png"]];
    
    //定制导航栏后退按钮
    [[CBCommonFunction sharedInstance]setNavigationBackBarBtn:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenBg2.jpg"]];
}

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerSuperView = [[UIView alloc] init];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(44 , 15, 77, 81)];
    
    [imageView setImage:[[ImageStore defaultImageStore] imageForKey:[[CBCurrentUser currentUser] head_portrait]]];
    if (imageView.image == nil) {
        
        if ([[CBCurrentUser currentUser] sex] == 1) {
            imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_MALE];
        }
        else
        {
            imageView.image = [UIImage imageNamed:ISDEFAULT_HEAD_FEMALE];
        }
        [imageView setImage:[UIImage imageNamed:DefaultImage]];
    }
    [headerSuperView addSubview:imageView];
    
    headerKeys = [[NSArray alloc]initWithObjects:@"name",@"sex",@"age",@"bloodtype",@"race", nil];
    
    UITextField * name = [[UITextField alloc]initWithFrame:CGRectMake(155, 24, 128, 21)];
    name.text = [[CBCurrentUser currentUser] name];
    name.delegate = self;
    name.tag = 100;
    [headerSuperView addSubview:name];
    
    UITextField * sex = [[UITextField alloc]initWithFrame:CGRectMake(161, 55, 30, 25)];
    sex.text = [[CBCurrentUser currentUser] sex] == 0 ? @"女":@"男";
    sex.delegate = self;
    sex.tag = 101;
    [headerSuperView addSubview:sex];
    
    UITextField * age = [[UITextField alloc]initWithFrame:CGRectMake(217, 55, 71, 25)];
    age.text = @"22岁";
    age.delegate = self;
    age.tag = 102;
    [headerSuperView addSubview:age];
    
    UITextField * bloodtype = [[UITextField alloc]initWithFrame:CGRectMake(161, 75, 40, 25)];
    bloodtype.text = [[CBCurrentUser currentUser] bloodtype];
    if ([bloodtype.text isEqualToString:@"<null>"]) {
        bloodtype.text = @"";
        bloodtype.placeholder = @"血型";
    }
    bloodtype.delegate = self;
    bloodtype.tag = 103;
    [headerSuperView addSubview:bloodtype];
    
    UITextField * race = [[UITextField alloc]initWithFrame:CGRectMake(217, 75, 71, 25)];
    race.text = [[CBCurrentUser currentUser] race];
    race.text = [[CBCurrentUser currentUser] race];
    if ([race.text isEqualToString:@"<null>"]) {
        race.text = @"";
        race.placeholder = @"民族";
    }
    race.delegate = self;
    race.tag = 104;
    [headerSuperView addSubview:race];
    
    return headerSuperView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];

    static NSString * reuserIdentifer = @"setPersonalInfo";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifer];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuserIdentifer];
        
        UITextField * value = [[UITextField alloc]initWithFrame:CGRectMake(67, 45, 271, 25)];
        value.delegate = self;
        [cell.contentView addSubview:value];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[self.dataSource objectAtIndex:row] objectForKey:@"image"]];

    cell.textLabel.text = [[self.dataSource objectAtIndex:row] objectForKey:@"value"];
    
    cell.detailTextLabel.text = @"  ";
    
    //cell.detailTextLabel.text = [(CBUser*)[CBCurrentUser currentUser]valueForKey:[[self.dataSource objectAtIndex:row] objectForKey:@"key"]];

    for (UIView * view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {     
            ((UITextField *)view).text = [(CBUser*)[CBCurrentUser currentUser]valueForKey:[[self.dataSource objectAtIndex:row] objectForKey:@"key"]];
            view.tag = 200 + row;
            if ([((UITextField *)view).text isEqualToString:@"<null>"]) {
                ((UITextField *)view).text = @"";
                ((UITextField *)view).placeholder = [[self.dataSource objectAtIndex:row] objectForKey:@"value"];
            }
        }
    }
    
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextLabelDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float superOrignY = textField.superview.superview.frame.origin.y;
    float off;
    off = superOrignY -120;
    if (superOrignY > 157) {
        [self.detailTableView setContentOffset:CGPointMake(0, off) animated:YES];
        offSet = off;
    }
    else
    {
        offSet = 0;
    }
    
    if (textField.tag == 102)
    {
        textField.text = [NSString stringWithFormat:@"%d",[textField.text intValue]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
        return;
    }
    if (textField.tag>=100 && textField.tag<200) {
        int row = textField.tag -100;
        
        [(CBUser*)[CBCurrentUser currentUser]setValue:textField.text forKey:[headerKeys objectAtIndex:row]];
        
        [[CBCurrentUser currentUser]saveValue:textField.text forkey:[headerKeys objectAtIndex:row]];
        
        if (row == 2) {
            textField.text = [NSString stringWithFormat:@"%@岁",textField.text];
        }
        
        return;
    }
    int row = textField.tag - 200;
    float superOrignY = textField.superview.superview.frame.origin.y;
    
    [(CBUser*)[CBCurrentUser currentUser]setValue:textField.text forKey:[[self.dataSource objectAtIndex:row] objectForKey:@"key"]];

    [[CBCurrentUser currentUser]saveValue:textField.text forkey:[[self.dataSource objectAtIndex:row] objectForKey:@"key"]];
    
    //NSLog(@"%@",[(CBUser*)[CBCurrentUser currentUser]valueForKey:[[self.dataSource objectAtIndex:row] objectForKey:@"key"]]);
    
    if (offSet!=0) {
        [self.detailTableView setContentOffset:CGPointMake(0, superOrignY-offSet) animated:YES];
    }

}
@end
