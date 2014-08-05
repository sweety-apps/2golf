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
//  QiuchangTehuiListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangTehuiListBoard_iPhone.h"
#import "QiuchangTehuiRiziCellBoard_iPhone.h"
#import "QiuchangTehuiShiduanCellBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "QuichangDetailBoard_iPhone.h"
#import "CitySelectBoard_iPhone.h"
#import "AppDelegate.h"
#import "CommonUtility.h"

#pragma mark -

@interface QiuchangTehuiListBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
    BOOL _needRefreshData;
    BOOL _isFirstFetchData;
}

@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableDictionary* rawDataDict;

@end

@implementation QiuchangTehuiListBoard_iPhone

DEF_SIGNAL(LOCAL_RIGHT_NAV_BTN);

- (void)load
{
	[super load];
    _isFirstFetchData = YES;
}

- (void)unload
{
    //self.cellArray = nil;
    self.dataDict = nil;
    
	[super unload];
}

#pragma mark Signal

static BeeUIButton* gRightBtn = nil;
static UILabel* gRightLabel = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场特惠"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角地图按钮
        CGRect rect;
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        UILabel* rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-50,13, 100, 17)] autorelease];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:14];
        rightLabel.text = @"";
        gRightLabel = rightLabel;
        [rightBtnContainerView addSubview:rightLabel];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.LOCAL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 50, 40);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        rect = self.viewBound;
        rect.origin.y+=6+self.headView.height;
        rect.size.height-=6+self.headView.height;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.backgroundColor = [UIColor clearColor];
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
        gRightBtn = nil;
        gRightLabel = nil;
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
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6+self.headView.height;
        rect.size.height-=6+self.headView.height;
        _scroll.frame =rect;
        
        NSString* str = nil;
        //地区
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"] == nil)
        {
            NSDictionary* loc = @{
              @"is_header":@NO,
              @"is_city":@NO,
              @"city_id":@-1,
              @"province_id":@"current",
              @"name":@"当前位置",
              @"first_letter":@"",
              @"pinyin":@"",
              @"simple_pin":@"",
              @"latitude":[NSNumber numberWithDouble:[((AppDelegate*)[UIApplication sharedApplication].delegate) getCurrentLatitude]],
              @"longitude":[NSNumber numberWithDouble:[((AppDelegate*)[UIApplication sharedApplication].delegate) getCurrentLongitude]],
              @"course_sum":@0,
              @"city_expand":@[],
              @"hasExpand":@NO
              };
            [[NSUserDefaults standardUserDefaults] setObject:loc forKey:@"search_local"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        str = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"][@"name"];
        if ([str length] == 0 || [str isEqualToString:@"当前位置"])
        {
            str = @"当前位置";
        }
        else
        {
            str = [NSString stringWithFormat:@"地区|%@",str];
        }
        gRightLabel.text = str;
        
        if (_needRefreshData)
        {
            _needRefreshData = NO;
            [self onPressedShiduanBtn:self.shiduanBtn];
            [self onPressedJiagepaixuBtn:self.jiagepaixuBtn];
        }
        if (_isFirstFetchData)
        {
            _isFirstFetchData = NO;
            [self onPressedShiduanBtn:self.shiduanBtn];
            [self onPressedJiagepaixuBtn:self.jiagepaixuBtn];
        }
        [self _refreshTvWeekDaysByTime];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
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


ON_SIGNAL( signal )
{
    if ( [signal is:self.LOCAL_RIGHT_NAV_BTN] )
    {
        _needRefreshData = YES;
        [self.stack pushBoard:[CitySelectBoard_iPhone boardWithNibName:@"CitySelectBoard_iPhone"] animated:YES];
    }
}

ON_SIGNAL2( QiuchangTehuiRiziCell_iPhone, signal )
{
    int index = ((BeeUICell*)signal.source).tag;
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"specialday"][index][@"courseid"]];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2( QiuchangTehuiShiduanCell_iPhone, signal )
{
    int index = ((BeeUICell*)signal.source).tag;
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"teetime"][index][@"courseid"]];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.dataDict)
    {
        if (self.shiduanBtn.selected)
        {
            row = [self.dataDict[@"teetime"] count];
        }
        else
        {
            row = [self.dataDict[@"specialday"] count];
        }
        if (row <= 0)
        {
            self.noResultLabel.hidden = NO;
            self.noResultLabel.text = @"没有结果";
        }
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUICell * cell = nil;
    
    if (self.shiduanBtn.selected)
    {
        cell = [scrollView dequeueWithContentClass:[QiuchangTehuiShiduanCell_iPhone class]];
        cell.data = (self.dataDict[@"teetime"])[index];
    }
    else
    {
        cell = [scrollView dequeueWithContentClass:[QiuchangTehuiRiziCell_iPhone class]];
        cell.data = (self.dataDict[@"specialday"])[index];
    }
    cell.tag = index;
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 48);
}

#pragma mark -

- (void)resetCells
{
    self.rawDataDict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
    
    if (self.jiagepaixuBtn.selected)
    {
        NSString* selectTitle = [self.jiagepaixuBtn titleForState:UIControlStateNormal];
        BOOL isUp = [selectTitle rangeOfString:@"↑"].length > 0 ? YES:NO;
        
        if (self.shiduanBtn.selected)
        {
            if (isUp)
            {
                [self _reorderDataDictTeeTimeByMoneyUp];
            }
            else
            {
                [self _reorderDataDictTeeTimeByMoneyDown];
            }
        }
        else
        {
            if (isUp)
            {
                [self _reorderDataDictSpecialDayByMoneyUp];
            }
            else
            {
                [self _reorderDataDictSpecialDayByMoneyDown];
            }
        }
    }
    else
    {
        NSString* selectTitle = [self.shijianpaixuBtn titleForState:UIControlStateNormal];
        BOOL isUp = [selectTitle rangeOfString:@"↑"].length > 0 ? YES:NO;
        
        if (self.shiduanBtn.selected)
        {
            if (isUp)
            {
                [self _reorderDataDictTeeTimeByTimeUp];
            }
            else
            {
                [self _reorderDataDictTeeTimeByTimeDown];
            }
        }
        else
        {
            if (isUp)
            {
                [self _reorderDataDictSpecialDayByTimeUp];
            }
            else
            {
                [self _reorderDataDictSpecialDayByTimeDown];
            }
        }
    }
}

- (void)_reorderDataDictTeeTimeByTimeUp
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"teetime"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"][@"starttime"] doubleValue];
            double val_j = [dict_j[@"price"][@"starttime"] doubleValue];
            if (val_i > val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    self.dataDict[@"teetime"] = arr;
}

- (void)_reorderDataDictTeeTimeByTimeDown
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"teetime"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"][@"starttime"] doubleValue];
            double val_j = [dict_j[@"price"][@"starttime"] doubleValue];
            if (val_i <= val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    self.dataDict[@"teetime"] = arr;
}

- (void)_reorderDataDictTeeTimeByMoneyUp
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"teetime"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"][@"price"] doubleValue];
            double val_j = [dict_j[@"price"][@"price"] doubleValue];
            if (val_i > val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    self.dataDict[@"teetime"] = arr;
}

- (void)_reorderDataDictTeeTimeByMoneyDown
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"teetime"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"][@"price"] doubleValue];
            double val_j = [dict_j[@"price"][@"price"] doubleValue];
            if (val_i <= val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    self.dataDict[@"teetime"] = arr;
}

- (void)_reorderDataDictSpecialDayByTimeUp
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"specialday"]];
//    for (int i = 0; i < [arr count]; ++i)
//    {
//        NSDictionary* dict_i = arr[i];
//        for (int j = i + 1; j < [arr count]; ++j)
//        {
//            NSDictionary* dict_j = arr[j];
//            double val_i = [dict_i[@"price"][@"starttime"] doubleValue];
//            double val_j = [dict_j[@"price"][@"starttime"] doubleValue];
//            if (val_i > val_j)
//            {
//                id t = arr[i];
//                arr[i] = arr[j];
//                arr[j] = t;
//            }
//        }
//    }
    self.dataDict[@"specialday"] = arr;
}

- (void)_reorderDataDictSpecialDayByTimeDown
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"specialday"]];
//    for (int i = 0; i < [arr count]; ++i)
//    {
//        NSDictionary* dict_i = arr[i];
//        for (int j = i + 1; j < [arr count]; ++j)
//        {
//            NSDictionary* dict_j = arr[j];
//            double val_i = [dict_i[@"price"][@"starttime"] doubleValue];
//            double val_j = [dict_j[@"price"][@"starttime"] doubleValue];
//            if (val_i < val_j)
//            {
//                id t = arr[i];
//                arr[i] = arr[j];
//                arr[j] = t;
//            }
//        }
//    }
    self.dataDict[@"specialday"] = arr;
}

- (void)_reorderDataDictSpecialDayByMoneyUp
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"specialday"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"] doubleValue];
            double val_j = [dict_j[@"price"] doubleValue];
            if (val_i > val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    
    self.dataDict[@"specialday"] = arr;
}

- (void)_reorderDataDictSpecialDayByMoneyDown
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.rawDataDict[@"specialday"]];
    for (int i = 0; i < [arr count]; ++i)
    {
        for (int j = i + 1; j < [arr count]; ++j)
        {
            NSDictionary* dict_i = arr[i];
            NSDictionary* dict_j = arr[j];
            double val_i = [dict_i[@"price"] doubleValue];
            double val_j = [dict_j[@"price"] doubleValue];
            if (val_i < val_j)
            {
                id t = arr[i];
                arr[i] = arr[j];
                arr[j] = t;
            }
        }
    }
    
    self.dataDict[@"specialday"] = arr;
}

#pragma mark - Network


- (void)fetchData
{
    self.noResultLabel.hidden = YES;
    
    if (self.shiduanBtn.selected)
    {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"];
        self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"searchteetime"])
        .PARAM(@"longitude",dic[@"longitude"])
        .PARAM(@"latitude",dic[@"latitude"])
        .PARAM(@"scope",@"50")
        .PARAM(@"timestamp", [NSNumber numberWithLongLong:[CommonUtility getSearchTimeStamp]])
        .TIMEOUT(30);
    }
    else
    {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"];
        self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"searchspecialday"])
        .PARAM(@"longitude",dic[@"longitude"])
        .PARAM(@"latitude",dic[@"latitude"])
        .PARAM(@"scope",@"50")
        .PARAM(@"timestamp", [NSNumber numberWithLongLong:[CommonUtility getSearchTimeStamp]])
        .TIMEOUT(30);
    }
    
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [_scroll setHeaderLoading:NO];
        [self dismissTips];
        [self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
        [_scroll setHeaderLoading:NO];
        [self dismissTips];
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self presentFailureTips:__TEXT(@"error_network")];
            self.noResultLabel.text = @"网络错误,请重新搜索";
            self.noResultLabel.hidden = NO;
        } else {
            return dict;
        }
    }
    return nil;
}

- (void) handleRequest:(BeeHTTPRequest *)req
{
    NSDictionary* dict = [self commonCheckRequest:req];
    if (dict)
    {
        //球场详情
        if ([[req.url absoluteString] rangeOfString:@"searchteetime"].length > 0 || [[req.url absoluteString] rangeOfString:@"searchspecialday"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
                self.noResultLabel.text = @"网络错误,请重新搜索";
                self.noResultLabel.hidden = NO;
            }
        }
    }
}

#pragma mark - Events

-(IBAction)onPressedShiduanBtn:(id)sender
{
    self.shiduanBtn.selected = YES;
    self.riziBtn.selected = NO;
    
    self.dataDict = nil;
    [_scroll reloadData];
    [self fetchData];
}

-(IBAction)onPressedRiziBtn:(id)sender
{
    self.shiduanBtn.selected = NO;
    self.riziBtn.selected = YES;
    
    self.dataDict = nil;
    [_scroll reloadData];
    [self fetchData];
}

-(IBAction)onPressedJiagepaixuBtn:(id)sender
{
    NSString* selectTitle = [self.jiagepaixuBtn titleForState:UIControlStateNormal];
    if (self.jiagepaixuBtn.selected)
    {
        NSRange range = [selectTitle rangeOfString:@"↑"];
        if (range.length > 0)
        {
            selectTitle = [selectTitle stringByReplacingOccurrencesOfString:@"↑" withString:@"↓"];
            [self.jiagepaixuBtn setTitle:selectTitle forState:UIControlStateNormal];
        }
        else
        {
            range = [selectTitle rangeOfString:@"↓"];
            if (range.length > 0)
            {
                selectTitle = [selectTitle stringByReplacingOccurrencesOfString:@"↓" withString:@"↑"];
                [self.jiagepaixuBtn setTitle:selectTitle forState:UIControlStateNormal];
            }
        }
    }
    
    BOOL isUp = [selectTitle rangeOfString:@"↑"].length > 0 ? YES:NO;
    
    self.jiagepaixuBtn.selected = YES;
    self.shijianpaixuBtn.selected = NO;
    
    if (self.shiduanBtn.selected)
    {
        if (isUp)
        {
            [self _reorderDataDictTeeTimeByMoneyUp];
        }
        else
        {
            [self _reorderDataDictTeeTimeByMoneyDown];
        }
    }
    else
    {
        if (isUp)
        {
            [self _reorderDataDictSpecialDayByMoneyUp];
        }
        else
        {
            [self _reorderDataDictSpecialDayByMoneyDown];
        }
    }
    [_scroll reloadData];
}

-(IBAction)onPressedShijianpaixuBtn:(id)sender
{
    NSString* selectTitle = [self.shijianpaixuBtn titleForState:UIControlStateNormal];
    if (self.shijianpaixuBtn.selected)
    {
        NSRange range = [selectTitle rangeOfString:@"↑"];
        if (range.length > 0)
        {
            selectTitle = [selectTitle stringByReplacingOccurrencesOfString:@"↑" withString:@"↓"];
            [self.shijianpaixuBtn setTitle:selectTitle forState:UIControlStateNormal];
        }
        else
        {
            range = [selectTitle rangeOfString:@"↓"];
            if (range.length > 0)
            {
                selectTitle = [selectTitle stringByReplacingOccurrencesOfString:@"↓" withString:@"↑"];
                [self.shijianpaixuBtn setTitle:selectTitle forState:UIControlStateNormal];
            }
        }
    }
    
    BOOL isUp = [selectTitle rangeOfString:@"↑"].length > 0 ? YES:NO;
    
    
    self.jiagepaixuBtn.selected = NO;
    self.shijianpaixuBtn.selected = YES;
    
    if (self.shiduanBtn.selected)
    {
        if (isUp)
        {
            [self _reorderDataDictTeeTimeByTimeUp];
        }
        else
        {
            [self _reorderDataDictTeeTimeByTimeDown];
        }
    }
    else
    {
        if (isUp)
        {
            [self _reorderDataDictSpecialDayByTimeUp];
        }
        else
        {
            [self _reorderDataDictSpecialDayByTimeDown];
        }
    }
    [_scroll reloadData];
}



- (void)dealloc {
    [_btnmon release];
    [_btntwo release];
    [_btnwed release];
    [_btnthus release];
    [_btnfri release];
    [_btnsat release];
    [_btnsun release];
    [super dealloc];
}

- (IBAction)onPressedMon:(id)sender {
    [self _setSelectedTimestamp:2];
}

- (IBAction)onPressedTwo:(id)sender {
    [self _setSelectedTimestamp:3];
}

- (IBAction)onPressedWed:(id)sender {
    [self _setSelectedTimestamp:4];
}

- (IBAction)onPressedThus:(id)sender {
    [self _setSelectedTimestamp:5];
}

- (IBAction)onPressedFri:(id)sender {
    [self _setSelectedTimestamp:6];
}

- (IBAction)onPressedSat:(id)sender {
    [self _setSelectedTimestamp:7];
}

- (IBAction)onPressedSun:(id)sender {
    [self _setSelectedTimestamp:1];
    
}

-(void)_setSelectedTimestamp:(int)weekday
{
    //  先定义一个遵循某个历法的日历对象
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:[NSDate date]];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    int week = dateComponents.weekday;
    if (week >= weekday) {
        int dateoffset = 7 - (week - weekday);
        NSDate* date = [NSDate dateWithTimeInterval:dateoffset*24*60*60 sinceDate:[greCalendar dateFromComponents:dateComponents]];
        // 如果选择的日期小于等于当前日期，那么返回下周的选择的日期
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"search_time"];
    } else {
        int dateoffset = (weekday - week);
        NSDate* date = [NSDate dateWithTimeInterval:dateoffset*24*60*60 sinceDate:[greCalendar dateFromComponents:dateComponents]];
        // 如果选择的日期大于当前日期，那么返回本周选择的日期
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
    }
    [self _refreshTvWeekDaysByTime];
    [self fetchData];
//    if (mSelectedType == 0) {
//        if (btnArea.getText().toString().equalsIgnoreCase("当前位置")) {
//            dataModel.fetchTeeTime(LocationUtil.longitude,
//                                   LocationUtil.latitude, 50, mSelectedTimeStamp, -1,
//                                   false);
//        } else {
//            if (!isLocationValid()) {
//                pd = new ProgressDialog(PrivilegeListActivity.this);
//                pd.setMessage("搜索中...");
//                pd.show();
//                GeoWithBaiduUtil.shareInstance().getGeoInfo(
//                                                            mLastWatchedCity, PrivilegeListActivity.this);
//            } else {
//                dataModel.fetchTeeTime(mLastWatchedCity.longitude,
//                                       mLastWatchedCity.latitude, 50, mSelectedTimeStamp,
//                                       mLastWatchedCity.city_id,
//                                       mLastWatchedCity.international);
//            }
//        }
//    } else {
//        if (btnArea.getText().toString().equalsIgnoreCase("当前位置")) {
//            searchspecialday(LocationUtil.longitude, LocationUtil.latitude,
//                             -1, false);
//        } else {
//            if (isLocationValid()) {
//                searchspecialday(mLastWatchedCity.longitude,
//                                 mLastWatchedCity.latitude,
//                                 mLastWatchedCity.city_id,
//                                 mLastWatchedCity.international);
//            } else {
//                GeoWithBaiduUtil.shareInstance().getGeoInfo(
//                                                            mLastWatchedCity, this);
//            }
//        }
//    }
}

-(void)_refreshTvWeekDaysByTime
{
    // 初始化
    NSDate* d = [NSDate dateWithTimeIntervalSince1970:[CommonUtility getSearchTimeStamp]];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:d];
    int week = dateComponents.weekday;
    switch (week) {
		case 2:
            [self.btnmon setSelected:TRUE];
			break;
		case 3:
            [self.btntwo setSelected:TRUE];
			break;
		case 4:
            [self.btnwed setSelected:TRUE];
			break;
		case 5:
            [self.btnthus setSelected:TRUE];
			break;
		case 6:
            [self.btnfri setSelected:TRUE];
			break;
		case 7:
            [self.btnsat setSelected:TRUE];
			break;
		case 1:
            [self.btnsun setSelected:TRUE];
			break;
		default:
			break;
    }
}
@end
