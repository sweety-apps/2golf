//
//  NSObject+_golfCommon.h
//  2golf
//
//  Created by Lee Justin on 14-8-14.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface NSObject (_golfCommon)

- (NSDictionary*) _removeNSNullInDectionary:(NSDictionary*)dict;
- (NSArray*) _removeNSNullInArray:(NSArray*)arr;
- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req;
- (NSInteger) length;
- (NSInteger) count;

@end
