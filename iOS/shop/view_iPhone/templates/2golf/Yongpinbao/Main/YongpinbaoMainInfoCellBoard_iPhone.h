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
//  YongpinbaoMainInfoCellBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-23.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface YongpinbaoMainInfoCell_iPhone : BeeUICell

@property (nonatomic,retain) NSMutableArray* categoryBtns;
@property (nonatomic,retain) NSMutableArray* brandBtns;
@property (nonatomic,retain) NSMutableArray* brandImageViews;

AS_SIGNAL( TOUCHED )

@end

#pragma mark -

@interface YongpinbaoMainInfoCellBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIButton* categoryBtn0;
@property (nonatomic,retain) IBOutlet UIButton* categoryBtn1;
@property (nonatomic,retain) IBOutlet UIButton* categoryBtn2;
@property (nonatomic,retain) IBOutlet UIButton* categoryBtn3;
@property (nonatomic,retain) IBOutlet UIButton* categoryBtn4;
@property (nonatomic,retain) IBOutlet UIButton* categoryBtn5;

@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView0;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView1;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView2;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView3;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView4;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView5;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView6;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView7;
@property (nonatomic,retain) IBOutlet BeeUIImageView* brandImageView8;

@property (nonatomic,retain) IBOutlet UIButton* brandBtn0;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn1;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn2;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn3;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn4;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn5;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn6;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn7;
@property (nonatomic,retain) IBOutlet UIButton* brandBtn8;


@end
