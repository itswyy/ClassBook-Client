//
//  CBMenuItemDataSource.h
//  ClassBook
//
//  Created by Parker on 5/3/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuadCurveDataSourceDelegate.h"

@interface CBMenuItemDataSource : NSObject<QuadCurveDataSourceDelegate>
{
    NSMutableArray *dataItems;
}
@property (nonatomic , strong)NSMutableArray *dataItems;



@end
