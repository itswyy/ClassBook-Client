//
//  CBConstantDeclare.h
//  loginLogic
//
//  Created by wtlucky on 13-3-1.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#ifndef ClassBook_CBConstantDeclare_h
#define ClassBook_CBConstantDeclare_h

//useful methods
#define GET_APP_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//database constant
#define DB_NAME @"classbook.sqlite3"
#define DB_PATH [GET_APP_DOCUMENT_PATH stringByAppendingPathComponent:DB_NAME]

//the folder of defalt user
#define DEFULT_FOLDER_NAME @"0"
#define DEFULT_FOLDER_PaTH [GET_APP_DOCUMENT_PATH stringByAppendingPathComponent:DEFULT_FOLDER_NAME]

//device judgement
#define INTERFACE_IS_PAD   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define NETWORK_AVAILIABLE ([ClassBookAPIClient sharedClient].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi || [ClassBookAPIClient sharedClient].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN)


//registe info
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_TELEPHONE @"^(1(([35][0-9])|(47)|(44)|[8][0126789]))\\d{8}$"
#define REGEX_NAME @"[\u4e00-\u9fa5]"
#define REGEX_PSWD @"(^[A-Za-z0-9]{6,15}$)"
#define REGEX_USER_ID @"^+?[1-9][0-9]*$"


//blackboard note info
#define M_PI_2      1.57079632679489661923132169163975144  


//notifiction names
#define NNUSER_FIRST_LOGIN @"userFirstLogin"
#define NNUSER_LOGIN_SUCCEED @"userLoginSucceed"

//image sources
#define ISNAVIGATIONBAR_BACKIMAGE @"navigationBar.png"
#define ISDEFAULT_HEAD_FEMALE @"male.png"
#define ISDEFAULT_HEAD_MALE @"female.png"

#endif

