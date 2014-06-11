//
//  QiuchangOrderCellViewController.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

typedef enum : NSUInteger {
    EOrderCellTypeCourse,
    EOrderCellTypeTaocan
} EOrderCellType;

@class QiuchangOrderCell_iPhone;

@protocol QiuchangOrderCell_iPhoneDelegate <NSObject>

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                 onPressedCancel:(NSDictionary*)data;
- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                 onPressedShare:(NSDictionary*)data;
- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                 onPressedPay:(NSDictionary*)data;
- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                    onPressedQiuchang:(NSDictionary*)data;

@end


#pragma mark -

@interface QiuchangOrderCellViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIButton* btn1;
@property (nonatomic,retain) IBOutlet UIButton* btn2;
@property (nonatomic,retain) IBOutlet UIButton* btn3;
@property (nonatomic,retain) IBOutlet UIButton* btn4;

@property (nonatomic,retain) IBOutlet UILabel* courseNameLbl;
@property (nonatomic,retain) IBOutlet UILabel* orderIdLbl;
@property (nonatomic,retain) IBOutlet UILabel* orderTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* playTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* peopleTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* descriptionTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* priceTimeLbl;
@property (nonatomic,retain) IBOutlet UILabel* stateTimeLbl;

@property (nonatomic,retain) IBOutlet UILabel* playTimeTitleLbl;
@property (nonatomic,retain) IBOutlet UILabel* peopleTimeTitleLbl;

@end


#pragma mark -

@interface QiuchangOrderCell_iPhone : BeeUICell

+ (CGSize)getCellSize;

@property (nonatomic,retain) QiuchangOrderCellViewController* ctrl;
@property (nonatomic,assign) id<QiuchangOrderCell_iPhoneDelegate> delegate;
@property (nonatomic,assign) EOrderCellType orderCellType;

- (void)shareOrder:(NSDictionary*)dict;

@end
