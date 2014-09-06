//
//  QiuChangOrderDetailCell.h
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee_UICell.h"
#import "Bee.h"
#import "ecmobile.h"


@protocol BrandListCell_iPhoneDelegate
-(void)onClickBrand:(BRAND*)brand;
@end


@interface BrandListCell_iPhone : BeeUICell
@property (nonatomic,assign) id<BrandListCell_iPhoneDelegate> delegate;

@end
