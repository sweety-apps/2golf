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
//  ContactListCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-22.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@class ContactListCellBoard_iPhone;

@interface ContactListCell_iPhone : BeeUICell

AS_SIGNAL( TOUCHED )

@property (nonatomic,retain) ContactListCellBoard_iPhone* ctrl;

@end

#pragma mark -

@interface ContactListCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UILabel* nameLbl;
@property (nonatomic,retain) IBOutlet UIImageView* checkImg;

@end
