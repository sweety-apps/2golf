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
//  QiuchangTehuiListBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangTehuiListBoard_iPhone : BeeUIBoard

AS_SIGNAL(LOCAL_RIGHT_NAV_BTN)

@property (nonatomic,retain) IBOutlet UIView* headView;

@property (nonatomic,retain) IBOutlet UIButton* shiduanBtn;
@property (nonatomic,retain) IBOutlet UIButton* riziBtn;
@property (nonatomic,retain) IBOutlet UIButton* jiagepaixuBtn;
@property (nonatomic,retain) IBOutlet UIButton* shijianpaixuBtn;
@property (retain, nonatomic) IBOutlet UILabel *noResultLabel;
@property (retain, nonatomic) IBOutlet UIButton *btnmon;
@property (retain, nonatomic) IBOutlet UIButton *btntwo;
@property (retain, nonatomic) IBOutlet UIButton *btnwed;
@property (retain, nonatomic) IBOutlet UIButton *btnthus;
@property (retain, nonatomic) IBOutlet UIButton *btnfri;
@property (retain, nonatomic) IBOutlet UIButton *btnsat;
@property (retain, nonatomic) IBOutlet UIButton *btnsun;

-(IBAction)onPressedShiduanBtn:(id)sender;
-(IBAction)onPressedRiziBtn:(id)sender;
-(IBAction)onPressedJiagepaixuBtn:(id)sender;
-(IBAction)onPressedShijianpaixuBtn:(id)sender;
- (IBAction)onPressedMon:(id)sender;
- (IBAction)onPressedTwo:(id)sender;
- (IBAction)onPressedWed:(id)sender;
- (IBAction)onPressedThus:(id)sender;
- (IBAction)onPressedFri:(id)sender;
- (IBAction)onPressedSat:(id)sender;
- (IBAction)onPressedSun:(id)sender;

@end
