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
//  QuichangDetailBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "QiuchangDetailBottomBoard_iPhone.h"
#import "QiuchangDetailInfoCellBoard_iPhone.h"
#import "QiuchangDetailCollectCellBoard_iPhone.h"
#import "QiuchangDetailPriceContentCellBoard_iPhone.h"
#import "QiuchangDetailPriceHeaderCellBoard_iPhone.h"

#pragma mark -

@interface QiuchangBannerPhotoCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface QiuchangBannerCell_iPhone : BeeUICell
@property (nonatomic, retain) UIView *		shadow;
@property (nonatomic, retain) UILabel *		leftLabel;
@property (nonatomic, retain) UILabel *		rightLabel;
@property (nonatomic, retain) UIImageView *		arrowImg;
@property (nonatomic, retain) UIButton *		detailBtn;
@property (nonatomic, retain) BeeUIScrollView *		scroll;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;
@end

#pragma mark -

@interface QuichangDetailBoard_iPhone : BeeUIBoard

- (void) setCourseId:(NSString*)courseId;

AS_SIGNAL(DAIL_RIGHT_NAV_BTN);

@end
