//
//  QiuChangOrderDetailCell.h
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee_UICell.h"
#import "Bee.h"


@protocol QiuChangOrderDetailCellDelegate
-(void)orderagain:(NSDictionary*)order;
-(void)cancelorder:(NSDictionary*)order;
@end


@interface QiuChangOrderDetailCell : BeeUICell
@property (nonatomic,assign) id<QiuChangOrderDetailCellDelegate> delegate;

@end
