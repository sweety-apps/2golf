//
//  OrderListBoard_iPhone.h
//  2golf
//
//  Created by rolandxu on 9/30/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "BaseBoard_iPhone.h"

@interface OrderListBoard_iPhone : BaseBoard_iPhone

@property (retain, nonatomic) IBOutlet UIButton *btnsel0;
@property (retain, nonatomic) IBOutlet UIButton *btnsel1;
@property (retain, nonatomic) IBOutlet UIButton *btnsel2;
@property (retain, nonatomic) IBOutlet UIButton *btnsel3;
@property (retain, nonatomic) IBOutlet UIButton *btnsel4;

- (IBAction)pressedSwitchBtn:(UIButton *)sender;
@end
