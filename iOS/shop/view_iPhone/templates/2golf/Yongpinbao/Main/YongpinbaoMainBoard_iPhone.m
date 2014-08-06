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
//  YongpinbaoMainBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-23.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "YongpinbaoMainBoard_iPhone.h"
#import "YongpinbaoMainInfoCellBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "Placeholder.h"
#import "ServerConfig.h"
#import "PhotoSlideViewBoard_iPhone.h"
#import "CommonUtility.h"
#import "SearchCategoryModel.h"
#import "CartBoard_iPhone.h"
#import "SearchBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"

#pragma mark -

@interface YongpinbaoMainBannerPhotoCell_iPhone()
{
	BeeUIImageView * _image;
}
@end

#pragma mark -

@implementation YongpinbaoMainBannerPhotoCell_iPhone

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
    _image.url = url;
}

- (void)dataDidChanged
{
    /*
    [self setImageUrl:
     [NSString stringWithFormat:@"%@%@",
      [ServerConfig sharedInstance].baseUrl,
      self.data[@"url"]]];
     */
    [self setImageUrl:@"http://www.2golf.cn/data/afficheimg/20140804ymbvwa.jpg"];
}

@end

#pragma mark -

@implementation YongpinbaoMainBannerCell_iPhone

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
    self.shadow.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self addSubview:self.shadow];
    
    self.leftLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(22, 0, 200, 20)] autorelease];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.font = [UIFont systemFontOfSize:14];
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.text = @"";
    [self.shadow addSubview:self.leftLabel];
    
    self.rightLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(256, 0, 100, 20)] autorelease];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    self.rightLabel.text = @"详情";
    self.rightLabel.hidden = YES;
    [self.shadow addSubview:self.rightLabel];
    
    self.arrowImg = [[[UIImageView alloc] initWithImage:__IMAGE(@"expand_left_white")] autorelease];
    self.arrowImg.frame = CGRectMake(287, 2, self.arrowImg.frame.size.width, self.arrowImg.frame.size.height);
    self.arrowImg.hidden = YES;
    [self.shadow addSubview:self.arrowImg];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.frame = CGRectMake(0, 0, 320, 20);
    self.detailBtn.hidden = YES;
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
    
    CGRect shadowFrame = CGRectMake(0, self.scroll.height - 20, 320, 20);
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
        //self.leftLabel.text = self.data[@"slogan"];
    }
    
    [self.scroll reloadData];
}

#pragma mark -

ON_SIGNAL2( BeeUIScrollView , signal)
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.DID_STOP] )
	{
		//NSInteger pageCount = ((NSArray *)self.data).count;
        NSInteger pageCount = 1;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
	else if ( [signal is:BeeUIScrollView.RELOADED] )
	{
		//NSInteger pageCount = ((NSArray *)self.data).count;
        NSInteger pageCount = 1;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
}

#pragma mark -

- (void)_pressedDetail:(UIButton*)btn
{
    //QiuchangDetailDescriptionBoard_iPhone* board = [QiuchangDetailDescriptionBoard_iPhone boardWithNibName:@"QiuchangDetailDescriptionBoard_iPhone"];
    
    /*
     QiuchangVipVerifyBoard_iPhone* newBoard = [QiuchangVipVerifyBoard_iPhone boardWithNibName:@"QiuchangVipVerifyBoard_iPhone"];
     [[self recursiveFindUIBoard].stack pushBoard:newBoard animated:YES];
     */
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    if (((NSArray *)(self.data)).count > 0)
    {
        return 1;//return ((NSArray *)(self.data)).count;
    }
    return 0;//return ((NSArray *)(self.data)).count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    YongpinbaoMainBannerPhotoCell_iPhone * cell = [scrollView dequeueWithContentClass:[YongpinbaoMainBannerPhotoCell_iPhone class]];
    cell.data = (self.data[index])[@"photo"];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return scrollView.bounds.size;
}

@end


#pragma mark -

@interface YongpinbaoMainBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
    BOOL _hasLoaded;
}

@property (nonatomic,retain) NSMutableArray* dataArray;
@property (nonatomic,retain) NSMutableArray* cellArray;

@end

@implementation YongpinbaoMainBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);
DEF_SIGNAL(DAIL_LEFT_NAV_BTN);

- (void)load
{
	[super load];
    [[SearchCategoryModel sharedInstance] addObserver:self];
}

- (void)unload
{
    [[SearchCategoryModel sharedInstance] removeObserver:self];
    self.cellArray = nil;
    self.dataArray = nil;
	[super unload];
}

#pragma mark Signal

static BeeUIButton* gRightBtn = nil;
static BeeUIButton* gLeftBtn = nil;
static UIImageView* gBarBGView = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"爱高"];
        
        CGRect rect;
        
        //左上角搜索按钮
        UIView* leftBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        leftBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* leftBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitleColor:[UIColor whiteColor]];
        [leftBtn setTitle:@"搜索" forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor clearColor];
        gLeftBtn = leftBtn;
        [leftBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(0, 0, 56, 38);
        [leftBtnContainerView addSubview:leftBtn];
        [self showBarButton:BeeUINavigationBar.LEFT custom:leftBtnContainerView];
        //leftBtnContainerView.left = -10;
        
        //右上角购物车按钮
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = __IMAGE(@"goodsmyorderbtn");
        [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor]];
        [rightBtn setTitle:@"购物车" forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_LEFT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-8, 0, 56, 38);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        //rightBtnContainerView.left = -15;
        
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
        _scroll.clipsToBounds = NO;
        
        //NavigationBar背景太短
        UIImageView* barBGView = [[[UIImageView alloc] initWithImage:__IMAGE(@"titlebarbg")] autorelease];
        rect = barBGView.frame;
        if (IOS7_OR_LATER)
        {
            rect.origin.y = 0;
        }
        else
        {
            rect.origin.y = -20;
        }
        barBGView.frame = rect;
        gBarBGView=barBGView;
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:barBGView atIndex:2];
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
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
        
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
        
        [[SearchCategoryModel sharedInstance] fetchFromServer];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
        
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

ON_SIGNAL( signal )
{
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        SearchBoard_iPhone * board = [SearchBoard_iPhone board];
        //board.filter = self.model1.filter;
		[self.stack pushBoard:board animated:YES];
    }
    if ( [signal is:self.DAIL_LEFT_NAV_BTN] )
    {
        if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        CartBoard_iPhone * board = [CartBoard_iPhone board];
        //board.filter = self.model1.filter;
		[self.stack pushBoard:board animated:YES];
    }
    
}

ON_SIGNAL2( QiuchangBannerPhotoCell_iPhone, signal )
{
    //这里先预留
    PhotoSlideViewBoard_iPhone * board = [PhotoSlideViewBoard_iPhone board];
    //board.pictures = self.dataDict[@""];
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
    return self.cellArray[index];
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    BeeUICell * cell = self.cellArray[index];
	return cell.frame.size;
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
	if ( [msg is:API.category] )
	{
		if ( msg.sending )
		{
			if ( NO == [SearchCategoryModel sharedInstance].loaded )
			{
                //				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
		}
		else
		{
			[self dismissTips];
            [self dismissModalViewAnimated:YES];
		}
        
		if ( msg.succeed )
		{
            if (!_hasLoaded)
            {
                [self fetchData];
            }
		}
	}
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (void)resetCells
{
    if (self.cellArray == nil)
    {
        self.cellArray = [NSMutableArray array];
    }
    [self.cellArray removeAllObjects];
    
    //banner
    BeeUICell * cell = [[[YongpinbaoMainBannerCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 115)] autorelease];
    cell.data = self.dataArray;
    [self.cellArray addObject:cell];
    
    //下面的所有按钮
    cell = [[YongpinbaoMainInfoCell_iPhone alloc] initWithFrame:CGRectZero];
    cell.data = self.dataArray;
    [self.cellArray addObject:cell];
    
    for (int i = 0; i < ((YongpinbaoMainInfoCell_iPhone*)cell).categoryBtns.count; ++i)
    {
        UIButton* btn = ((YongpinbaoMainInfoCell_iPhone*)cell).categoryBtns[i];
        btn.tag = i;
        [btn addTarget:self action:@selector(onPressedCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i = 0; i < ((YongpinbaoMainInfoCell_iPhone*)cell).brandBtns.count; ++i)
    {
        UIButton* btn = ((YongpinbaoMainInfoCell_iPhone*)cell).brandBtns[i];
        btn.tag = i;
        [btn addTarget:self action:@selector(onPressedBrandBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Network


- (void)fetchData
{
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"brand"]).TIMEOUT(30);
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
        //球场详情
        if ([[req.url absoluteString] rangeOfString:@"brand"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                _hasLoaded = YES;
                self.dataArray = [NSMutableArray arrayWithArray:dict[@"data"][@"player"]];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

#pragma mark - private methods

- (void)onPressedCategoryBtn:(UIButton*)btn
{
    int index = btn.tag;
    
    NSString* categoryName = nil;
    NSNumber* categoryID = nil;
    
    NSObject * obj = [SearchCategoryModel sharedInstance].topCategories[index];
    
    if ( [obj isKindOfClass:[TOP_CATEGORY class]] )
    {
        TOP_CATEGORY * category = (TOP_CATEGORY *)obj;
        if ( category )
        {
            categoryName = category.name;
            categoryID = category.id;
        }
    }
    else if ( [obj isKindOfClass:[CATEGORY class]] )
    {
        CATEGORY * category = (CATEGORY *)obj;
        if ( category )
        {
            categoryName = category.name;
            categoryID = category.id;
        }
    }
    
    GoodsListBoard_iPhone * board = nil;
    if (![self.stack existsBoardClass:[GoodsListBoard_iPhone class]])
    {
        board = [[[GoodsListBoard_iPhone alloc] init] autorelease];
    }
    else
    {
        board = (GoodsListBoard_iPhone*)[self.stack lastBoardWithClass:[GoodsListBoard_iPhone class]];
    }
    
    board.category = categoryName;
    board.model1.filter.category_id = categoryID;
    board.model2.filter.category_id = categoryID;
    board.model3.filter.category_id = categoryID;
    
    board.model1.filter.category_name = categoryName;
    board.model2.filter.category_name = categoryName;
    board.model3.filter.category_name = categoryName;
    
    
    
    if (![self.stack existsBoardClass:[GoodsListBoard_iPhone class]])
    {
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        [self.stack popToBoard:board animated:YES];
    }
}

- (void)onPressedBrandBtn:(UIButton*)btn
{
    int index = btn.tag;
    
    NSString* brandName = self.dataArray[index][@"brand_name"];
    NSNumber* brandNameID = self.dataArray[index][@"id"];
    
    GoodsListBoard_iPhone * board = nil;
    if (![self.stack existsBoardClass:[GoodsListBoard_iPhone class]])
    {
        board = [[[GoodsListBoard_iPhone alloc] init] autorelease];
    }
    else
    {
        board = (GoodsListBoard_iPhone*)[self.stack lastBoardWithClass:[GoodsListBoard_iPhone class]];
    }
    
    board.category = @"";
    board.model1.filter.brand_id = brandNameID;
    board.model2.filter.brand_id = brandNameID;
    board.model3.filter.brand_id = brandNameID;
    
    board.model1.filter.brand_name = brandName;
    board.model2.filter.brand_name = brandName;
    board.model3.filter.brand_name = brandName;
    
    if (![self.stack existsBoardClass:[GoodsListBoard_iPhone class]])
    {
        [self.stack pushBoard:board animated:YES];
    }
    else
    {
        [self.stack popToBoard:board animated:YES];
    }
}

@end
