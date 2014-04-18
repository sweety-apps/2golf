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
//  QiuchangDetailBottomBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangDetailBottomCell_iPhone : BeeUICell
AS_SIGNAL(DAIL_PHONE_OK)
@end

#pragma mark -

@interface QiuchangDetailBottomBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIButton* phoneBtn;
@property (nonatomic,retain) IBOutlet UIButton* mylistBtn;

@end
