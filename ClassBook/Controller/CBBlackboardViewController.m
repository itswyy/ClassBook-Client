//
//  CBBlackboardViewController.m
//  ClassBook
//
//  Created by 小雨 on 13-3-13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBBlackboardViewController.h"
#import "CBDatabase.h"

@interface CBBlackboardViewController ()
@property (nonatomic, retain)NSArray * anglesArray;
@property (nonatomic, assign)NSInteger noteX;
@property (nonatomic, assign)NSInteger noteY;
@property (nonatomic, assign)CGAffineTransform noteTransation;

/**
 *	设置小黑板内容数据 数组
 */
- (void)setNotesArrayForBlackboard;

/**
 *	设置小黑板上内容显示位置数组
 */
- (void)setPositionForEveryNote;

/**
 *	设置显示标签的转动角度
 */
- (void)setRandomAngle;
/**
 *	设置黑板数组
 */
- (void)setTheBlackboardArray;

/**
 根据数据库中标签个数在小黑板上添加标签
 */
- (void)setNotesToBlackboard;

/**
 *	将某些视图置于最前端
 */
- (void)bringUsefulViewToFront;
@end

@implementation CBBlackboardViewController
@synthesize notesArray;
@synthesize positionArray;
@synthesize theCurrentBlackboardIndex;
@synthesize theCurrentNote;
@synthesize noteX;
@synthesize noteY;
@synthesize noteTransation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.theCurrentBlackboardIndex = 0;
    self.priorBlack.userInteractionEnabled = NO;
    [self setNotesArrayForBlackboard];
    
    //[self refreashBlackboard];
    
//    [self.view addSubview:[self.blackboardArray objectAtIndex:theCurrentBlackboardIndex]];
//
//    [self bringUsefulViewToFront];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    //[self setNotesArrayForBlackboard];
}

- (void)refreashBlackboard
{
    [self setPositionForEveryNote];
    [self setRandomAngle];
    [self setTheBlackboardArray];
    [self setNotesToBlackboard];
    
    [self.view addSubview:[self.blackboardArray objectAtIndex:theCurrentBlackboardIndex]];
    
    [self bringUsefulViewToFront];
}


/**
 *	设置小黑板上内容显示位置数组
 */
- (void)setPositionForEveryNote

{
    //positionArray存放每块黑板上可以放置标签的位置
    self.positionArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSArray *frame1 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:30],[NSNumber numberWithDouble:50],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame1];
    
    NSArray *frame2 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:100],[NSNumber numberWithDouble:60],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame2];
    
    NSArray *frame3 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:150],[NSNumber numberWithDouble:40],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame3];
    
    NSArray *frame4 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:230],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame4];
    
    NSArray *frame5 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:320],[NSNumber numberWithDouble:50],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame5];
    
    NSArray *frame6 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:50],[NSNumber numberWithDouble:110],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame6];
    
    NSArray *frame7 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:80],[NSNumber numberWithDouble:160],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame7];
    
    NSArray *frame8 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:280],[NSNumber numberWithDouble:130],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame8];
    
    NSArray *frame9 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:400],[NSNumber numberWithDouble:180],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame9];
    
    NSArray *frame10 = [[NSArray alloc]initWithObjects:[NSNumber numberWithDouble:250],[NSNumber numberWithDouble:100],[NSNumber numberWithDouble:70],[NSNumber numberWithDouble:70], nil];
    [self.positionArray addObject:frame10];
}


/**
 *	设置小黑板内容数据 数组
 */
- (void)setNotesArrayForBlackboard

{
#warning itswyy 此处主要功能已经实现放开下面的就OK了，但是存在逻辑上的bug 需完善，所以先暂时放原来的了
     NSMutableArray *msgesFromDB = [[CBDatabase sharedInstance] getMessagesByGroupId:self.groupid];
    DLog(@"msgesFromDB:%@",msgesFromDB);
// itswyy 小雨请注意此处，这个数组里存的是一个个的字典，从数组中查到的
    self.notesArray = msgesFromDB;
    //DLog(@"notesArray = %@", self.notesArray);
    
    __weak CBBlackboardViewController *tempVC = self;
    ClassBookAPIClient *client = [ClassBookAPIClient sharedClient];
    
    //post数据
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.groupid], @"group_id", nil];
    
    if (NETWORK_AVAILIABLE) {
        
        [client postPath:@"getMsg.php" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *onlineMsg = (NSArray *)responseObject;
            [tempVC.notesArray addObjectsFromArray:onlineMsg];
            
            
            [tempVC.notesArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSString *time1 = [(NSDictionary *)obj1 objectForKey:@"msg_time"];
                NSString *time2 = [(NSDictionary *)obj2 objectForKey:@"msg_time"];
                
                return [time1 compare:time2];
                
            }];
            
            //DLog(@"notesArray = %@", tempVC.notesArray);
            
            [tempVC refreashBlackboard];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DLog(@"get network message Failed!error:%@", [error localizedDescription]);
            [tempVC refreashBlackboard];
            
        }];
    }
    
        
    //DLog(@"notesArray = %@", self.notesArray);
    
    
}

/**
 *	设置显示标签的转动角度
 */
- (void)setRandomAngle

{
    self.anglesArray = [[NSArray alloc]initWithObjects:
                        [NSNumber numberWithDouble:0.2],
                        [NSNumber numberWithDouble:0.1],
                        [NSNumber numberWithDouble:0.3],
                        [NSNumber numberWithDouble:0.4],
                        [NSNumber numberWithDouble:0.45],
                        [NSNumber numberWithDouble:0.15],
                        [NSNumber numberWithDouble:0.3],
                        [NSNumber numberWithDouble:0.22],
                        [NSNumber numberWithDouble:0.25],
                        [NSNumber numberWithDouble:0.3],
                        nil];
}

/**
 *	设置黑板数组
 */
- (void)setTheBlackboardArray

{
    self.blackboardArray = [[NSMutableArray alloc]initWithCapacity:0];
    //根据现有notes数量得出小黑板数量
    int notesNum = [self.notesArray count];
    int blackBoardNum = notesNum / 10;
    
    DLog(@"notesNum = %d, blackBoardNum = %d", notesNum, blackBoardNum);
    
    
    if (notesNum % 10 > 0) {
        blackBoardNum += 1;
    }
    if (0 == blackBoardNum) {
        UIImageView *blackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"u9.jpg"]];
        blackView.userInteractionEnabled = YES;
        [self.blackboardArray addObject:blackView];
        blackView.frame = CGRectMake(0, 0, 480, 320);
        [self.view addSubview:blackView];
        self.nextBlack.userInteractionEnabled = NO;
    }
    
    for (int i = 0; i < blackBoardNum; i++) {
        UIImageView *blackView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"u9.jpg"]];
        blackView.userInteractionEnabled = YES;
        [self.blackboardArray addObject:blackView];
        if (i == 0) {
            blackView.frame = CGRectMake(0, 0, 480, 320);
        }
        else{
            blackView.frame = CGRectMake(477, 0, 480, 320);
        }
        [self.view addSubview:blackView];
        if (blackBoardNum == 1) {
            self.nextBlack.userInteractionEnabled = NO;
        }
    }
}

/**
 根据数据库中标签个数在小黑板上添加标签	
 */
- (void)setNotesToBlackboard

{
    int notesNum = [self.notesArray count];
    
    int from = theCurrentBlackboardIndex*10;
    int to = theCurrentBlackboardIndex*10+9;
    if (to > notesNum) {
        to = notesNum;
    }
    UIImageView *blackView  = [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex];
    for (int i = from; i < to; i++) {
        //获取位置坐标
        NSInteger x = [[[self.positionArray objectAtIndex:i%10] objectAtIndex:0] integerValue];
        NSInteger y = [[[self.positionArray objectAtIndex:i%10] objectAtIndex:1] integerValue];
        NSInteger w = [[[self.positionArray objectAtIndex:i%10] objectAtIndex:2] integerValue];
        NSInteger h = [[[self.positionArray objectAtIndex:i%10] objectAtIndex:3] integerValue];
        //NSLog(@"%d-- %d",w,h);
        //设置显示数据
        CBNoteView *note = [[CBNoteView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
//Modified by itswyy
                
        NSDictionary *aNote =(NSDictionary *)[self.notesArray objectAtIndex:i];
        //根据得到的用户id获得用户名
        NSDictionary *nameDic = [[CBDatabase sharedInstance] getUserNameByUserID:[[aNote objectForKey:@"user_id"] intValue]];
        NSString *name = [nameDic objectForKey:@"name"];
        
        note.nameLable.text =[NSString stringWithFormat:@"%@",name];//这里需要有数据
        note.msgLable.text = [NSString stringWithFormat:@"%@",[aNote objectForKey:@"msg_content"]];//这个方法解决了只输入文字会崩溃的问题
        note.timeLable.text = [NSString stringWithFormat:@"%@",[aNote objectForKey:@"msg_time"]];//这里需要有数据
//        note.nameLable.text =@"和小雨";//这里需要有数据
//        note.msgLable.text =[self.notesArray objectAtIndex:i];
//        note.timeLable.text = @"xixi";
        //设置倾斜角度
        double angle = 0;
        if (i%3 == 0) {
            angle = [[self.anglesArray objectAtIndex:i%10] doubleValue];
        }
        else if(i%3 == 1)
        {
            angle = 0;
        }
        else
        {
            angle = - [[self.anglesArray objectAtIndex:i%10] doubleValue];
        }
        
        note.transform = CGAffineTransformMakeRotation(angle*1.57079633);       
        
        [blackView addSubview:note];
    }
}



- (IBAction)addNewMessage:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BlackboardStoryboard" bundle:[NSBundle mainBundle]];
   CBPostitNoteViewController* postNoteVC  = (CBPostitNoteViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CBPostitNoteViewController"];
    
    postNoteVC.groupid =self.groupid;
    
    [self presentViewController:postNoteVC animated:YES completion:nil];
}

/**
 *	回到分组界面
 *
 *	@param 	sender 	nil
 */
- (IBAction)backToGroupViewController:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissModalViewControllerAnimated:NO];
}

/**
 *	当进入下一个小黑板时对当前黑板清空
 */
- (void)clearblackboard
{
    UIImageView *theCurrentBlackboard =
    [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex];
    
    for (UIView *obj in theCurrentBlackboard.subviews) {
        [obj removeFromSuperview];
    }
}
/**
 *	进步下一个小黑板内容
 *
 *	@param 	sender 	nil
 */
- (IBAction)gotoNextBlackboard:(id)sender
{
    self.priorBlack.userInteractionEnabled = YES;
    self.priorBlack.backgroundColor = [UIColor clearColor];
    //当前黑板 
    UIImageView *theCurrentBlackboard =
    [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex];
    
    UIImageView *theNextBlackboard = [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex+1];
    theCurrentBlackboardIndex += 1;
    [self setNotesToBlackboard];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    //Modified by itswyy
    //进入下一个小黑板动画完成后执行清理操作,解决多次进入，同一个标签叠加问题    
    [UIView setAnimationDidStopSelector:@selector(clearblackboard)];
    
    theCurrentBlackboard.frame = CGRectMake(-477, 0, 480, 320);
    theNextBlackboard.frame = CGRectMake(0, 0, 480, 320);
    [self bringUsefulViewToFront];
    [UIView commitAnimations];
    int boardNum = [self.blackboardArray count];
//    NSLog(@"%d",boardNum);
    if (theCurrentBlackboardIndex == boardNum-1) {
        self.nextBlack.userInteractionEnabled = NO;
        self.nextBlack.backgroundColor = [UIColor clearColor];
    }
    

}

/**
 *	回到上一个小黑板内容
 *
 *	@param 	sender 	nil
 */
- (IBAction)backtoPriorBlackboard:(id)sender
{
    self.nextBlack.userInteractionEnabled = YES;
    self.nextBlack.backgroundColor = [UIColor clearColor];
    
    UIImageView *theCurrentBlackboard =
    [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex];
    theCurrentBlackboardIndex -= 1;
    UIImageView *thePriorBlackboard = [self.blackboardArray objectAtIndex:theCurrentBlackboardIndex];
    [self setNotesToBlackboard];
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDidStopSelector:@selector(clearblackboard)];
    theCurrentBlackboard.frame = CGRectMake(477, 0, 480, 320);
    thePriorBlackboard.frame = CGRectMake(0, 0, 480, 320);
    [UIView commitAnimations];
    [self bringUsefulViewToFront];

    if (theCurrentBlackboardIndex == 0) {
        self.priorBlack.userInteractionEnabled = NO;
        self.priorBlack.backgroundColor = [UIColor clearColor];
    }
}

/**
 *	将某些视图置于最前端
 */
- (void)bringUsefulViewToFront

{
    [self.view bringSubviewToFront:self.priorBlack];
    [self.view bringSubviewToFront:self.nextBlack];
    [self.view bringSubviewToFront:self.close];
    [self.view bringSubviewToFront:self.add];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//orientation for lower ios 6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//orientation for ios 6
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
@end
