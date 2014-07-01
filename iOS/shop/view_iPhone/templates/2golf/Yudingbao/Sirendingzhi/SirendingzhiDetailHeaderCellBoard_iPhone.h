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
//  SirendingzhiDetailHeaderCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@class SirendingzhiDetailHeaderCellBoard_iPhone;

@interface SirendingzhiDetailHeaderCell_iPhone : BeeUICell

@property (nonatomic,retain) SirendingzhiDetailHeaderCellBoard_iPhone* ctrl;

@end

#pragma mark -

@interface SirendingzhiDetailHeaderCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) NSDictionary* dataDict;

@property (nonatomic,retain) IBOutlet UILabel* leftLabel0;
@property (nonatomic,retain) IBOutlet UILabel* leftLabel1;
@property (nonatomic,retain) IBOutlet UILabel* leftLabel2;
@property (nonatomic,retain) IBOutlet UILabel* leftLabel3;


@property (nonatomic,retain) IBOutlet UIButton* bgBtn0;
@property (nonatomic,retain) IBOutlet UIButton* bgBtn1;
@property (nonatomic,retain) IBOutlet UIButton* bgBtn2;
@property (nonatomic,retain) IBOutlet UIButton* bgBtn3;


@property (nonatomic,retain) IBOutlet UIButton* yudingBtn;

- (IBAction)onPressedBgBtn0:(id)sender;
- (IBAction)onPressedBgBtn1:(id)sender;
- (IBAction)onPressedBgBtn2:(id)sender;
- (IBAction)onPressedBgBtn3:(id)sender;

- (IBAction)onPressedYudingBtn:(id)sender;

- (void)resetDate;

@end
