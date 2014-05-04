//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  SouSuoQiuChangBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"
#import "BaseBoard_iPhone.h"

#pragma mark -

@interface SouSuoQiuChangBoard_iPhone : BaseBoard_iPhone

@property (nonatomic,retain) IBOutlet UILabel* lblLocal;
@property (nonatomic,retain) IBOutlet UILabel* lblKeywords;
@property (nonatomic,retain) IBOutlet UILabel* lblDate;
@property (nonatomic,retain) IBOutlet UILabel* lblTime;
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic,retain) IBOutlet UIView* scrollContentView;

- (IBAction)onPressedLocal:(id)sender;
- (IBAction)onPressedDate:(id)sender;
- (IBAction)onPressedTime:(id)sender;
- (IBAction)onPressedKeywords:(id)sender;
- (IBAction)onPressedSearch:(id)sender;

@end
