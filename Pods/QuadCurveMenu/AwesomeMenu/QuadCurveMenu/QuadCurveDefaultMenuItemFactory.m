//
//  QuadCurveDefaultMenuItemFactory.m
//  Nudge
//
//  Created by Franklin Webber on 3/19/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "QuadCurveDefaultMenuItemFactory.h"

@interface QuadCurveDefaultMenuItemFactory () {
    UIImage *image;
    UIImage *highlightImage;
}

@end

@implementation QuadCurveDefaultMenuItemFactory

#pragma mark - Initialization

- (id)initWithImage:(UIImage *)_image 
     highlightImage:(UIImage *)_highlightImage {
    
    self = [super init];
    if (self) {
        
        image = _image;
        highlightImage = _highlightImage;
        
    }
    return self;
}

+ (id)defaultMenuItemFactory {
    
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-star.png" ]
                                           highlightImage:nil];
}

+ (id)defaultMainMenuItemFactory {
    
    return [[self alloc] initWithImage:[UIImage imageNamed:@"icon-plus.png"]
                        highlightImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];

}

#pragma mark - QuadCurveMenuItemFactory Adherence

//modify by itswyy
//更改返回图片样式，返回自定义QuadCurveMenuItem图标

- (QuadCurveMenuItem *)createMenuItemWithDataObject:(id)dataObject {
    
    if([dataObject isKindOfClass:[QuadCurveMenuItem class]])
    {
        return (QuadCurveMenuItem *)dataObject;
    }
    
     QuadCurveMenuItem *item = [[QuadCurveMenuItem alloc] initWithImage:image
                                                      highlightedImage:highlightImage];
    
    [item setDataObject:dataObject];
    
    return item;
}

@end
