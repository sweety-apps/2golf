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
//  OtherTripBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface OtherTripBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UITextField* customerName;
@property (nonatomic,retain) IBOutlet UITextField* personNum;
@property (nonatomic,retain) IBOutlet UITextField* destination;
@property (nonatomic,retain) IBOutlet UITextField* goDate;
@property (nonatomic,retain) IBOutlet UITextField* backDate;
@property (nonatomic,retain) IBOutlet UITextField* hotelStars;
@property (nonatomic,retain) IBOutlet UITextField* hotelRoomModel;
@property (nonatomic,retain) IBOutlet UITextField* hotelRoomNum;
@property (nonatomic,retain) IBOutlet UITextField* qiuchangName;
@property (nonatomic,retain) IBOutlet UITextField* otherNeeds;
@property (nonatomic,retain) IBOutlet UITextField* email;
@property (nonatomic,retain) IBOutlet UITextField* phoneNum;
@property (nonatomic,retain) IBOutlet UISwitch* needCar;

- (IBAction)onPressedSend:(id)sender;

@end
