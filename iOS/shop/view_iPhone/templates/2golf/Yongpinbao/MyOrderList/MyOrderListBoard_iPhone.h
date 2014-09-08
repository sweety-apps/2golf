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
//  MyOrderListBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface MyOrderListBoard_iPhone : BeeUIBoard

@property (retain, nonatomic) IBOutlet UIButton *btnsel0;
@property (retain, nonatomic) IBOutlet UIButton *btnsel1;
@property (retain, nonatomic) IBOutlet UIButton *btnsel2;
@property (retain, nonatomic) IBOutlet UIButton *btnsel3;
@property (retain, nonatomic) IBOutlet UIButton *btnsel4;
@property (retain, nonatomic) IBOutlet UIButton *btnsel5;
@property (nonatomic,assign) BOOL hasRefreshed;

- (IBAction)pressedSwitchBtn:(UIButton *)sender;

@end
