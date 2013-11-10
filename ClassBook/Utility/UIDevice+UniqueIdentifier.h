//
//  UIDevice+UniqueIdentifier.h
//  ClassBook
//
//  Created by wtlucky on 13-3-22.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (UniqueIdentifier)

/**
 *	返回针对与一个应用的唯一ID
 *
 *	@return	针对与一个应用的唯一ID
 */
- (NSString *)uniqueDeviceIdentifier;


/**
 *	返回设备的唯一ID
 *
 *	@return	设备的唯一ID
 */
- (NSString *)uniqueGlobalDeviceIdentifier;


@end
