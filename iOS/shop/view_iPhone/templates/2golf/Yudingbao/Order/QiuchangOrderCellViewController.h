//
//  QiuchangOrderCellViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"


#pragma mark -

@interface QiuchangOrderCellViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIButton* btn1;
@property (nonatomic,retain) IBOutlet UIButton* btn2;
@property (nonatomic,retain) IBOutlet UIButton* btn3;
@property (nonatomic,retain) IBOutlet UIButton* btn4;

@property (nonatomic,retain) IBOutlet UILabel* orderTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* playTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* peopleTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* descriptionTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* priceTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* stateTimeLbl;

@end


#pragma mark -

@interface QiuchangOrderCell_iPhone : BeeUICell

@property (nonatomic,retain) QiuchangOrderCellViewController* ctrl;

@end
