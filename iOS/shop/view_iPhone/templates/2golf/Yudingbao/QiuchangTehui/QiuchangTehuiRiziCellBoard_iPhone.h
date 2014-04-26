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
//  QiuchangTehuiRiziCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangTehuiRiziCell_iPhone : BeeUICell

AS_SIGNAL( TOUCHED )

@end

#pragma mark -

@interface QiuchangTehuiRiziCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UILabel* titleLbl;
@property (nonatomic,retain) IBOutlet UILabel* dateLbl;
@property (nonatomic,retain) IBOutlet UILabel* oldPriceLbl;
@property (nonatomic,retain) IBOutlet UILabel* newPriceLbl;
@property (nonatomic,retain) IBOutlet UILabel* desLbl;
@property (nonatomic,retain) IBOutlet UIImageView* huiImg;
@property (nonatomic,retain) IBOutlet UIImageView* xianImg;
@property (nonatomic,retain) IBOutlet UIImageView* bubbleImg;

@end
