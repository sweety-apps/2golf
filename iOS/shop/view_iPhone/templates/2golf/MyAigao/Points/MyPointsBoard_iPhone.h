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
//  MyPointsBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface MyPointsBoard_iPhone : BeeUIBoard
- (IBAction)pressedConfirm:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *pointsUseTextFeild;
@property (retain, nonatomic) IBOutlet UILabel *pointsLabel;
@end
