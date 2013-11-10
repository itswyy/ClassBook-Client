//
//  CBMenuItemDataSource.m
//  ClassBook
//
//  Created by Parker on 5/3/13.
//  Copyright (c) 2013年 AlphaStudio. All rights reserved.
//

#import "CBMenuItemDataSource.h"

#import "QuadCurveMenuItem.h"
#import "QuadCurveDefaultMenuItemFactory.h"

@implementation CBMenuItemDataSource

@synthesize dataItems =_dataItems;

#pragma mark - QuadCurveDataSourceDelegate Adherence

- (id)init
{
    self = [super init];
    if (self) {
        
        //TODO:此处暂时用的全是相同如片，每个按钮的图片需要改变
        UIImage *storyMenuItemImage = [UIImage imageNamed:@"menuitem_outline_write.png"]; 
        UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"menuitem_outline_write.png"];
        //UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"icon-plus-highlighted@2x.png"];
        // 离线填写.
        QuadCurveMenuItem * outlineWriteMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed];
        // 同步.
        UIImage *synMenuItemImage = [UIImage imageNamed:@"menuitem_synchronization.png"];
        UIImage *synMenuItemImagePressed = [UIImage imageNamed:@"menuitem_synchronization.png"];
        QuadCurveMenuItem *synMenuItem =[[QuadCurveMenuItem alloc] initWithImage:synMenuItemImage highlightedImage:synMenuItemImagePressed];
        
        
        // 列表 MenuItem.
        UIImage *listMenuItemImage = [UIImage imageNamed:@"menuitem_list.png"];
        UIImage *listMenuItemImagePressed = [UIImage imageNamed:@"menuitem_list.png"];
        QuadCurveMenuItem *listMenuItem = [[QuadCurveMenuItem alloc] initWithImage:listMenuItemImage highlightedImage:listMenuItemImagePressed];
       
        // 搜索 MenuItem.
        UIImage *searchMenuItemImage = [UIImage imageNamed:@"menuitem_search.png"];
        UIImage *searchMenuItemImagePressed = [UIImage imageNamed:@"menuitem_search.png"];
        QuadCurveMenuItem *searchMenuItem = [[QuadCurveMenuItem alloc] initWithImage:searchMenuItemImage highlightedImage:searchMenuItemImagePressed];
        
      // 消息 MenuItem.
        UIImage *msgMenuItemImage = [UIImage imageNamed:@"menuitem_message.png"];
        UIImage *msgMenuItemImagePressed = [UIImage imageNamed:@"menuitem_message.png"];
        QuadCurveMenuItem *msgMenuItem = [[QuadCurveMenuItem alloc] initWithImage:msgMenuItemImage highlightedImage:msgMenuItemImagePressed];
        
        
        
        NSMutableArray *menus = [NSMutableArray arrayWithObjects:searchMenuItem,outlineWriteMenuItem, synMenuItem, listMenuItem,  msgMenuItem,nil];
        
        //NSLog(@"itswyy");
        
        dataItems = menus;
        //NSLog(@"%@",dataItems);
        
    }
    
    return self;
}

/**
 *	菜单数
 *
 *	@return	菜单数
 */
- (int)numberOfMenuItems
{
    return [dataItems count];
}


/**
 *	<#Description#>
 *
 *	@param 	itemIndex 	<#itemIndex description#>
 *
 *	@return	<#return value description#>
 */
- (id)dataObjectAtIndex:(NSInteger)itemIndex
{
    return [dataItems objectAtIndex:itemIndex];
}


@end
