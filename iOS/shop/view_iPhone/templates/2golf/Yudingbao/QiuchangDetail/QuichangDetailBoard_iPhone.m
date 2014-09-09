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
//  QuichangDetailBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QuichangDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "Placeholder.h"
#import "ServerConfig.h"
#import "QiuchangOrderEditBoard_iPhone.h"
#import "QiuchangVipVerifyBoard_iPhone.h"
#import "PhotoSlideViewBoard_iPhone.h"
#import "QiuchangDetailDescriptionBoard_iPhone.h"
#import "CommonUtility.h"
#import "WeatherViewBoard_iPhone.h"
#import "UserModel.h"

#pragma mark -

@interface QiuchangBannerPhotoCell_iPhone()
{
	BeeUIImageView * _image;
}
@end

#pragma mark -

@implementation QiuchangBannerPhotoCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
	self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
	_image = [[BeeUIImageView alloc] init];
    _image.image = [Placeholder image];
	_image.contentMode = UIViewContentModeScaleAspectFill;
	_image.indicatorStyle = UIActivityIndicatorViewStyleGray;
	[self addSubview:_image];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _image );
	
	[super unload];
}

- (void)layoutDidFinish
{
	_image.frame = self.bounds;
}

- (void)setImageUrl:(NSString*)url
{
    [_image GET:url useCache:YES];
}

- (void)dataDidChanged
{
    [self setImageUrl:self.data[@"thumb"]];
}

@end

#pragma mark -

@implementation QiuchangBannerCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@synthesize shadow = _shadow;
@synthesize scroll = _scroll;
@synthesize pageControl = _pageControl;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;
@synthesize arrowImg = _arrowImg;
@synthesize detailBtn = _detailBtn;

- (void)load
{
    [super load];
    
    self.scroll = [[[BeeUIScrollView alloc] init] autorelease];
	self.scroll.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    self.scroll.dataSource = self;
    self.scroll.horizontal = YES;
    self.scroll.pagingEnabled = YES;
    [self addSubview:self.scroll];
	
    self.shadow = [[[UIView alloc] init] autorelease];
    self.shadow.backgroundColor = RGBA(0, 0, 0, 0.45);;//RGBA(0, 180, 0, 0.3);
    [self addSubview:self.shadow];
    
    self.leftLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(22, 0, 200, 40)] autorelease];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.text = @"";
    [self.shadow addSubview:self.leftLabel];
    
    self.rightLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(256, 0, 100, 40)] autorelease];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    self.rightLabel.text = @"详情";
    [self.shadow addSubview:self.rightLabel];
    
    self.arrowImg = [[[UIImageView alloc] initWithImage:__IMAGE(@"expand_left_white")] autorelease];
    self.arrowImg.frame = CGRectMake(287, 15, self.arrowImg.frame.size.width, self.arrowImg.frame.size.height);
    [self.shadow addSubview:self.arrowImg];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.frame = CGRectMake(0, 0, 320, 40);
    [self.shadow addSubview:self.detailBtn];
    
    [self.detailBtn addTarget:self action:@selector(_pressedDetail:) forControlEvents:UIControlEventTouchUpInside];
    
	self.pageControl = [[[BeeUIPageControl alloc] init] autorelease];
	self.pageControl.hidesForSinglePage = NO;
	self.pageControl.layer.cornerRadius = 8.0f;
	self.pageControl.layer.shadowColor = RGBA(230, 240, 243, 1.0).CGColor;
    self.pageControl.pageIndicatorTintColor = RGBA(230, 240, 243, 1.0);
    self.pageControl.currentPageIndicatorTintColor = RGBA(15, 165, 247, 1.0);
	self.pageControl.layer.shadowOffset = CGSizeMake( 0.0f, 0.0f );
	self.pageControl.layer.shadowRadius = 0.0f;
	self.pageControl.layer.shadowOpacity = 1.0f;
    
    self.pageControl.hidden = YES;
	[self addSubview:self.pageControl];
    
    //[[self superview] superview].board
}

- (void)unload
{
    self.shadow = nil;
	self.scroll = nil;
	self.pageControl = nil;
	self.leftLabel = nil;
    self.rightLabel = nil;
    self.arrowImg = nil;
    self.detailBtn = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    self.scroll.frame = self.bounds;
	[_scroll reloadData];
    
    CGRect shadowFrame = CGRectMake(0, self.scroll.height - 40, 320, 40);
    self.shadow.frame = shadowFrame;
	
	CGRect controlFrame;
	controlFrame.size.width = 60.0f;
	controlFrame.size.height = 16.0f;
	controlFrame.origin.x = 230;
	controlFrame.origin.y = self.height - controlFrame.size.height - 1.0f;
	self.pageControl.frame = controlFrame;
}

- (void)dataDidChanged
{
    if (self.data)
    {
        self.leftLabel.text = self.data[@"slogan"];
    }
}

#pragma mark -

ON_SIGNAL2( BeeUIScrollView , signal)
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.DID_STOP] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
	else if ( [signal is:BeeUIScrollView.RELOADED] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
}

#pragma mark -

- (void)_pressedDetail:(UIButton*)btn
{
    //QiuchangDetailDescriptionBoard_iPhone* board = [QiuchangDetailDescriptionBoard_iPhone boardWithNibName:@"QiuchangDetailDescriptionBoard_iPhone"];
    QiuchangDetailDescriptionBoard_iPhone* board = [QiuchangDetailDescriptionBoard_iPhone board];
    [[self recursiveFindUIBoard].stack pushBoard:board animated:YES];
    [board setDataDictionary:self.data];
    
    /*
    QiuchangVipVerifyBoard_iPhone* newBoard = [QiuchangVipVerifyBoard_iPhone boardWithNibName:@"QiuchangVipVerifyBoard_iPhone"];
    [[self recursiveFindUIBoard].stack pushBoard:newBoard animated:YES];
     */
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return ((NSArray *)(self.data[@"img"])).count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    QiuchangBannerPhotoCell_iPhone * cell = [scrollView dequeueWithContentClass:[QiuchangBannerPhotoCell_iPhone class]];
    cell.data = (self.data[@"img"])[index];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return scrollView.bounds.size;
}

@end


#pragma mark -

@interface QuichangDetailBoard_iPhone() <QiuchangDetailPriceContentCell_iPhoneDelegate,QiuchangDetailCollectCellBoard_iPhoneDelegate,
    QiuchangDetailInfoCell_iPhoneDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
	BeeUIScrollView *	_scroll;
    NSString* _courseId;
    UIView* _pickerBg;
    UIPickerView* _picker;
}

@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableDictionary* weatherDataDict;

@property (nonatomic,retain) WeatherViewBoard_iPhone* weatherBoard;

@end

#pragma mark -

@implementation QuichangDetailBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

- (void)load
{
	[super load];
    
    self.collectionModel = [CollectionModel sharedInstance];
	[self.collectionModel addObserver:self];
}

- (void)unload
{
    self.cellArray = nil;
    self.dataDict = nil;
    [_courseId release];
    
    [self.collectionModel removeObserver:self];
    self.collectionModel = nil;
    [_picker release];
    [_pickerBg release];
    
	[super unload];
}

- (void) setCourseId:(NSString*)courseId
{
    [courseId retain];
    [_courseId release];
    _courseId = courseId;
}

#pragma mark Signal

static BeeUIButton* gRightBtn = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"正在加载"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角地图按钮
        CGRect rect;
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        UIImageView* rightIcon = [[[UIImageView alloc] initWithImage:__IMAGE(@"weathericon")] autorelease];
        rightIcon.frame = CGRectMake(0, 13, 17, 17);
        rightIcon.contentMode = UIViewContentModeTopLeft;
        [rightBtnContainerView addSubview:rightIcon];
        
        UILabel* rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(17,13, 50-17, 17)] autorelease];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.text = @"天气";
        [rightBtnContainerView addSubview:rightLabel];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 50, 40);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.backgroundColor = [UIColor clearColor];
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        
        rect = self.view.frame;
        rect.origin = CGPointZero;
        
        _pickerBg = [[UIView alloc] initWithFrame:rect];
        _pickerBg.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:_pickerBg];
        [_pickerBg setHidden:YES];
        
        _picker = [[UIPickerView alloc] init];
        _picker.showsSelectionIndicator = YES;
        rect = _picker.frame;
        rect.origin = CGPointZero;
        rect.origin.y = _pickerBg.frame.size.height - rect.size.height;
        _picker.frame = rect;
        _picker.delegate = self;
        _picker.dataSource = self;
        
        UIView* bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
        bgView.backgroundColor = RGBA(255, 255, 255, 1.0);
        [_pickerBg addSubview:bgView];
        
        
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor clearColor];
        rect.size.height = rect.origin.y;
        rect.origin.x = 0;
        cancelBtn.frame = rect;
        [cancelBtn addTarget:self action:@selector(_onCancelTimeSelect) forControlEvents:UIControlEventTouchUpInside];
        [_pickerBg addSubview:cancelBtn];
        
        [_pickerBg addSubview:_picker];
        
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
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
        
        //日期
        NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
        if (date == nil)
        {
            date = [CommonUtility getDateFromZeroPerDay:[NSDate now]];
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
        }
        NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
        BOOL b = time == nil;
        BOOL b1 = (time.year != date.year) ;
        BOOL b2 = (time.month != date.month) ;
        BOOL b3 = (time.day != date.day) ;
        if (b || b1|| b2 || b3) {
            //未選事件或者日期改了的話，就從新設置下
            NSArray* array = [CommonUtility getCanSelectHourMin];
            if (date.istoday) {
                if (array.count == 0) {
                    //超出范围,得到当前时间的最近的半个钟
                    time = [NSDate dateWithTimeInterval:3600*2 sinceDate:[CommonUtility getNearestHalfTime:[NSDate now]] ];
                }
                else
                {
                    time = array[0];
                }
            }
            else
            {
                time = array[5];//9點開始
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"search_time"];
        }
        else
        {
            
        }
        [self resetCells];
        [_picker reloadAllComponents];
        
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
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        //打开天气
        [self showWetherView];
    }
}

ON_SIGNAL2( QiuchangBannerPhotoCell_iPhone, signal )
{
    PhotoSlideViewBoard_iPhone * board = [PhotoSlideViewBoard_iPhone board];
    board.pictures = self.dataDict[@"img"];
	//board.pageIndex = [self.goodsModel.goods.pictures indexOfObject:photo];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (true)
    {
        row = [self.cellArray count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUICell* cell = self.cellArray[index];
    //
    if ([cell isKindOfClass:[QiuchangBannerCell_iPhone class]])
    {
        cell.data = self.dataDict;
    }
    return self.cellArray[index];
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    BeeUICell * cell = self.cellArray[index];
	return cell.frame.size;
}

#pragma mark -

- (void)resetCells
{
    if (self.cellArray == nil)
    {
        self.cellArray = [NSMutableArray array];
    }
    [self.cellArray removeAllObjects];
    
    BOOL hasPriceHeader = NO;
    BeeUICell * priceHeaderCell = nil;
    
    //banner
    BeeUICell * cell = [[[QiuchangBannerCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 146)] autorelease];
    //cell.data = self.dataDict;
    [self.cellArray addObject:cell];
    
    //头
    cell = [[QiuchangDetailInfoCell_iPhone alloc] initWithFrame:CGRectZero];
    ((QiuchangDetailInfoCell_iPhone*)cell).delegate = self;
    cell.data = self.dataDict;
    [self.cellArray addObject:cell];
    
    //球会价格列表
    cell = [[QiuchangDetailPriceHeaderCell_iPhone alloc] initWithFrame:CGRectZero];
    cell.data = @"球会官方直销";
    [self.cellArray addObject:cell];
    
    priceHeaderCell = cell;
    hasPriceHeader = NO;
    
    for (NSDictionary* price in self.dataDict[@"price"])
    {
        if ([price[@"distributortype"] integerValue] == 0)
        {
            cell = [[QiuchangDetailPriceContentCell_iPhone alloc] initWithFrame:CGRectZero];
            cell.data = price;
            ((QiuchangDetailPriceContentCell_iPhone*)cell).delegate = self;
            [self.cellArray addObject:cell];
            hasPriceHeader = YES;
        }
    }
    
    if (!hasPriceHeader)
    {
        [self.cellArray removeObject:priceHeaderCell];
    }
    
    //服务商价格列表
    cell = [[QiuchangDetailPriceHeaderCell_iPhone alloc] initWithFrame:CGRectZero];
    cell.data = @"服务商";
    [self.cellArray addObject:cell];
    
    priceHeaderCell = cell;
    hasPriceHeader = NO;
    
    for (NSDictionary* price in self.dataDict[@"price"])
    {
        if ([price[@"distributortype"] integerValue] == 1)
        {
            cell = [[QiuchangDetailPriceContentCell_iPhone alloc] initWithFrame:CGRectZero];
            cell.data = price;
            ((QiuchangDetailPriceContentCell_iPhone*)cell).delegate = self;
            [self.cellArray addObject:cell];
            hasPriceHeader = YES;
        }
    }
    
    if (!hasPriceHeader)
    {
        [self.cellArray removeObject:priceHeaderCell];
    }
    
    //收藏和会员验证
    cell = [[QiuchangDetailCollectCell_iPhone alloc] initWithFrame:CGRectZero];
    cell.data = self.dataDict;
    ((QiuchangDetailCollectCell_iPhone*)cell).ctrl.delegate = self;
    [self.cellArray addObject:cell];
    
    //底
    cell = [[QiuchangDetailBottomCell_iPhone alloc] initWithFrame:CGRectZero];
    cell.data = self.dataDict;
    [self.cellArray addObject:cell];
    
    //navigation title
    [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:self.dataDict[@"coursename"]];
}

- (void)showWetherView
{
    if (self.weatherDataDict && [[self.weatherDataDict allKeys] count] > 0)
    {
        self.weatherBoard = [WeatherViewBoard_iPhone boardWithNibName:@"WeatherViewBoard_iPhone"];
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.weatherBoard.view];
        [self.weatherBoard showViewWithDataDict:self.weatherDataDict];
    }
    else
    {
        [self presentFailureTips:@"暂无该城市的天气情况"];
    }
}

#pragma mark - Network


- (void)fetchData
{
    NSString* ts = [NSString stringWithFormat:@"%ld",[CommonUtility getSearchTimeStamp]];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"coursedetail"]).PARAM(@"courseid",_courseId).PARAM(@"timestamp",ts).TIMEOUT(30);
}

- (void)fetchWeather
{
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"weather"]).PARAM(@"city",self.dataDict[@"cityname"]).TIMEOUT(30);
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    return [super commonCheckRequest:req];
}

- (void) handleRequest:(BeeHTTPRequest *)req
{
    NSDictionary* dict = [self commonCheckRequest:req];
    if (dict)
    {
        //球场详情
        if ([[req.url absoluteString] rangeOfString:@"coursedetail"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self fetchWeather];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
        //天气数据
        else if ([[req.url absoluteString] rangeOfString:@"weather"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [self dismissTips];
                self.weatherDataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"][@"results"][0])];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self dismissTips];
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

#pragma mark <QiuchangDetailPriceContentCell_iPhoneDelegate>

- (void)onPressedPriceButton:(QiuchangDetailPriceContentCell_iPhone*)cell
{
    QiuchangOrderEditBoard_iPhone* board = [QiuchangOrderEditBoard_iPhone boardWithNibName:@"QiuchangOrderEditBoard_iPhone"];
    [board setUpCourseData:self.dataDict];
    [board setUpPriceData:cell.data];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark <QiuchangDetailCollectCellBoard_iPhoneDelegate>

- (void)onPressedCollect:(QiuchangDetailCollectCellBoard_iPhone*)board
{
    if (![CommonUtility checkLoginAndPresentLoginView])
    {
        return;
    }
    
    [self.collectionModel collectCourse:self.dataDict[@"course_id"]];
    [self presentLoadingTips:@"正在收藏"];
}

- (void)onPressedMemberVerify:(QiuchangDetailCollectCellBoard_iPhone*)board
{
    QiuchangVipVerifyBoard_iPhone* newBoard = [QiuchangVipVerifyBoard_iPhone boardWithNibName:@"QiuchangVipVerifyBoard_iPhone"];
    newBoard.courseId = _courseId;
    [self.stack pushBoard:newBoard animated:YES];
}

#pragma mark <QiuchangDetailInfoCell_iPhoneDelegate>

- (void)qiuchangDetailInfoCell:(QiuchangDetailInfoCell_iPhone*)cell
             shouldRefreshData:(long)timestamp
{
    [self fetchData];
}

-(void)onClickTime:(id)sender
{
    NSArray* array = [CommonUtility getCanSelectHourMin];
    if ([array count] == 0) {
        return;
    }
    [_pickerBg setHidden:NO];
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    if (time != nil) {
        for (int i = 0; i < [[CommonUtility getCanSelectHourMin] count]; i++) {
            if ([time isEqualToDate:[[CommonUtility getCanSelectHourMin] objectAtIndex:i]]) {
                [_picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    if ( [msg is:API.user_collect_create] )
    {
        if ( msg.sending )
        {
        }
		else
		{
            [self dismissTips];
		}
		
        if ( msg.succeed )
        {
            [self presentMessageTips:@"已收藏"];
            [[UserModel sharedInstance] updateFields];
            [[UserModel sharedInstance] updateProfile];
        }
        else if ( msg.failed )
        {
            [self presentMessageTips:@"您已收藏过了"];
        }
    }
}

#pragma mark - <UIPickerViewDataSource>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[CommonUtility getCanSelectHourMin] count];
}

#pragma mark - <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDate* date = [CommonUtility getCanSelectHourMin][row];
    return [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDate* date = [CommonUtility getCanSelectHourMin][row];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_time"];
    
    [self resetCells];
    [self fetchData];
    [_pickerBg setHidden:YES];
    
}


@end
