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
//  SendVerifyCodeBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SendVerifyCodeBoard_iPhone : BeeUIBoard

- (IBAction)pressedSend:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *phoneNumTextFeild;

@end