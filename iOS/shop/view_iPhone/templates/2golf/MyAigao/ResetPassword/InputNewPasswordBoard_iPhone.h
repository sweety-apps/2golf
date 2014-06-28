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
//  InputNewPasswordBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface InputNewPasswordBoard_iPhone : BeeUIBoard

@property (retain, nonatomic) NSString* phoneNum;

@property (retain, nonatomic) IBOutlet UITextField *verifyCodeField;

@property (retain, nonatomic) IBOutlet UITextField *newPassword;

- (IBAction)pressdBtn:(id)sender;

@end
