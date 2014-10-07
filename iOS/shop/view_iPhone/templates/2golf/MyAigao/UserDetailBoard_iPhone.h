//
//  UserDetailBoard_iPhone.h
//  2golf
//
//  Created by rolandxu on 14-10-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "UserModel.h"

@protocol UserDetailCell_iPhoneDelegate <NSObject>

-(void)onClickBirthday:(id)sender;

@end

@interface UserDetailCell_iPhone : BeeUICell
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic,assign) id<UserDetailCell_iPhoneDelegate> delegate;
@property (nonatomic,retain) NSString* birthdayString;

-(USER*)getCurrentUserInfo;
@end

@interface UserDetailBoard_iPhone : BeeUIBoard

@property (nonatomic, assign) BOOL isEditing;
@end
