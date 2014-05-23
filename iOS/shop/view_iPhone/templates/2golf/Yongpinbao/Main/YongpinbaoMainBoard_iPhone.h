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
//  YongpinbaoMainBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-23.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface YongpinbaoMainBannerPhotoCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface YongpinbaoMainBannerCell_iPhone : BeeUICell
@property (nonatomic, retain) UIView *		shadow;
@property (nonatomic, retain) UILabel *		leftLabel;
@property (nonatomic, retain) UILabel *		rightLabel;
@property (nonatomic, retain) UIImageView *		arrowImg;
@property (nonatomic, retain) UIButton *		detailBtn;
@property (nonatomic, retain) BeeUIScrollView *		scroll;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;
@end


#pragma mark -

@interface YongpinbaoMainBoard_iPhone : BeeUIBoard

AS_SIGNAL(DAIL_RIGHT_NAV_BTN);
AS_SIGNAL(DAIL_LEFT_NAV_BTN);

@end
