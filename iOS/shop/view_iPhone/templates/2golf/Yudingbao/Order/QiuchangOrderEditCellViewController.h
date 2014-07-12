//
//  QiuchangOrderEditCellViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangOrderEditCellViewController : UIViewController

//common
@property (nonatomic,retain) IBOutlet UIView* baseView;
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
@property (nonatomic,retain) IBOutlet BeeUITextField* phoneTextField;

//确认按钮
@property (nonatomic,retain) IBOutlet UIButton* confirmBtn;

@end


#pragma mark -

@class QiuchangOrderEditCell_iPhone;
@protocol QiuchangOrderEditCell_iPhoneDelegate <NSObject>

- (void)onPressedContact:(QiuchangOrderEditCell_iPhone*)cell;
- (void)onPressedConfirm:(QiuchangOrderEditCell_iPhone*)cell;
- (void)onPressedIncreasePeople:(QiuchangOrderEditCell_iPhone*)cell;
- (void)onPressedDecreasePeople:(QiuchangOrderEditCell_iPhone*)cell;

@end

#pragma mark -

@interface QiuchangOrderEditCell_iPhone : BeeUICell

AS_SIGNAL( TOUCHED )

@property (nonatomic,assign) id<QiuchangOrderEditCell_iPhoneDelegate> delegate;
@property (nonatomic,retain) QiuchangOrderEditCellViewController* ctrl;

- (void)setNormalH;
- (void)setNormalM;
- (void)setNormalB;

- (void)setContact;
- (void)setContactM;
- (void)setPhoneNum;
- (void)setPeopleNum;
- (void)setPeopleNumM;
- (void)setConfirm;

- (void)setLeftText:(NSString*)text;
- (void)setRightText:(NSString*)text color:(UIColor*)color;
- (void)resizeSelfWithRightText;

@end
