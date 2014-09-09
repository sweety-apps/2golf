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

- (void)setContactPhoneNum:(NSString*)phone
{
    if (phone)
    {
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"contact_phone_num"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString*)getContactPhoneNum
{
    NSString* ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_phone_num"];
    if (ret == nil) {
        ret = @"";
    }
    return ret;
}

- (void)setCheckedSelectedSaveUserNameAndPassword:(BOOL)checked
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checked] forKey:@"checked_saved_user_name_psw"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasCheckedSelectedSaveUserNameAndPassword
{
    NSNumber* checkedNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"checked_saved_user_name_psw"];
    if (checkedNum == nil)
    {
        return YES;
    }
    return [checkedNum boolValue];
}

- (void)saveUserName:(NSString*)username andPassword:(NSString*)pwd
{
    if ([username length] > 0 && [pwd length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"saved_user_name"];
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:@"saved_user_psw"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearsavedUserNameAndPassword
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saved_user_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"saved_user_psw"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)getSavedUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saved_user_name"];
}

- (NSString*)getSavedPawword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"saved_user_psw"];
}

@end
