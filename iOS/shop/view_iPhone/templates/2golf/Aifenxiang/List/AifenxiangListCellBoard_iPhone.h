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
//  AifenxiangListCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@class AifenxiangListCellBoard_iPhone;

@interface AifenxiangListCell_iPhone : BeeUICell

@property (nonatomic,retain) AifenxiangListCellBoard_iPhone* ctrl;

AS_SIGNAL( TOUCHED )

@end

#pragma mark -

@interface AifenxiangListCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UITextView* titleLbl;
@property (nonatomic,retain) IBOutlet UILabel* dateLbl;
@property (nonatomic,retain) IBOutlet UILabel* desLbl;
@property (nonatomic,retain) IBOutlet BeeUIImageView* imgView;

@end
