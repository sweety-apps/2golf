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

@class QiuchangOrderCell_iPhoneV2;

@protocol QiuchangOrderCell_iPhoneV2Delegate <NSObject>

-(void)onPressPay:(NSDictionary*)courseorder;
-(void)onPressOrderAgain:(NSDictionary*)courseorder;
@end

@protocol CourseOrderCellInfo_iPhoneDelegate <NSObject>

@end

@interface CourseOrderCellInfo_iPhone : BeeUICell
@property (nonatomic, assign) id<CourseOrderCellInfo_iPhoneDelegate> delegate;
@end

@protocol CourseOrderCellHeader_iPhoneDelegate <NSObject>
-(void)onPressPay:(NSDictionary*)courseorder;
@end

@interface CourseOrderCellHeader_iPhone : BeeUICell
@property (nonatomic, assign) id<CourseOrderCellHeader_iPhoneDelegate> delegate;
@end

@protocol CourseOrderCellFooter_iPhoneDelegate <NSObject>
-(void)onPressOrderAgain:(NSDictionary*)courseorder;
@end

@interface CourseOrderCellFooter_iPhone : BeeUICell
@property (nonatomic, assign) id<CourseOrderCellFooter_iPhoneDelegate> delegate;
@end

@protocol CourseOrderCellBody_iPhoneDelegate <NSObject>

@end

@interface CourseOrderCellBody_iPhone : BeeUICell
@property (nonatomic, assign) id<CourseOrderCellBody_iPhoneDelegate> delegate;
@end

@interface QiuchangOrderCell_iPhoneV2 : BeeUICell
<CourseOrderCellHeader_iPhoneDelegate,CourseOrderCellBody_iPhoneDelegate,CourseOrderCellFooter_iPhoneDelegate,CourseOrderCellInfo_iPhoneDelegate>

{
    BeeUIScrollView * _scroll;
}

AS_SIGNAL( TOUCHED )

@property (nonatomic, retain) NSDictionary* courseorder;
@property (nonatomic, assign) id<QiuchangOrderCell_iPhoneV2Delegate> delegate;
@end
