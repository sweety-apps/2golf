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
//  WeatherViewBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface WeatherViewCellView : BeeUICell

@property (nonatomic,retain) IBOutlet UIImageView* bgImageView;
@property (nonatomic,retain) IBOutlet UILabel* leftLabel;
@property (nonatomic,retain) IBOutlet UILabel* leftLabel1;
@property (nonatomic,retain) IBOutlet UILabel* midLabel;
@property (nonatomic,retain) IBOutlet BeeUIImageView* iconImageView;

@end

#pragma mark -

@interface WeatherViewBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIView* containerView;
@property (nonatomic,retain) IBOutlet UIButton* cancelButton;

@property (nonatomic,retain) IBOutlet WeatherViewCellView* cell0;
@property (nonatomic,retain) IBOutlet WeatherViewCellView* cell1;
@property (nonatomic,retain) IBOutlet WeatherViewCellView* cell2;
@property (nonatomic,retain) IBOutlet WeatherViewCellView* cell3;

- (void)showViewWithDataDict:(NSDictionary*)dataDict;
- (IBAction)pressedCancel:(id)sender;

@end
