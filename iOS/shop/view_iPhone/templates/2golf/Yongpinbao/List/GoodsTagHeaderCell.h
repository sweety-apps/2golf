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
//  GoodsTagHeaderCell.h
//  2golf
//
//  Created by Lee Justin on 14-6-30.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface GoodsTagHeaderCell : BeeUICell
@property (retain, nonatomic) IBOutlet UIButton *brandButton;
@property (retain, nonatomic) IBOutlet UIButton *categoryButton;
@property (retain, nonatomic) IBOutlet UIButton *keywordButton;
@end
