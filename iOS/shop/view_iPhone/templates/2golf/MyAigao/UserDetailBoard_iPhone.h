//
//  UserDetailBoard_iPhone.h
//  2golf
//
//  Created by rolandxu on 14-10-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "UserModel.h"

@interface UserDetailCell_iPhone : BeeUICell
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) UILabel* titleview;
@property (nonatomic, retain) UILabel* valueview;
@property (nonatomic, retain) UITextField* editvalueview;
@end

@interface UserDetailBoard_iPhone : BeeUIBoard

@property (nonatomic, assign) BOOL isEditing;
@end
