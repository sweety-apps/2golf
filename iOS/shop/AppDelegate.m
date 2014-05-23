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
#import "AppBoard_iPad.h"
#import "AppBoard_iPhone.h"
#import "XGPush.h"


#import "BMapKit.h"

#import "model.h"

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
    return YES;
}


- (void)load
{
    // 要使用百度地图，请先启动BaiduMapManager
    
	_mapManager = [[[BMKMapManager alloc] init] retain];
	BOOL ret = [_mapManager start:@"1WYKjnr3bCwVPQbpTr1tGuXU" generalDelegate:self];
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
		self.window.rootViewController = [AppBoard_iPhone sharedInstance];
//		self.window.rootViewController = [TestBoard_iPhone sharedInstance];
	}
    
    _latitude = 114.06667f;
    _longitude = 22.61667f;
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


@end
