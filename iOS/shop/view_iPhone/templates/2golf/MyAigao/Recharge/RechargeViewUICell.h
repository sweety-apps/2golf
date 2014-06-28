//
//  RechargeViewUICell.h
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee_UICell.h"
#import "ChargeConfirmView.h"

@class RechargeViewUICell;

@protocol RechargeViewUICellDelegate <NSObject>

- (void)rechargeViewUICell:(RechargeViewUICell*)cell
            confirmedValue:(NSNumber*)value;

@end

@interface RechargeViewUICell : BeeUICell

@property (nonatomic,retain) ChargeConfirmView* confirmView;
@property (nonatomic,assign) id<RechargeViewUICellDelegate> delegate;

@end
