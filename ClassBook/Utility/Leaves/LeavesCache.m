//
//  LeavesCache.m
//  Reader
//
//  Created by Tom Brow on 5/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeavesCache.h"
#import "LeavesView.h"

@implementation LeavesCache

@synthesize  pageSize = _pageSize;
@synthesize dataSource = _dataSource;

- (id) initWithPageSize:(CGSize)aPageSize
{
	if ([super init]) {
		_pageSize = aPageSize;
		pageCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}



- (CGImageRef) imageForPageIndex:(NSUInteger)pageIndex {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 _pageSize.width,
												 _pageSize.height,
												 8,						/* bits per component*/
												 _pageSize.width * 4, 	/* bytes per row */
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
#warning itswyy 此处应该不用释放，释放后会崩溃
//	CGColorSpaceRelease(colorSpace);
	CGContextClipToRect(context, CGRectMake(0, 0, _pageSize.width, _pageSize.height));
	
	[_dataSource renderPageAtIndex:pageIndex inContext:context];
	
	CGImageRef image = CGBitmapContextCreateImage(context);
//	CGContextRelease(context);
	
	[UIImage imageWithCGImage:image];
//	CGImageRelease(image);
	
	return image;
}

- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex {
	NSNumber *pageIndexNumber = [NSNumber numberWithInt:pageIndex];
	UIImage *pageImage;
	@synchronized (pageCache) {
		pageImage = [pageCache objectForKey:pageIndexNumber];
	}
	if (!pageImage) {
		CGImageRef pageCGImage = [self imageForPageIndex:pageIndex];
		pageImage = [UIImage imageWithCGImage:pageCGImage];
		@synchronized (pageCache) {
			[pageCache setObject:pageImage forKey:pageIndexNumber];
		}
	}
	return pageImage.CGImage;
}

- (void) precacheImageForPageIndexNumber:(NSNumber *)pageIndexNumber {
	[self cachedImageForPageIndex:[pageIndexNumber intValue]];
}

- (void) precacheImageForPageIndex:(NSUInteger)pageIndex {
	[self performSelectorInBackground:@selector(precacheImageForPageIndexNumber:)
						   withObject:[NSNumber numberWithInt:pageIndex]];
}

- (void) minimizeToPageIndex:(NSUInteger)pageIndex {
	/* Uncache all pages except previous, current, and next. */
	@synchronized (pageCache) {
		for (NSNumber *key in [pageCache allKeys])
			if (ABS([key intValue] - (int)pageIndex) > 2)
				[pageCache removeObjectForKey:key];
	}
}

- (void) flush {
	@synchronized (pageCache) {
		[pageCache removeAllObjects];
	}
}

#pragma mark accessors

- (void) setPageSize:(CGSize)value {
	_pageSize = value;
	[self flush];
}

@end
