//
//  CommonUtility.h
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface CommonUtility : NSObject

#pragma mark locale

+ (void)refreshLocalPositionWithCallBack:(void (^)(BOOL succeed, float x, float y))resultBlk;
+ (double)metersOfDistanceBetween:(double)x1 _y1:(double)y1 _x2:(double)x2 _y2:(double)y2;
+ (BOOL)isLastLocalPositionGotten;
+ (double)currentPositionX;
+ (double)currentPositionY;
+ (double)currentPositionLatitude;
+ (double)currentPositionLongitude;
+ (long) getSearchTimeStamp;
+ (BOOL) checkLoginAndPresentLoginView;
+ (NSArray*) getCanSelectHourMin;

+ (void)alipayCourseWithPayId:(NSString*)payId
                      ordersn:(NSString*)ordersn
                         body:(NSString*)body
                        price:(NSString*)price
               callbackTarget:(id)target
                  callbackSel:(SEL)sel;

@end
