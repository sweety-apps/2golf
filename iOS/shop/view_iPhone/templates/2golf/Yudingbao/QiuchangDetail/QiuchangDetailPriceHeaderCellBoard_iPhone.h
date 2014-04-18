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
//  QiuchangDetailPriceHeaderCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangDetailPriceHeaderCell_iPhone : BeeUICell

@end


#pragma mark -

@interface QiuchangDetailPriceHeaderCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIView* upLine;
@property (nonatomic,retain) IBOutlet UIView* downLine;
@property (nonatomic,retain) IBOutlet UILabel* titleLbl;

@end
