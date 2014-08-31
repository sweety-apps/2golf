//
//  QiuchangOrderCell_iPhoneV2.h
//  2golf
//
//  Created by rolandxu on 14-8-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee_UICell.h"
#import "Bee.h"
#import "model.h"
#import "BaseBoard_iPhone.h"

@interface CourseOrderCellInfo_iPhone : BeeUICell
@property (nonatomic, retain) NSString * formated_integral_money;
@property (nonatomic, retain) NSString * formated_shipping_fee;
@property (nonatomic, retain) NSString * formated_bonus;
@end

@interface CourseOrderCellHeader_iPhone : BeeUICell
@end

@interface CourseOrderCellFooter_iPhone : BeeUICell
@end

@interface CourseOrderCellBody_iPhone : BeeUICell
@end

@interface QiuchangOrderCell_iPhoneV2 : BeeUICell

{
    BeeUIScrollView * _scroll;
}

AS_SIGNAL( ORDER_CANCEL )
AS_SIGNAL( ORDER_PAY )

@property (nonatomic, retain) NSDictionary* courseorder;

@end
