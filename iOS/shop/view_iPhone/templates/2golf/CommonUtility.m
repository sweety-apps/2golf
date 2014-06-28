//
//  CommonUtility.m
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "CommonUtility.h"
#import "UserModel.h"
#import "AppBoard_iPhone.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"

#pragma mark -

@interface SharedLocaleDelegate : NSObject <CLLocationManagerDelegate>

@property (nonatomic,retain) CLLocationManager* locManager;
@property (nonatomic,retain) id callback;
@property (nonatomic,assign) double locX;
@property (nonatomic,assign) double locY;
@property (nonatomic,assign) double locLatitude;
@property (nonatomic,assign) double locLongitude;

AS_SINGLETON(SharedLocaleDelegate);

@end

@implementation SharedLocaleDelegate

@synthesize callback;
@synthesize locManager;
@synthesize locX;
@synthesize locY;
@synthesize locLatitude;
@synthesize locLongitude;

DEF_SINGLETON( SharedLocaleDelegate )

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.distanceFilter = 5.0;
        self.locX = -1.0;
        self.locY = -1.0;
        self.locLatitude = -1.0;
        self.locLongitude = -1.0;
    }
    return self;
}

- (void)refreshLocalPositionWithCallBack:(void (^)(BOOL succeed, float x, float y))resultBlk
{
    self.callback = resultBlk;
    [self.locManager startUpdatingLocation];
}

- (void)dealloc
{
    self.locManager = nil;
    self.callback = nil;
    [super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.locX = newLocation.coordinate.latitude;
    self.locY = newLocation.coordinate.longitude;
    self.locLatitude = newLocation.coordinate.latitude;
    self.locLongitude = newLocation.coordinate.longitude;
    if (self.callback)
    {
        void (^cb)(BOOL succeed, float x, float y) = self.callback;
        cb(YES, self.locX, self.locY);
    }
    
    self.callback = nil;
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (self.callback)
    {
        void (^cb)(BOOL succeed, float x, float y) = self.callback;
        cb(NO, self.locX, self.locY);
    }
    
    self.callback = nil;
}

@end

#pragma mark -

@implementation CommonUtility

+ (double)metersOfDistanceBetween:(double)x1 _y1:(double)y1 _x2:(double)x2 _y2:(double)y2
{
    double radLat1 = (x1 * 3.1416 / 180.0);
    double radLat2 = (x2 * 3.1416 / 180.0);
    double a = radLat1 - radLat2;
    double b = (y1 - y2) * 3.1416 / 180.0;
    double s = 2 * asin(sqrt(pow(sin(a / 2), 2)
                             + cos(radLat1) * cos(radLat2)
                             * pow(sin(b / 2), 2)));
    s = s * 6378137.0;
    s = round(s * 10000) / 10000;
    return s;
}

+ (void)refreshLocalPositionWithCallBack:(void (^)(BOOL succeed, float x, float y))resultBlk
{
    [[SharedLocaleDelegate sharedInstance] refreshLocalPositionWithCallBack:resultBlk];
}

+ (BOOL)isLastLocalPositionGotten
{
    if ([SharedLocaleDelegate sharedInstance].locX == -1 && [SharedLocaleDelegate sharedInstance].locY == -1)
    {
        return NO;
    }
    return YES;
}

+ (double)currentPositionX
{
    return [SharedLocaleDelegate sharedInstance].locX;
}

+ (double)currentPositionY
{
    return [SharedLocaleDelegate sharedInstance].locY;
}

+ (double)currentPositionLatitude
{
    return [SharedLocaleDelegate sharedInstance].locLatitude;
}

+ (double)currentPositionLongitude
{
    return [SharedLocaleDelegate sharedInstance].locLongitude;
}

+ (long) getSearchTimeStamp
{
    NSDate* searchDate = nil;
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (date == nil)
    {
        date = [NSDate dateWithTimeIntervalSinceNow:3600*24 + 3600];//明天1小时以后
    }
    
    int days = [date timeIntervalSince1970] / (3600 * 24);
    
    //时间
    date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    if (date == nil)
    {
        date = [NSDate dateWithTimeIntervalSinceNow:3600*24 + 3600];//明天1小时以后
    }
    
    int time = ((int)[date timeIntervalSince1970]) % (3600 * 24);
    
    searchDate = [NSDate dateWithTimeIntervalSince1970:(days * 3600 * 24)+time];
    
    return [searchDate timeIntervalSince1970];
}

+ (BOOL) checkLoginAndPresentLoginView
{
    if ([UserModel online])
    {
        return YES;
    }
    [[AppBoard_iPhone sharedInstance] showLogin];
    return NO;
}

+ (NSArray*) getCanSelectHourMin
{
    NSDate* tomorrowDate = [NSDate dateWithTimeIntervalSinceNow:-(3600*24)];
    NSDate* selectedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (selectedDate == nil)
    {
        selectedDate = [NSDate dateWithTimeIntervalSinceNow:0];//今天
    }
    
    NSTimeInterval startHour =  [selectedDate timeIntervalSince1970] - ((int)[selectedDate timeIntervalSince1970]) % (3600 * 24);//8点时间
    startHour += (3600 * 1);//9点后才可以选
    
    NSTimeInterval step = 10 * 60; //10分钟一档
    NSTimeInterval accumulate = 0;
    NSTimeInterval endHour = startHour + (14*3600);//最晚到11点
    NSTimeInterval tomorrowInterval = [tomorrowDate timeIntervalSince1970];
    
    NSMutableArray* ret = [NSMutableArray array];
    
    for (accumulate = startHour ; accumulate < endHour; accumulate += step)
    {
        if (accumulate > tomorrowInterval)
        {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:accumulate];
            [ret addObject:date];
        }
    }
    return ret;
}

//
+ (void)alipayCourseWithPayId:(NSString*)payId
                      ordersn:(NSString*)ordersn
                         body:(NSString*)body
                        price:(NSString*)price
               callbackTarget:(id)target
                  callbackSel:(SEL)sel
{
    /*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
    
    NSString *appScheme = @"2golfAlipay";
    
    //ordersn = @"2014062200265";
    //payId = @"43";
    //price = @"0";
    //body = @"私人定制付款";
    
    NSString* orderInfoStr = [NSString stringWithFormat:@"_input_charset=\"UTF-8\"&body=\"%@\"&it_b_pay=\"1m\"&notify_url=\"http%%3A%%2F%%2Fwww.2golf.cn%%2Frespond.php%%3Fcode%%3Dalipay\"&out_trade_no=\"%@\"&partner=\"%@\"&payment_type=\"1\"&return_url=\"http%%3A%%2F%%2Fwww.2golf.cn%%2Frespond.php%%3Fcode%%3Dalipay\"&service=\"mobile.securitypay.pay\"&seller_id=\"aigao2014@163.com\"&subject=\"%@\"&show_url=\"http://2golf.cn\"&total_fee=\"%@\""
                              ,body
                              ,[NSString stringWithFormat:@"%@%@",ordersn,payId]
                              ,PartnerID
                              ,ordersn
                              ,price];
    
    NSString* signedStr = [[self class] doRsa:orderInfoStr];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfoStr, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:sel target:target];
    
}

+ (NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

@end
