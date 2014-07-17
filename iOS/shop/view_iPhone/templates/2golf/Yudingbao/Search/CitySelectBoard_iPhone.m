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
//  CitySelectBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "CitySelectBoard_iPhone.h"
#import "CitySelectCellBoard_iPhone.h"
#import "CitySelectCell.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "ErrorMsg.h"
#import "MJNIndexView.h"
#import "AppDelegate.h"

#pragma mark -

@interface CitySelectCellContainer : BeeUICell
{
    CitySelectCellBoard_iPhone* _board;
}

@property (nonatomic, retain) CitySelectCell* cell;

@end


@implementation CitySelectCellContainer

@synthesize cell;

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    return CGSizeMake( width, 35.0f );
}

- (void)initSubView
{
    CitySelectCellBoard_iPhone* board = [[CitySelectCellBoard_iPhone boardWithNibName:@"CitySelectCellBoard_iPhone"] retain];
    [self addSubview:board.view];
    self.cell = (CitySelectCell*)board.view;
    _board = board;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)dealloc
{
    self.cell = nil;
    [_board release];
    [super dealloc];
}

- (void)dataDidChanged
{
    
}

@end

#pragma mark -

@interface CitySelectBoard_iPhone() <MJNIndexViewDataSource>
{
	BeeUIScrollView *	_scroll;
    MJNIndexView*       _indexView;
    BOOL                _isFirstLoad;
}
@property (nonatomic,retain) NSDictionary* provinceDataDict;
@property (nonatomic,retain) NSDictionary* cityDataDict;
@property (nonatomic,retain) NSMutableArray* dataArray;
@end

@implementation CitySelectBoard_iPhone
@synthesize provinceDataDict;
@synthesize cityDataDict;
@synthesize dataArray;

- (void)load
{
	[super load];
}

- (void)unload
{
    self.provinceDataDict = nil;
    self.cityDataDict = nil;
    self.dataArray = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self fetchData];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] || [signal is:BeeUIScrollView.FOOTER_REFRESH] )
	{
		//[[self currentModel] nextPageFromServer];
	}
}

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场搜索"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:YES animated:NO];
		[self.view addSubview:_scroll];
        
        rect.origin.y+=20;
        rect.size.height-=40;
        _indexView = [[MJNIndexView alloc]initWithFrame:rect];
        _indexView.dataSource = self;
        [self _setAttributesForMJNIndexView];
        [self.view addSubview:_indexView];
        
        //[_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        CGRect rect = self.viewBound;
        _scroll.frame =rect;
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
        //CGRect rect = self.viewBound;
        //_scroll.frame =rect;
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
        
        rect.origin.y+=20;
        rect.size.height-=40;
        _indexView.frame = rect;
        
        [self fetchData];
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

- (void)fetchData
{
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"province"]).TIMEOUT(30);
}

- (void)fetchLocationFromBaidu:(NSString*)cityName
{
    self.HTTP_GET(@"http://api.map.baidu.com/geocoder/v2/").PARAM(@"address",cityName).PARAM(@"output",@"json").PARAM(@"ak",@"pb55FxtgDEXG9qzKIOhFpGZa").TIMEOUT(30);
    [self presentLoadingTips:@"正在获取经纬度"];
}

- (void)handleDatas
{
    NSMutableArray* currentCity = [NSMutableArray array];
    NSMutableArray* hotCity = [NSMutableArray array];
    NSMutableArray* chinaCity = [NSMutableArray array];
    NSMutableArray* overseaCity = [NSMutableArray array];
    //热门表头
    [hotCity addObject:@{
                         @"is_header":@YES,
                         @"is_city":@NO,
                         @"city_id":@-1,
                         @"province_id":@-1,
                         @"name":@"热门城市列表",
                         @"first_letter":@"R",
                         @"pinyin":@"remen",
                         @"simple_pin":@"rm",
                         @"latitude":@0,
                         @"longitude":@0,
                         @"course_sum":@0,
                         @"city_expand":@[],
                         @"hasExpand":@NO,
                         @"international":@NO
                         }];
                //当前位置
    [hotCity addObject:@{
                             @"is_header":@NO,
                             @"is_city":@YES,
                             @"city_id":@-1,
                             @"province_id":@-1,
                             @"name":@"当前位置",
                             @"first_letter":@"D",
                             @"pinyin":@"dangqianweizhi",
                             @"simple_pin":@"dqwz",
                             @"latitude":@-1,
                             @"longitude":@-1,
                             @"course_sum":@0,
                             @"city_expand":@[],
                             @"hasExpand":@NO,
                             @"international":@NO
                             }];
    for (NSDictionary* city in (self.cityDataDict[@"data"])[@"city"]) {
        if ([city[@"is_hot_city"] boolValue])
        {
            [hotCity addObject:@{
                                 @"is_header":@NO,
                                 @"is_city":@YES,
                                 @"city_id":city[@"city_id"],
                                 @"province_id":city[@"province_id"],
                                 @"name":city[@"city_name"],
                                 @"first_letter":city[@"first_letter"],
                                 @"pinyin":city[@"pinyin"],
                                 @"simple_pin":city[@"simple_pin"],
                                 @"latitude":city[@"latitude"],
                                 @"longitude":city[@"longitude"],
                                 @"course_sum":@0,
                                 @"city_expand":@[],
                                 @"hasExpand":@NO,
                                 @"international":@NO
                                 }];
        }
    }
    //国内城市列表
    [chinaCity addObject:@{
                         @"is_header":@YES,
                         @"is_city":@NO,
                         @"city_id":@-1,
                         @"province_id":@-1,
                         @"name":@"国内城市列表",
                         @"first_letter":@"G",
                         @"pinyin":@"guonei",
                         @"simple_pin":@"gn",
                         @"latitude":@0,
                         @"longitude":@0,
                         @"course_sum":@0,
                         @"city_expand":@[],
                         @"hasExpand":@NO,
                         @"international":@NO
                         }];
    for (NSDictionary* province in (self.provinceDataDict[@"data"])[@"province"]) {
        if (![province[@"international"] boolValue])
        {
            [chinaCity addObject:[NSMutableDictionary
                                  dictionaryWithDictionary:
                                  @{
                                    @"is_header":@NO,
                                    @"is_city":@NO,
                                    @"city_id":@-1,
                                    @"province_id":province[@"province_id"],
                                    @"name":province[@"province_name"],
                                    @"first_letter":@"",
                                    @"pinyin":@"",
                                    @"simple_pin":@"",
                                    @"latitude":@0,
                                    @"longitude":@0,
                                    @"course_sum":province[@"course_sum"],
                                    @"city_expand":@[],
                                    @"hasExpand":@NO,
                                    @"international":@NO
                                    }]];
        }
    }
    for (NSDictionary* city in (self.cityDataDict[@"data"])[@"city"]) {
        NSNumber* provinceId = city[@"province_id"];
        if (provinceId) {
            for (NSMutableDictionary* province in chinaCity)
            {
                if([provinceId integerValue] == [province[@"province_id"] integerValue])
                {
                    NSMutableArray* arr = [NSMutableArray arrayWithArray:province[@"city_expand"]];
                    [arr addObject:@{
                                     @"is_header":@NO,
                                     @"is_city":@YES,
                                     @"city_id":city[@"city_id"],
                                     @"province_id":city[@"province_id"],
                                     @"name":city[@"city_name"],
                                     @"first_letter":city[@"first_letter"],
                                     @"pinyin":city[@"pinyin"],
                                     @"simple_pin":city[@"simple_pin"],
                                     @"latitude":city[@"latitude"],
                                     @"longitude":city[@"longitude"],
                                     @"course_sum":@0,
                                     @"city_expand":@[],
                                     @"hasExpand":@NO,
                                     @"international":@NO
                                     }];
                    province[@"city_expand"] = arr;
                }
            }
        }
    }
    //国际城市列表
    [overseaCity addObject:@{
                           @"is_header":@YES,
                           @"is_city":@NO,
                           @"city_id":@-1,
                           @"province_id":@-1,
                           @"name":@"国际城市列表",
                           @"first_letter":@"G",
                           @"pinyin":@"guoji",
                           @"simple_pin":@"gj",
                           @"latitude":@0,
                           @"longitude":@0,
                           @"course_sum":@0,
                           @"city_expand":@[],
                           @"hasExpand":@NO,
                           @"international":@YES
                           }];
    for (NSDictionary* province in (self.provinceDataDict[@"data"])[@"province"]) {
        if ([province[@"international"] boolValue])
        {
            [overseaCity addObject:[NSMutableDictionary
                                  dictionaryWithDictionary:
                                  @{
                                    @"is_header":@NO,
                                    @"is_city":@NO,
                                    @"city_id":@-1,
                                    @"province_id":province[@"province_id"],
                                    @"name":province[@"province_name"],
                                    @"first_letter":@"",
                                    @"pinyin":@"",
                                    @"simple_pin":@"",
                                    @"latitude":@0,
                                    @"longitude":@0,
                                    @"course_sum":province[@"course_sum"],
                                    @"city_expand":@[],
                                    @"hasExpand":@NO,
                                    @"international":@YES
                                    }]];
        }
    }
    for (NSDictionary* city in (self.cityDataDict[@"data"])[@"city"]) {
        NSNumber* provinceId = city[@"province_id"];
        if (provinceId) {
            for (NSMutableDictionary* province in overseaCity)
            {
                if([provinceId integerValue] == [province[@"province_id"] integerValue])
                {
                    NSMutableArray* arr = [NSMutableArray arrayWithArray:province[@"city_expand"]];
                    [arr addObject:@{
                                     @"is_header":@NO,
                                     @"is_city":@YES,
                                     @"city_id":city[@"city_id"],
                                     @"province_id":city[@"province_id"],
                                     @"name":city[@"city_name"],
                                     @"first_letter":city[@"first_letter"],
                                     @"pinyin":city[@"pinyin"],
                                     @"simple_pin":city[@"simple_pin"],
                                     @"latitude":city[@"latitude"],
                                     @"longitude":city[@"longitude"],
                                     @"course_sum":@0,
                                     @"city_expand":@[],
                                     @"hasExpand":@NO,
                                     @"international":@YES
                                     }];
                    province[@"city_expand"] = arr;
                }
            }
        }
    }
    
    //合并数据
    NSMutableArray* resArray = [NSMutableArray array];
    [resArray addObjectsFromArray:currentCity];
    [resArray addObjectsFromArray:hotCity];
    [resArray addObjectsFromArray:chinaCity];
    [resArray addObjectsFromArray:overseaCity];
    self.dataArray = resArray;
    
    _isFirstLoad = YES;
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
        //省
        if ([[req.url absoluteString] rangeOfString:@"province"].length > 0) {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.provinceDataDict = dict;
                self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"city"]).TIMEOUT(30);
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
        //市
        if ([[req.url absoluteString] rangeOfString:@"city"].length > 0) {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.cityDataDict = dict;
                [self handleDatas];
                [self _reloadDatas];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
        //百度经纬度
        if ([[req.url absoluteString] rangeOfString:@"api.map.baidu.com/geocoder"].length > 0) {
            //正确逻辑
            if ([(dict[@"status"]) intValue] == 0)
            {
                NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"]];
                mdict[@"latitude"] = dict[@"result"][@"location"][@"lat"];
                mdict[@"longitude"] = dict[@"result"][@"location"][@"lng"];
                [[NSUserDefaults standardUserDefaults] setObject:mdict forKey:@"search_local"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.stack popBoardAnimated:YES];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
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

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.dataArray)
    {
        row = [self _getCellCount];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	CitySelectCellContainer * cell = [scrollView dequeueWithContentClass:[CitySelectCellContainer class]];
    
    [self _setUpCell:cell.cell forIndex:index];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return [self _getCellSizeAtIndex:index];
}

#pragma mark - <MJNIndexViewDataSource>

- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSArray* aA = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    if (_isFirstLoad)
    {
        _isFirstLoad = NO;
        [self _resetToAlphaOrder];
        [self performSelector:@selector(_reloadDatas) withObject:nil afterDelay:0.001f];
        [self performSelector:@selector(_scrollToAlpha:) withObject:aA[index] afterDelay:0.005f];
    }
    else
    {
        [self _scrollToAlpha:aA[index]];
    }
}

#pragma mark -

- (void)_resetToAlphaOrder
{
    NSMutableArray* arr = [NSMutableArray array];
    NSArray* aA = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    for (NSString* alpha in aA)
    {
        [arr addObject:@{
                         @"is_header":@YES,
                         @"is_city":@NO,
                         @"city_id":@-1,
                         @"province_id":@-1,
                         @"name":alpha,
                         @"first_letter":alpha,
                         @"pinyin":[alpha lowercaseString],
                         @"simple_pin":[alpha lowercaseString],
                         @"latitude":@0,
                         @"longitude":@0,
                         @"course_sum":@0,
                         @"city_expand":@[],
                         @"hasExpand":@NO,
                         @"international":@NO
                         }];
    }
    
    
    for (NSDictionary* city in (self.cityDataDict[@"data"])[@"city"])
    {
        NSInteger index = 0;
        for (int i = 0; i < [arr count]; ++i)
        {
            NSDictionary* dict = arr[i];
            if ([[dict[@"first_letter"] uppercaseString] isEqualToString:[city[@"first_letter"] uppercaseString]])
            {
                index = i;
            }
        }
        
        [arr insertObject:@{
                            @"is_header":@NO,
                            @"is_city":@YES,
                            @"city_id":city[@"city_id"],
                            @"province_id":city[@"province_id"],
                            @"name":city[@"city_name"],
                            @"first_letter":city[@"first_letter"],
                            @"pinyin":city[@"pinyin"],
                            @"simple_pin":city[@"simple_pin"],
                            @"latitude":city[@"latitude"],
                            @"longitude":city[@"longitude"],
                            @"course_sum":@0,
                            @"city_expand":@[],
                            @"hasExpand":@NO,
                            @"international":city[@"international"]
                            }
                  atIndex:index + 1];
    }
    
    self.dataArray = arr;
}

- (void)_scrollToAlpha:(NSString*)alpha
{
    NSInteger index = 0;
    for (int i = 0; i < [self.dataArray count]; ++i)
    {
        NSDictionary* city = self.dataArray[i];
        if ([[city[@"first_letter"] uppercaseString] isEqualToString:[alpha uppercaseString]])
        {
            index = i;
            break;
        }
    }
    
    [_scroll scrollToIndex:index headMatch:YES animated:YES];
}

- (void)_onPressedCell:(UIButton*)cellBg
{
    NSInteger index = cellBg.tag;
    NSDictionary* province = self.dataArray[index];
    if ([province[@"is_header"] boolValue])
    {
    }
    else if (![province[@"is_city"] boolValue] && [province[@"city_expand"] count] > 0)
    {
        if ([province[@"hasExpand"] boolValue])
        {
            [self _closeProvince:index];
        }
        else
        {
            [self _expandProvinceAtIndex:index];
        }
    }
    else
    {
        NSMutableDictionary* mdict = [NSMutableDictionary dictionaryWithDictionary:province];
        if ([mdict[@"longitude"] doubleValue] < 0.000001
            || [mdict[@"latitude"] doubleValue] < 0.000001)
        {
            mdict[@"latitude"] = [NSNumber numberWithDouble:[(AppDelegate*)[AppDelegate sharedInstance] getCurrentLatitude]];
            mdict[@"longitude"] = [NSNumber numberWithDouble:[(AppDelegate*)[AppDelegate sharedInstance] getCurrentLongitude]];
        }
        mdict[@"city_id"] = province[@"city_id"];
        mdict[@"name"] = province[@"name"];
        if (province[@"international"] == nil)
        {
            mdict[@"international"] = @NO;
        }
        else
        {
            mdict[@"international"] = province[@"international"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:mdict forKey:@"search_local"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([province[@"name"] isEqualToString:@"当前位置"])
        {
            [self.stack popBoardAnimated:YES];
        }
        else
        {
            [self fetchLocationFromBaidu:province[@"name"]];
        }
    }
}

- (void)_expandProvinceAtIndex:(NSInteger)index
{
    NSMutableDictionary* province = self.dataArray[index];
    if ([province[@"is_header"] boolValue])
    {
    }
    else if (![province[@"is_city"] boolValue] && [province[@"city_expand"] count] > 0)
    {
        NSArray* arr = province[@"city_expand"];
        for (int i = [arr count] - 1; i >= 0; i--)
        {
            NSDictionary* city = arr[i];
            [self.dataArray insertObject:city atIndex:index+1];
        }
        
        province[@"hasExpand"] = @YES;
        
        [self _reloadDatas];
    }
}

- (void)_closeProvince:(NSInteger)index
{
    NSMutableDictionary* province = self.dataArray[index];
    if ([province[@"is_header"] boolValue])
    {
    }
    else if (![province[@"is_city"] boolValue] && [province[@"city_expand"] count] > 0)
    {
        NSArray* arr = province[@"city_expand"];
        for (int i = [arr count] - 1; i >= 0; i--)
        {
            [self.dataArray removeObjectAtIndex:index+1];
        }
        
        province[@"hasExpand"] = @NO;
        
        [self _reloadDatas];
    }
}

- (CGSize)_getCellSizeAtIndex:(NSInteger)index
{
    if (self.dataArray)
    {
        NSDictionary* province = self.dataArray[index];
        
        if ([province[@"is_header"] boolValue])
        {
            return CGSizeMake(_scroll.frame.size.width, 34);
        }
        else if (![province[@"is_city"] boolValue] && [province[@"city_expand"] count] > 0)
        {
            return CGSizeMake(_scroll.frame.size.width, 32);
        }
        else
        {
            return CGSizeMake(_scroll.frame.size.width, 32);
        }
    }
    return CGSizeZero;
}

- (NSInteger)_getCellCount
{
    NSInteger row = 0;
    row += [self.dataArray count];
    
    return row;
}

- (void)_setUpCell:(CitySelectCell*)cell  forIndex:(NSInteger)index
{
    if (self.dataArray)
    {
        NSDictionary* province = self.dataArray[index];
        
        NSDictionary* provincePre = 0 > (index-1) ? nil : self.dataArray[index-1];
        NSDictionary* provinceNext = [self.dataArray count] > (index+1)? self.dataArray[index+1] : nil;
        
        cell.cellTitle.text = province[@"name"];
        if ([province[@"is_header"] boolValue])
        {
            [cell setBeHeaderS];
        }
        else if (![province[@"is_city"] boolValue] && [province[@"city_expand"] count] > 0)
        {
            cell.cellTitle.text = [NSString stringWithFormat:@"%@(%@)",province[@"name"],province[@"course_sum"]];
            if (provincePre == nil || [provincePre[@"is_header"] boolValue])
            {
                [cell setBeContentExpH];
                if (provinceNext==nil || [provinceNext[@"is_header"] boolValue])
                {
                    [cell setBeContentExpS];
                }
            }
            else if (provinceNext==nil || [provinceNext[@"is_header"] boolValue])
            {
                [cell setBeContentExpB];
            }
            else
            {
                [cell setBeContentExpM];
            }
            
            [cell setExpand: [province[@"hasExpand"] boolValue]];
        }
        else
        {
            if (provincePre == nil || [provincePre[@"is_header"] boolValue])
            {
                [cell setBeContentH];
                if (provinceNext==nil || [provinceNext[@"is_header"] boolValue])
                {
                    [cell setBeContentS];
                }
            }
            else if (provinceNext==nil || [provinceNext[@"is_header"] boolValue])
            {
                [cell setBeContentB];
            }
            else
            {
                [cell setBeContentM];
            }
        }
        
        cell.cellBg.tag = index;
        [cell.cellBg addTarget:self action:@selector(_onPressedCell:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)_reloadDatas
{
    [_scroll reloadData];
    [_indexView refreshIndexItems];
}

- (void)_setAttributesForMJNIndexView
{
    _indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    _indexView.font = [UIFont systemFontOfSize:13];
    _indexView.selectedItemFont = [UIFont boldSystemFontOfSize:40];
    _indexView.backgroundColor = [UIColor clearColor];
    _indexView.curtainColor = nil;
    _indexView.curtainFade = 0.0;
    _indexView.curtainStays = NO;
    _indexView.curtainMoves = YES;
    _indexView.curtainMargins = NO;
    _indexView.ergonomicHeight = NO;
    _indexView.upperMargin = 10.0;
    _indexView.lowerMargin = 10.0;
    _indexView.rightMargin = 24.0;
    _indexView.itemsAligment = NSTextAlignmentCenter;
    _indexView.maxItemDeflection = 120.0;
    _indexView.rangeOfDeflection = 5;
    _indexView.fontColor = RGBA(16, 88, 38, 1);
    _indexView.selectedItemFontColor = RGBA(0, 0, 0, 1);
    _indexView.darkening = NO;
    _indexView.fading = YES;
    
}

@end
