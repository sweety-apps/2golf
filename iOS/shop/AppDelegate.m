/*
 *                                                                          
 *       _/_/_/                      _/        _/_/_/_/_/                     
 *    _/          _/_/      _/_/    _/  _/          _/      _/_/      _/_/    
 *   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/          _/      _/    _/  _/    _/   
 *  _/    _/  _/        _/        _/  _/      _/        _/    _/  _/    _/    
 *   _/_/_/    _/_/_/    _/_/_/  _/    _/  _/_/_/_/_/    _/_/      _/_/       
 *                                                                          
 *
 *  Copyright 2013-2014, Geek Zoo Studio
 *  http://www.ecmobile.cn/license.html
 *
 *  HQ China:
 *    2319 Est.Tower Van Palace 
 *    No.2 Guandongdian South Street 
 *    Beijing , China
 *
 *  U.S. Office:
 *    One Park Place, Elmira College, NY, 14901, USA
 *
 *  QQ Group:   329673575
 *  BBS:        bbs.ecmobile.cn
 *  Fax:        +86-10-6561-5510
 *  Mail:       info@geek-zoo.com
 */

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
//#import "AppBoard_iPad.h"
#import "AppBoard_iPhone.h"
#import "XGPush.h"

#import <ShareSDK/ShareSDK.h>

#import "WXApi.h"
#import "WeiboApi.h"

#import "BMapKit.h"

//#import "model.h"


#import "AlixPayResult.h"
#import "PartnerConfig.h"
#import "DataVerifier.h"
#import "MobClick.h"

#pragma mark -

@interface AppDelegate () <BMKGeneralDelegate,CLLocationManagerDelegate>
{
    double _latitude;
    double _longitude;
    CLLocationManager* _locManager;
}

@end

#pragma mark -

static BMKMapManager* _mapManager = nil;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    [self registerNofitication];
    [XGPush startApp:2200018157 appKey:@"I3VS41E2R8EI"];
	[XGPush handleLaunching: launchOptions];
    
    //清空选中时间
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"search_time"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"search_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"1e7d64041cc0" useAppTrusteeship:NO];
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    //    [ShareSDK registerApp:@"iosv1101" useAppTrusteeship:YES];
    [self initializePlat];
    
    //横屏设置
    //    [ShareSDK setInterfaceOrientationMask:UIInterfaceOrientationMaskLandscape];
    
    //监听用户信息变更
    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
                               target:self
                               action:@selector(userInfoUpdateHandler:)];
    
    [MobClick startWithAppkey:@"540c3e4afd98c565a202df5f" reportPolicy:BATCH   channelId:@"alpha"];
    
    return YES;
}


- (void)load
{
    // 要使用百度地图，请先启动BaiduMapManager
    
	_mapManager = [[[BMKMapManager alloc] init] retain];
	BOOL ret = [_mapManager start:@"LMGDSLwKfLGR4KhgYktsg5ux" generalDelegate:self];
    if (!ret) {
		NSLog(@"manager start failed!");
	}
    [_mapManager release];
    
	if ( [BeeSystemInfo isDevicePad] )
	{
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
	}
	else
	{
//        RootViewController* ctrl = [[RootViewController alloc] init];
//        UINavigationController* controller = [[UINavigationController alloc] initWithRootViewController:ctrl];
//        self.window.rootViewController = controller;
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
//		self.window.rootViewController = [TestBoard_iPhone sharedInstance];
	}
    
    _longitude = 114.1134120000;//114.02597365731999f;
    _latitude = 22.5515650000;//22.546053546204998f;
}

- (void)unload
{
}

#pragma mark - <BMKGeneralDelegate>

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        _locManager = [[CLLocationManager alloc] init];
        _locManager.delegate = self;
        _locManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locManager startUpdatingLocation];
        _locManager.distanceFilter = 1000.0f;
        
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void) registerNofitication {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice: deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [XGPush handleReceiveNotification:userInfo];
}

- (double)getCurrentLatitude
{
    return _latitude;
}

- (double)getCurrentLongitude
{
    return _longitude;
}

#pragma mark <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    _latitude = _locManager.location.coordinate.latitude;
    _longitude = _locManager.location.coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark ShareSDK 相关

- (void)initializePlat
{
    [ShareSDK statEnabled:NO];
    [ShareSDK allowExchangeDataEnabled:NO];
    [ShareSDK useAppTrusteeship:NO];
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"801513895"
                                  appSecret:@"99dab3c5ca43a97cfbf3e5b8a8e1d7ba"
                                redirectUri:@"http://www.2golf.cn"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
//    [ShareSDK connectWeChatWithAppId:@"wxa51ce6f1188bc44d" wechatCls:[WXApi class]];
    
    [ShareSDK connectWeChatWithAppId:@"wxa51ce6f1188bc44d"
                           appSecret:@"fef9e2573246ad1faf8ffad710d9f6a2"
                           wechatCls:[WXApi class]];
    
}

/**
 *	@brief	托管模式下的初始化平台
 */
- (void)initializePlatForTrusteeship
{
    //导入腾讯微博需要的外部库类型，如果不需要腾讯微博SSO可以不调用此方法
    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    [self parse:url application:application];
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [self parse:url application:application];
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)userInfoUpdateHandler:(NSNotification *)notif
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    NSInteger plat = [[[notif userInfo] objectForKey:SSK_PLAT] integerValue];
    switch (plat)
    {
        case ShareTypeSinaWeibo:
            platName = NSLocalizedString(@"TEXT_SINA_WEIBO", @"新浪微博");
            break;
       case ShareTypeTencentWeibo:
            platName = NSLocalizedString(@"TEXT_TENCENT_WEIBO", @"腾讯微博");
            break;
        default:
            platName = NSLocalizedString(@"TEXT_UNKNOWN", @"未知");
    }
    
    id<ISSPlatformUser> userInfo = [[notif userInfo] objectForKey:SSK_USER_INFO];
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = (ShareType)[[item objectForKey:@"type"] integerValue];
        if (type == plat)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:plat],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

#pragma mark 支付宝回调

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                NSLog(@"SUCCEED");
                [[[UIApplication sharedApplication] keyWindow] presentSuccessTips:@"交易成功"];
			}
        }
        else
        {
            //交易失败
            [[[UIApplication sharedApplication] keyWindow] presentFailureTips:@"交易失败"];
        }
    }
    else
    {
        //失败
        //[[[UIApplication sharedApplication] keyWindow] presentFailureTips:@"交易失败"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moneyPaid" object:nil];
    
}


@end
