//
//  XGPush.h
//  XG-SDK
//
//  Created by xiangchen on 13-10-18.
//  Copyright (c) 2013年 mta. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XG_SDK_VERSION @"1.0.3"

@interface XGPush : NSObject

/**
 * 初始化信鸽
 * @param appId - 通过前台申请的应用ID
 * @param appKey - 通过前台申请的appKey
 * @return none
 */
+(void)startApp:(uint32_t)appId appKey:(NSString *)appKey;

/**
 * 设置设备的帐号 (在初始化信鸽后，注册设备之前调用)
 * @param account - 帐号名
 * @return none
 */
+(void)setAccount:(NSString *)account;

/**
 * 注册设备
 * @param deviceToken - 通过app delegate的didRegisterForRemoteNotificationsWithDeviceToken回调的获取
 * @return 获取的deviceToken字符串
 */
+(NSString*)registerDevice:(NSData *)deviceToken;

/**
 * 注销设备(注销最后一次使用的deviceToken信息)
 * @return none
 */
+(void)unRegisterDevice;

/**
 * 设置tag
 * @param tag - 需要设置的tag
 * @return none
 */
+(void)setTag:(NSString *)tag;

/**
 * 删除tag
 * @param tag - 需要删除的tag
 * @return none
 */
+(void)delTag:(NSString *)tag;

/**
 * 在didReceiveRemoteNotification中调用，用于推送反馈。(app在前台运行时)
 * @param userInfo
 * @return none
 */
+(void)handleReceiveNotification:(NSDictionary *)userInfo;

/**
 * 在didFinishLaunchingWithOptions中调用，用于推送反馈.(app不在前台运行时，点击推送激活时)
 * @param userInfo
 * @return none
 */
+(void)handleLaunching:(NSDictionary *)launchOptions;

@end
