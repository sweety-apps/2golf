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
//  QiuchangDetailDescriptionBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangDetailDescriptionCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface QiuchangDetailDescriptionBoard_iPhone : BeeUIBoard

- (void)setDataDictionary:(NSDictionary*)dataDict;

@end