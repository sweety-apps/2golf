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
//  SirendingzhiListCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-27.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SirendingzhiListCell_iPhone : BeeUICell

AS_SIGNAL( TOUCHED )

@end

#pragma mark -

@interface SirendingzhiListCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UILabel* titleLbl;
@property (nonatomic,retain) IBOutlet UILabel* desLbl;
@property (nonatomic,retain) IBOutlet UILabel* priceLbl;
@property (nonatomic,retain) IBOutlet BeeUIImageView* imgView;

@end
