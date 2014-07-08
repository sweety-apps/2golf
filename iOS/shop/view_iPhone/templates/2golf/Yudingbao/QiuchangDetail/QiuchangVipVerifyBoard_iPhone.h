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
//  QiuchangVipVerifyBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangVipVerifyBoard_iPhone : BeeUIBoard <UITextFieldDelegate>

AS_SIGNAL(DAIL_PHONE_OK)
AS_SIGNAL(SEND_VERIFY_OK)

@property (nonatomic,retain) NSString* courseId;

@property (nonatomic,retain) IBOutlet UITextField* numTextFeild;
@property (nonatomic,retain) IBOutlet UITextField* nameTextFeild;

-(IBAction)onPressedSendBtn:(id)sender;
-(IBAction)onPressedPhoneBtn:(id)sender;

@end
