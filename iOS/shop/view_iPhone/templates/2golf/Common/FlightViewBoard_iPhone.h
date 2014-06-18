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
//  FlightViewBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-6-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "NALLabelsMatrix.h"

#pragma mark -

@interface FlightViewBoard_iPhone : BeeUIBoard

@property (nonatomic,retain) IBOutlet UIButton* cancelButton;
- (IBAction)pressedCancel:(id)sender;

- (void)showViewWithDataArray:(NSArray*)dataArr;
- (void)setupCellsWithDataArray:(NSArray*)dataArr;

@end
