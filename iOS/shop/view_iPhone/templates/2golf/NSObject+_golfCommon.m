//
//  NSObject+_golfCommon.m
//  2golf
//
//  Created by Lee Justin on 14-8-14.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "NSObject+_golfCommon.h"

@implementation NSObject (_golfCommon)

- (NSArray*) _removeNSNullInArray:(NSArray*)arr
{
    NSMutableArray* retArr = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < [retArr count]; ++i)
    {
        NSObject* v = retArr[i];
        if ([v isKindOfClass:[NSNull class]])
        {
            retArr[i] = @"";
        }
        else if ([v isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* d = (NSDictionary*)v;
            d = [self _removeNSNullInDectionary:d];
            retArr[i] = d;
        }
        else if ([v isKindOfClass:[NSArray class]])
        {
            NSArray* a = (NSArray*)v;
            a = [self _removeNSNullInArray:a];
            retArr[i] = a;
        }
    }
    return retArr;
}

- (NSDictionary*) _removeNSNullInDectionary:(NSDictionary*)dict
{
    NSMutableDictionary* retDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSArray* keys = [retDict allKeys];
    for (id <NSCopying> k in keys)
    {
        NSObject* v = [retDict objectForKey:k];
        if ([v isKindOfClass:[NSNull class]])
        {
            [retDict setObject:@"" forKey:k];
        }
        else if ([v isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* d = (NSDictionary*)v;
            d = [self _removeNSNullInDectionary:d];
            [retDict setObject:d forKey:k];
        }
        else if ([v isKindOfClass:[NSArray class]])
        {
            NSArray* a = (NSArray*)v;
            a = [self _removeNSNullInArray:a];
            [retDict setObject:a forKey:k];
        }
    }
    return retDict;
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self dismissTips];
        [self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
        [self dismissTips];
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self presentFailureTips:__TEXT(@"error_network")];
        } else {
            //纠错
            dict = [self _removeNSNullInDectionary:dict];
            return dict;
        }
    }
    return nil;
}

- (NSInteger) length
{
    return 0;
}

- (NSInteger) count
{
    return 0;
}

@end
