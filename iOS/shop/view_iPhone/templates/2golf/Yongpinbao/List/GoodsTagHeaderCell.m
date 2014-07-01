//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  GoodsTagHeaderCell.m
//  2golf
//
//  Created by Lee Justin on 14-6-30.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "GoodsTagHeaderCell.h"

#pragma mark -

@implementation GoodsTagHeaderCell

- (void)load
{
}

- (void)unload
{
}

- (void)awakeFromNib
{
    self.brandButton.layer.masksToBounds = YES;
    self.brandButton.layer.borderColor = [UIColor colorWithRed:0.274 green:0.535 blue:0.079 alpha:1.000].CGColor;
    self.brandButton.layer.borderWidth = 2;
    
    self.categoryButton.layer.masksToBounds = YES;
    self.categoryButton.layer.borderColor = [UIColor colorWithRed:0.274 green:0.535 blue:0.079 alpha:1.000].CGColor;
    self.categoryButton.layer.borderWidth = 2;
    
    self.keywordButton.layer.masksToBounds = YES;
    self.keywordButton.layer.borderColor = [UIColor colorWithRed:0.274 green:0.535 blue:0.079 alpha:1.000].CGColor;
    self.keywordButton.layer.borderWidth = 2;
    
}

- (void)dataDidChanged
{
    // TODO: fill data
}

- (void)dealloc {
    [_brandButton release];
    [_categoryButton release];
    [_keywordButton release];
    [super dealloc];
}
@end
