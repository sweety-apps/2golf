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
//  QiuchangResultListBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangResultListBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIButton* btn1;
@property (nonatomic,retain) IBOutlet UIButton* btn2;
@property (nonatomic,retain) IBOutlet UIButton* btn3;

- (IBAction)btn1Pressed:(id)sender;
- (IBAction)btn2Pressed:(id)sender;
- (IBAction)btn3Pressed:(id)sender;

AS_SIGNAL( DAIL_RIGHT_NAV_BTN )

@end
