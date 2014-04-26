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

-(IBAction)onPressedShiduanBtn:(id)sender;
-(IBAction)onPressedRiziBtn:(id)sender;
-(IBAction)onPressedJiagepaixuBtn:(id)sender;
-(IBAction)onPressedShijianpaixuBtn:(id)sender;

@end
