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
//  QiuchangDetailCollectCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@class QiuchangDetailCollectCellBoard_iPhone;

@protocol QiuchangDetailCollectCellBoard_iPhoneDelegate <NSObject>

- (void)onPressedCollect:(QiuchangDetailCollectCellBoard_iPhone*)board;
- (void)onPressedMemberVerify:(QiuchangDetailCollectCellBoard_iPhone*)board;

@end

#pragma mark -

@interface QiuchangDetailCollectCell_iPhone : BeeUICell

@property (nonatomic,retain) QiuchangDetailCollectCellBoard_iPhone* ctrl;

@end


#pragma mark -

@interface QiuchangDetailCollectCellBoard_iPhone : BeeUIBoard

@property (nonatomic,assign) id<QiuchangDetailCollectCellBoard_iPhoneDelegate> delegate;

@property (nonatomic,retain) IBOutlet UIView* upLine;
@property (nonatomic,retain) IBOutlet UIView* downLine;
@property (nonatomic,retain) IBOutlet UILabel* collectLabel;
@property (nonatomic,retain) IBOutlet UILabel* memberLabel;
@property (nonatomic,retain) IBOutlet UIButton* collectBtn;
@property (nonatomic,retain) IBOutlet UIButton* memberBtn;

- (IBAction)pressedCollect:(id)sender;
- (IBAction)pressedVerify:(id)sender;

@end
