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
//  QiuchangOrderResultBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface QiuchangOrderResultBoard_iPhone : BeeUIBoard
@property (retain, nonatomic) IBOutlet UIButton *backToHomeButton;

//@property (nonatomic,retain) NSMutableDictionary* priceDict;
@property (nonatomic,retain) NSMutableDictionary* dataDict;
- (IBAction)pressedBackToHome:(id)sender;

@end
