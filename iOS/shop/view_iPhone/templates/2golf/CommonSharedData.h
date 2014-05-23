//
//  CommonSharedData.h
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "Bee.h"

@interface CommonSharedData : NSObject

AS_SINGLETON( CommonSharedData )

- (NSArray*)getContactListNames;
- (void)setContactListNames:(NSArray*)names;
- (NSString*)getContactListNamesString;

@end
