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
//  SirendingzhiDetailBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface SirendingzhiDetailBannerPhotoCell_iPhone : BeeUICell
AS_SIGNAL( TOUCHED )
@end

#pragma mark -

@interface SirendingzhiDetailBannerCell_iPhone : BeeUICell
@property (nonatomic, retain) UIView *		shadow;
@property (nonatomic, retain) UILabel *		leftLabel;
@property (nonatomic, retain) UILabel *		rightLabel;
@property (nonatomic, retain) UIImageView *		arrowImg;
@property (nonatomic, retain) UIButton *		detailBtn;
@property (nonatomic, retain) BeeUIScrollView *		scroll;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;
@end

#pragma mark -

#pragma mark -

@interface SirendingzhiDetailBoard_iPhone : BeeUIBoard

- (void) setCustomId:(NSString*)customId;

@end
