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
//  ChangePasswordBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ChangePasswordBoard_iPhone : BeeUIBoard
- (IBAction)pressedBtn:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *newPasswordFeild;
@property (retain, nonatomic) IBOutlet UITextField *oldPasswordFeild;
@end
