//
//  QiuChangOrderDetailBoard_iPhoneV2.h
//  2golf
//
//  Created by rolandxu on 14-9-3.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "model.h"

@interface QiuChangOrderDetailBoard_iPhone : BeeUIBoard
{
    BeeUIScrollView *		_scroll;
}
@property (nonatomic,retain) NSMutableDictionary* order;
@property (nonatomic,assign) BOOL isResult;
@end
