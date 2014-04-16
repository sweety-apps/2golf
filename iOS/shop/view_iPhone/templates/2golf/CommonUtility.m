//
//  CommonUtility.m
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "CommonUtility.h"
#import <CoreLocation/CoreLocation.h>

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

@end
