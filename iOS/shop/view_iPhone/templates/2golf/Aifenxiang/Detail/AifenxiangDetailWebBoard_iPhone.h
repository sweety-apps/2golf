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
//  AifenxiangDetailWebBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface AifenxiangDetailWebBoard_iPhone : BeeUIBoard

AS_SIGNAL(DAIL_RIGHT_NAV_BTN);
@property (nonatomic,retain) IBOutlet BeeUIWebView* webView;
@property (nonatomic,retain) IBOutlet BeeUIWebView* webViewIP4;

-(void)setShareDetailID:(NSString*)detailID;
-(void)setSummaryDictionary:(NSDictionary*)summaryDict;

@end
