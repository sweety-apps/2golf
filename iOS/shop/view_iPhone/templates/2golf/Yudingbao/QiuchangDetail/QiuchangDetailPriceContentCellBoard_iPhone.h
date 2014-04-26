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
//  QiuchangDetailPriceContentCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@class QiuchangDetailPriceContentCell_iPhone;

@protocol QiuchangDetailPriceContentCell_iPhoneDelegate <NSObject>

- (void)onPressedPriceButton:(QiuchangDetailPriceContentCell_iPhone*)cell;

@end

#pragma mark -

@interface QiuchangDetailPriceContentCell_iPhone : BeeUICell

@property (nonatomic,assign) id<QiuchangDetailPriceContentCell_iPhoneDelegate> delegate;

@end

#pragma mark -

@interface QiuchangDetailPriceContentCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIButton* orderBtn;
@property (nonatomic,retain) IBOutlet UILabel* nameLbl;
@property (nonatomic,retain) IBOutlet UILabel* priceLbl;

@end
