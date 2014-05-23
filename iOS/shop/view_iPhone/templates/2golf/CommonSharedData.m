//
//  CommonSharedData.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "CommonSharedData.h"

@implementation CommonSharedData

DEF_SINGLETON( CommonSharedData )

- (NSArray*)getContactListNames
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_selected_names"];
}

- (void)setContactListNames:(NSArray*)names
{
    if (names)
    {
        [[NSUserDefaults standardUserDefaults] setObject:names forKey:@"contact_selected_names"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (NSString *)getContactListNamesString
{
    NSArray* nameArr = [[CommonSharedData sharedInstance] getContactListNames];
    NSString* str = @"";
    int pcount = 0;
    for (NSString* name in nameArr)
    {
        if ([name length] > 0)
        {
            if (pcount > 0)
            {
                str = [str stringByAppendingString:@","];
            }
            str = [str stringByAppendingString:name];
            pcount++;
        }
    }
    return str;
}

@end
