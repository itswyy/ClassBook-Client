//
//  CBMessage.h
//  ClassBook
//
//  Created by wtlucky on 13-3-10.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBMessage : NSObject

@property (strong, nonatomic) NSString *msg_content;
@property (assign, nonatomic) int msg_id;
@property (strong, nonatomic) NSString *msg_time;

@end
