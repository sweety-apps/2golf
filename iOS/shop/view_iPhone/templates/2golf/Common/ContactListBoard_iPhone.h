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
//  ContactListBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-22.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface ContactListBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIView* handInputView;
@property (nonatomic,retain) IBOutlet UILabel* handInputInfoLbl;
@property (nonatomic,retain) IBOutlet UITextField* handInputField;
@property (nonatomic,retain) IBOutlet UIButton* handInputConfirmBtn;

@end
