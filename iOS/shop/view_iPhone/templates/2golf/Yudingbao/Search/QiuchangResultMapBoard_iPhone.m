//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  QiuchangResultMapBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangResultMapBoard_iPhone.h"
#import "BMapKit.h"
#import "CommonUtility.h"
#import "QuichangDetailBoard_iPhone.h"

#pragma mark -

@interface QiuchangResultMapBoard_iPhone() <BMKMapViewDelegate>
{
	BMKMapView* _mapView;
}

@property (nonatomic,retain) NSMutableArray* pointViews;
@property (nonatomic,retain) NSMutableArray* dataArray;

@end

@implementation QiuchangResultMapBoard_iPhone

@synthesize pointViews;
@synthesize dataArray;

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"地图"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        
        _mapView = [[BMKMapView alloc] initWithFrame:rect];
        _mapView.userInteractionEnabled = YES;
        _mapView.delegate = self;
        [_mapView setOpaque:YES];
        [self.view setOpaque:YES];
        
        [self.view addSubview:_mapView];
        //self.view.backgroundColor = [UIColor redColor];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        self.pointViews = nil;
        SAFE_RELEASE_SUBVIEW( _mapView );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _mapView.frame = rect;
        _mapView.backgroundColor = [UIColor clearColor];
        [_mapView viewWillAppear];
        
        [_mapView setZoomLevel:11.5];
        _mapView.delegate = self;
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [_mapView viewWillDisappear];
        _mapView.delegate = nil;
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

#pragma mark -

- (void)_removeAllAnotations
{
    for (BMKPointAnnotation* anotation in self.pointViews)
    {
        [_mapView removeAnnotation:anotation];
    }
}

- (void)_createAllAnotations
{
    if (self.pointViews == nil)
    {
        self.pointViews = [NSMutableArray array];
    }
    
    double maxLatitude  = -1.0;
    double maxLongitude  = -1.0;
    
    double minLatitude  = 99999999999999999.0;
    double minLongitude  = 99999999999999999.0;
    
    for (NSDictionary* course in self.dataArray)
    {
        BMKPointAnnotation* pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [(course[@"latitude"]) doubleValue];
        coor.longitude = [(course[@"longitude"]) doubleValue];
        
        if (coor.latitude > maxLatitude)
        {
            maxLatitude = coor.latitude;
        }
        if (coor.longitude > maxLongitude)
        {
            maxLongitude = coor.longitude;
        }
        
        if (coor.latitude < minLatitude)
        {
            minLatitude = coor.latitude;
        }
        if (coor.longitude < minLongitude)
        {
            minLongitude = coor.longitude;
        }
        
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = [NSString stringWithFormat:@"%i",[self.dataArray indexOfObject:course]];
        pointAnnotation.subtitle = @"此Annotation可拖拽!";
        [_mapView addAnnotation:pointAnnotation];
        
        [self.pointViews addObject:pointAnnotation];
        [pointAnnotation release];
    }
    
    CLLocationCoordinate2D centerCoor;
    centerCoor.latitude = (minLatitude + maxLatitude) * 0.5f;
    centerCoor.longitude = (minLongitude + maxLongitude) * 0.5f;
    [_mapView setCenterCoordinate:centerCoor];
}

- (void)setPoints:(NSArray*)dataArr
{
    [self _removeAllAnotations];
    self.dataArray = [NSMutableArray arrayWithArray:dataArr];
    [self _createAllAnotations];
}

- (void)_onPressedFlag:(UIButton*)btn
{
    NSInteger index = btn.tag;
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataArray[index][@"course_id"]];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - <BMKMapViewDelegate>

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
//        BMKGroundOverlayView* groundView = [[[BMKGroundOverlayView alloc] initWithOverlay:overlay] autorelease];
//		return groundView;
    }
	return nil;
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    BMKAnnotationView *newAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    newAnnotation.frame = CGRectMake(0, 0, 90, 24);
    newAnnotation.enabled = YES;
    //newAnnotation.draggable = YES;
    newAnnotation.backgroundColor = RGBA(0, 0, 0, 0.0f);
    //newAnnotation.userInteractionEnabled = YES;
    
    NSInteger index = [[annotation title] integerValue];
    NSString* text = @"";
    
    if (index != NSNotFound)
    {
        text = (self.dataArray[index])[@"shortname"];
    }
    
    CGRect rect;
    
    rect = CGRectMake(0, 0, 90, 24);
    rect.size.width = [text sizeWithFont:[UIFont  systemFontOfSize:20.f]].width + 33;
    UIView* bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
    bgView.backgroundColor = RGBA(0, 0, 0, 0.4f);
    bgView.userInteractionEnabled = YES;
    [newAnnotation addSubview:bgView];
    
    rect = CGRectMake(27, 0, 90-27, 24);
    rect.size.width = [text sizeWithFont:[UIFont  systemFontOfSize:20.f]].width + 5;
    UILabel* label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.font = [UIFont systemFontOfSize:20.f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [newAnnotation addSubview:label];
    
    UIImageView* iconFlag = [[[UIImageView alloc] initWithImage:__IMAGE(@"select_text_poi")] autorelease];
    iconFlag.frame = CGRectMake(2, 2, iconFlag.frame.size.width, iconFlag.frame.size.height);
    [newAnnotation addSubview:iconFlag];
    
    rect = bgView.frame;
    rect.origin = CGPointZero;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(_onPressedFlag:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = index;
    [newAnnotation addSubview:btn];
    
    return newAnnotation;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}

@end
