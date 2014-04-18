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
//  QiuchangDetailInfoCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangDetailInfoCell_iPhone : BeeUICell

@end

#pragma mark -

@interface QiuchangDetailInfoCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UILabel* leftLbl1;
@property (nonatomic,retain) IBOutlet UILabel* rightLbl1;
@property (nonatomic,retain) IBOutlet UIButton* btn1;

@property (nonatomic,retain) IBOutlet UILabel* leftLbl2;
@property (nonatomic,retain) IBOutlet UILabel* rightLbl2;
@property (nonatomic,retain) IBOutlet UIButton* btn2;

@property (nonatomic,retain) IBOutlet UILabel* leftLbl3;
@property (nonatomic,retain) IBOutlet UILabel* rightLbl3;
@property (nonatomic,retain) IBOutlet UIButton* btn3;


@end
