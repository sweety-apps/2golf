//
//  QiuchangOrderEditCellViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuchangOrderEditCellViewController : UIViewController

//common
@property (nonatomic,retain) IBOutlet UIImageView* cellBg;
@property (nonatomic,retain) IBOutlet UILabel* cellTitle;
@property (nonatomic,retain) IBOutlet UILabel* normalRightTitle;

//联系人
@property (nonatomic,retain) IBOutlet UILabel* contactRightTitle;
@property (nonatomic,retain) IBOutlet UIImageView* contactArrow;
@property (nonatomic,retain) IBOutlet UIButton* contactBtn;

//人数
@property (nonatomic,retain) IBOutlet UIButton* numDecreaseBtn;
@property (nonatomic,retain) IBOutlet UIButton* numIncreaseBtn;
@property (nonatomic,retain) IBOutlet UILabel* numLabel;

//联系电话
@property (nonatomic,retain) IBOutlet UITextField* phoneTextField;

//确认按钮
@property (nonatomic,retain) IBOutlet UIButton* confirmBtn;

@end
