//
//  CBCommonFunction.h
//  ClassBook
//
//  Created by wtlucky on 13-6-17.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCommonFunction : NSObject

+ (CBCommonFunction *)sharedInstance;

- (void)setNavigationBackBarBtn:(UIViewController *)VC;

@end
