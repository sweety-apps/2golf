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
	
#import "GoodsListBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "CommonWaterMark.h"
#import "Placeholder.h"
#import "AdvancedSearchBoard_iPhone.h"
#import "GoodsTagHeaderCell.h"
#import "NibLoader.h"
#import "SearchBoard_iPhone.h"

@implementation GoodsListCart_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
	NSNumber * count = self.data;
	if ( count && count.intValue )
	{
		$(@"#badge-bg").SHOW();
		$(@"#badge").SHOW();
		$(@"#badge").DATA( count );
	}
	else
	{
		$(@"#badge-bg").HIDE();
		$(@"#badge").HIDE();
	}
}

@end

@implementation GoodsListFilter_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
    
    BeeUIImageView * bg = (BeeUIImageView *)$(@".filter-bg").view;
    bg.backgroundColor = [UIColor clearColor];
}

//hot
- (void)selectTab1
{
	$(@"#item-popular").CSS( @"color: #ffffff" );
	$(@"#item-cheap").CSS( @"color: #ffffff" );
	$(@"#item-expensive").CSS( @"color: #ffffff" );
    
    $(@"item-popular-arrow").CSS( @"image-src: url(item-grid-filter-down-active-arrow.png)" );
//    $(@"item-cheap-arrow").CSS( @"image-src: url(item-grid-filter-down-active-arrow.png)" );
//    $(@"item-expensive-arrow").CSS( @"image-src: url(item-grid-filter-down-arrow.png)" );
    
    $(@"item-popular-indicator").SHOW();
    $(@"item-cheap-indicator").HIDE();
    $(@"item-expensive-indicator").HIDE();
    
    $(@"item-popular-indicator").SHOW();
    
    $(@"#item-cheap").view.backgroundColor = [UIColor colorWithRed:0.676 green:0.769 blue:0.835 alpha:1.000];
    $(@"#item-popular").view.backgroundColor = [UIColor colorWithRed:0.125 green:0.619 blue:0.171 alpha:1.000];
    
    $(@"#item-cheap").view.layer.masksToBounds = YES;
    $(@"#item-cheap").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-cheap").view.layer.borderWidth = 1;
    
    $(@"#item-popular").view.layer.masksToBounds = YES;
    $(@"#item-popular").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-popular").view.layer.borderWidth = 1;
}

//cheap
- (void)selectTab2
{
	$(@"#item-popular").CSS( @"color: #ffffff" );
	$(@"#item-cheap").CSS( @"color: #ffffff" );
	$(@"#item-expensive").CSS( @"color: #ffffff" );
    
//    $(@"item-popular-arrow").CSS( @"image-src: url(item-grid-filter-up-active-arrow.png)" );
    $(@"item-cheap-arrow").CSS( @"image-src: url(item-grid-filter-up-active-arrow.png)" );
//    $(@"item-expensive-arrow").CSS( @"image-src: url(item-grid-filter-up-arrow.png)" );
    
    $(@"item-popular-indicator").HIDE();
    $(@"item-cheap-indicator").SHOW();
    $(@"item-expensive-indicator").HIDE();
    
    $(@"#item-cheap").view.backgroundColor = [UIColor colorWithRed:0.125 green:0.619 blue:0.171 alpha:1.000];
    $(@"#item-popular").view.backgroundColor = [UIColor colorWithRed:0.676 green:0.769 blue:0.835 alpha:1.000];
    
    $(@"#item-cheap").view.layer.masksToBounds = YES;
    $(@"#item-cheap").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-cheap").view.layer.borderWidth = 1;
    
    $(@"#item-popular").view.layer.masksToBounds = YES;
    $(@"#item-popular").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-popular").view.layer.borderWidth = 1;
}

//expensive
- (void)selectTab3
{
	$(@"#item-popular").CSS( @"color: #ffffff" );
	$(@"#item-cheap").CSS( @"color: #ffffff" );
	$(@"#item-expensive").CSS( @"color: #ffffff" );
    
//    $(@"item-popular-arrow").CSS( @"image-src: url(item-grid-filter-down-active-arrow.png)" );
    $(@"item-cheap-arrow").CSS( @"image-src: url(item-grid-filter-down-active-arrow.png)" );
//    $(@"item-expensive-arrow").CSS( @"image-src: url(item-grid-filter-down-arrow.png)" );
    
    $(@"item-popular-indicator").HIDE();
    $(@"item-cheap-indicator").SHOW();
    $(@"item-expensive-indicator").HIDE();
    
    $(@"#item-cheap").view.backgroundColor = [UIColor colorWithRed:0.125 green:0.619 blue:0.171 alpha:1.000];
    $(@"#item-popular").view.backgroundColor = [UIColor colorWithRed:0.676 green:0.769 blue:0.835 alpha:1.000];
    
    $(@"#item-cheap").view.layer.masksToBounds = YES;
    $(@"#item-cheap").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-cheap").view.layer.borderWidth = 1;
    
    $(@"#item-popular").view.layer.masksToBounds = YES;
    $(@"#item-popular").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-popular").view.layer.borderWidth = 1;
}

//cool
- (void)selectTab4
{
	$(@"#item-popular").CSS( @"color: #ffffff" );
	$(@"#item-cheap").CSS( @"color: #ffffff" );
	$(@"#item-expensive").CSS( @"color: #ffffff" );
    
    $(@"item-popular-arrow").CSS( @"image-src: url(item-grid-filter-up-active-arrow.png)" );
//    $(@"item-cheap-arrow").CSS( @"image-src: url(item-grid-filter-up-active-arrow.png)" );
//    $(@"item-expensive-arrow").CSS( @"image-src: url(item-grid-filter-up-arrow.png)" );
    
    $(@"item-popular-indicator").SHOW();
    $(@"item-cheap-indicator").HIDE();
    $(@"item-expensive-indicator").HIDE();
    
    $(@"item-popular-indicator").SHOW();
    
    $(@"#item-cheap").view.backgroundColor = [UIColor colorWithRed:0.676 green:0.769 blue:0.835 alpha:1.000];
    $(@"#item-popular").view.backgroundColor = [UIColor colorWithRed:0.125 green:0.619 blue:0.171 alpha:1.000];
    
    $(@"#item-cheap").view.layer.masksToBounds = YES;
    $(@"#item-cheap").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-cheap").view.layer.borderWidth = 1;
    
    $(@"#item-popular").view.layer.masksToBounds = YES;
    $(@"#item-popular").view.layer.borderColor = [UIColor whiteColor].CGColor;
    $(@"#item-popular").view.layer.borderWidth = 1;
}

@end

@implementation GoodsListGridCell_iPhone

SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TAPPED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
    self.tapSignal = self.TAPPED;
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
	    $(@".goods-photo").IMAGE( goods.img.thumbURL );
		$(@".goods-title").TEXT( goods.name );
		$(@".goods-price").TEXT( goods.promote_price.length > 0 ? goods.promote_price : goods.shop_price );
		$(@".goods-subprice").TEXT( goods.market_price );
//		$(@".goods-sales").TEXT( @"月销量" );
//		$(@".goods-sales-volume").TEXT( @"1,999" );
	}
}

ON_SIGNAL2( BeeUIImageView, signal )
{
    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        [super handleUISignal:signal];

        $(@".goods-photo").IMAGE( [Placeholder image] );
    }
}

@end

@implementation GoodsListLargeCell_Phone

SUPPORT_RESOURCE_LOADING( YES )

DEF_SIGNAL( TAPPED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
    self.tapSignal = self.TAPPED;
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
	    $(@".goods-photo-large").IMAGE( goods.img.largeURL );
		$(@".goods-title-large").TEXT( goods.name );
		
		if ( goods.promote_price && goods.promote_price.length > 0 )
		{
			$(@".goods-price-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"formerprice"), goods.promote_price] );
		}
		else
		{
			$(@".goods-price-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"store_price"), goods.shop_price] );
		}

		$(@".goods-subprice-large").TEXT( [NSString stringWithFormat:@"%@: %@", __TEXT(@"market_price"), goods.market_price] );
//		$(@".goods-sales-large").TEXT( @"月销量" );
//		$(@".goods-sales-volume-large").TEXT( @"1,999" );
	}
}

ON_SIGNAL2( BeeUIImageView, signal )
{
    if ( [signal is:BeeUIImageView.LOAD_FAILED] )
    {
        [super handleUISignal:signal];
        // find the images and set the placeholder
        $(@".goods-photo-large").IMAGE( [Placeholder image] );
    }
}

@end

#pragma mark -

@interface GoodsListBoard_iPhone()
{
    NSInteger                   _currentMode;
	BeeUIScrollView *           _scroll;
    GoodsListCart_iPhone *       _floatingCart;
    GoodsListFilter_iPhone *    _filter;

}

@property (nonatomic,retain) GoodsTagHeaderCell* tagHeaderCell;

AS_INT( MODE_GRID )
AS_INT( MODE_LARGE )

@end

#pragma mark -

@implementation GoodsListSearchBar_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

@end

#pragma mark -

@interface GoodsListBoard_iPhone()
{
}
@end

@implementation GoodsListBoard_iPhone

DEF_INT( TAB_COOL,		-1 )
DEF_INT( TAB_HOT,		0 )
DEF_INT( TAB_CHEAPEST,	1 )
DEF_INT( TAB_EXPENSIVE,	2 )

DEF_INT( MODE_GRID, 0 )
DEF_INT( MODE_LARGE, 1 )

@synthesize last1tabIndex = _last1tabIndex;
@synthesize last2tabIndex = _last2tabIndex;
@synthesize currentMode = _currentMode;
@synthesize category = _category;

@synthesize model1 = _model1;
@synthesize model2 = _model2;
@synthesize model3 = _model3;
@synthesize model4 = _model4;

- (void)load
{
	[super load];
	
	self.tabIndex = self.TAB_CHEAPEST;
	
	self.model1 = [[[SearchByHotModel alloc] init] autorelease];
	[self.model1 addObserver:self];

	self.model2 = [[[SearchByCheapestModel alloc] init] autorelease];
	[self.model2 addObserver:self];

	self.model3 = [[[SearchByExpensiveModel alloc] init] autorelease];
	[self.model3 addObserver:self];
    
    self.model4 = [[[SearchByCoolModel alloc] init] autorelease];
	[self.model4 addObserver:self];
}

- (void)unload
{
	[self.model1 removeObserver:self];
	self.model1 = nil;
	
	[self.model2 removeObserver:self];
	self.model2 = nil;
	
	[self.model3 removeObserver:self];
	self.model3 = nil;
	
	[self.model4 removeObserver:self];
	self.model4 = nil;
    
	self.category = nil;

	[super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
    
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"商品列表"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        //[self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"filter") image:[UIImage imageNamed:@"nav-right.png"]];
		
        //顶部Tag
        self.tagHeaderCell = CREATE_NIBVIEW(@"GoodsTagHeaderCell");
        self.tagHeaderCell.clipsToBounds = YES;
        [self.tagHeaderCell.brandButton addTarget:self action:@selector(_pressedBrandBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagHeaderCell.categoryButton addTarget:self action:@selector(_pressedCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.tagHeaderCell.keywordButton addTarget:self action:@selector(_pressedKeywordBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.tagHeaderCell];
        
        self.currentMode = self.MODE_GRID; // TODO, persist
        
        _filter = [[GoodsListFilter_iPhone alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_filter];

		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.backgroundColor = [UIColor clearColor];
		_scroll.dataSource = self;
		[_scroll showHeaderLoader:YES animated:NO];
		[_scroll showFooterLoader:YES animated:NO];
		[self.view addSubview:_scroll];

        _floatingCart = [[GoodsListCart_iPhone alloc] init];
        [self.view addSubview:_floatingCart];

		[self observeNotification:CartModel.UPDATED];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
		
        self.tagHeaderCell = nil;
		SAFE_RELEASE_SUBVIEW( _scroll );
		SAFE_RELEASE_SUBVIEW( _filter );
		SAFE_RELEASE_SUBVIEW( _floatingCart );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        CGFloat filterheight = 44.0f + 52;

        _filter.frame = CGRectMake( 0, 52, self.view.width, filterheight );
		_scroll.frame = CGRectMake( 0, filterheight, self.view.width, self.view.height - filterheight );
        _floatingCart.frame = CGRectMake( self.view.width - 44 - 10, self.view.height - 44 - 10, 44, 44 );
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
		[self.model1 loadCache];
		[self.model2 loadCache];
		[self.model3 loadCache];
		[self.model4 loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        self.view.backgroundColor = [UIColor whiteColor];
//		if ( self.model1.filter.keywords.length )
//		{
//			self.titleString = [NSString stringWithFormat:@"%@", self.model1.filter.keywords];
//		}
//		else
//		{
//			self.titleString = self.category ? self.category : __TEXT(@"product_category");
//		}

		[self updateViews];

		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		[[CartModel sharedInstance] fetchFromServer];
    }
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		[self updateDatas];

        [_scroll reloadData];
	}
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
	{
//        if ( [AdvancedSearchModel sharedInstance].changed )
        {
            [_scroll reloadData];
            [self updateDatas];
            
//            [AdvancedSearchModel sharedInstance].changed = NO;
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
//        self.currentMode = (self.currentMode == self.MODE_GRID) ? self.MODE_LARGE : self.MODE_GRID;
//        [self updateViews];
        AdvancedSearchBoard_iPhone * board = [AdvancedSearchBoard_iPhone board];
        board.filter = self.model1.filter;
		[self.stack pushBoard:board animated:YES];
//        [self presentModalStack:[BeeUIStack stackWithFirstBoard:board] animated:YES];
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[[self currentModel] prevPageFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] || [signal is:BeeUIScrollView.FOOTER_REFRESH] )
	{
		[[self currentModel] nextPageFromServer];
	}
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
	
	BeeUITextField * textField = (BeeUITextField *)signal.source;
	
	if ( [signal is:BeeUITextField.RETURN] )
	{
		[textField endEditing:YES];
        
        [self doSearch:textField.text];
	}
}

ON_SIGNAL2( GoodsListGridCell_iPhone, signal )
{
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
		GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.goods_id;
		[self.stack pushBoard:board animated:YES];
	}
}

ON_SIGNAL2( GoodsListLargeCell_Phone, signal )
{
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
		GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.goods_id;
		[self.stack pushBoard:board animated:YES];
	}
}

ON_SIGNAL3( GoodsListFilter_iPhone, item_popular_button, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
        if (self.tabIndex == self.TAB_HOT) {
            self.tabIndex = self.TAB_COOL;
        }
        else if(self.tabIndex == self.TAB_COOL)
        {
            self.tabIndex = self.TAB_HOT;
        }
		else
        {
            self.tabIndex = self.last2tabIndex;
        }
        
        self.last2tabIndex = self.tabIndex;
		[self updateViews];
		[self updateDatas];
	}
}

ON_SIGNAL3( GoodsListFilter_iPhone, item_cheap_button, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
        if (self.tabIndex == self.TAB_CHEAPEST) {
            self.tabIndex = self.TAB_EXPENSIVE;
        }
        else if (self.tabIndex == self.TAB_EXPENSIVE)
        {
            self.tabIndex = self.TAB_CHEAPEST;
        }
		else
        {
            self.tabIndex = self.last1tabIndex;
        }
        self.last1tabIndex = self.tabIndex;
		[self updateViews];
		[self updateDatas];
	}
}

ON_SIGNAL3( GoodsListFilter_iPhone, item_expensive_button, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		self.tabIndex = self.TAB_EXPENSIVE;
		
		[self updateViews];
		[self updateDatas];
	}
}

ON_SIGNAL3( GoodsListCart_iPhone, cart, signal )
{
    if ( NO == [UserModel online] )
    {
        [[AppBoard_iPhone sharedInstance] showLogin];
        return;
    }
	CartBoard_iPhone * board = [CartBoard_iPhone board];
	[self.stack pushBoard:board animated:YES];
}

- (void)doSearch:(NSString *)keyword
{
    if ( 0 == keyword.length )
    {
        //		[self presentFailureTips:@"请输入正确的关键字"];
        return;
    }
    
    self.model1.filter.keywords = keyword;
    self.model2.filter.keywords = keyword;
    self.model3.filter.keywords = keyword;
    self.model4.filter.keywords = keyword;

    [self updateDatas];
}

- (void)updateViews
{
//    if ( self.MODE_GRID == self.currentMode )
//    {
//        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item-graph-header-view-icon.png"]];
//    }
//    else if ( self.MODE_LARGE == self.currentMode )
//    {
//        [self showBarButton:BeeUINavigationBar.RIGHT image:[UIImage imageNamed:@"item-grid-header-view-icon.png"]];
//    }
    
	NSUInteger count = 0;
	
	for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
	{
		count += goods.goods_number.intValue;
	}
	
	_floatingCart.data = __INT( count );

	if ( self.TAB_HOT == self.tabIndex )
	{
		[_filter selectTab1];
	}
	else if ( self.TAB_CHEAPEST == self.tabIndex )
	{
		[_filter selectTab2];
	}
	else if ( self.TAB_EXPENSIVE == self.tabIndex )
	{
		[_filter selectTab3];
	}
    else if ( self.TAB_COOL == self.tabIndex )
	{
		[_filter selectTab4];
	}
    
    NSString* brandName = [self currentModel].filter.brand_name;
    NSString* categoryName = [self currentModel].filter.category_name;
    NSString* keywords = [self currentModel].filter.keywords;
    
    if (brandName == nil || [brandName isKindOfClass:[NSNull class]] || [brandName length]<=0)
    {
        brandName = @"全部";
    }
    
    if (categoryName == nil || [categoryName isKindOfClass:[NSNull class]] || [categoryName length]<=0)
    {
        categoryName = @"全部";
    }
    
    if (keywords == nil || [keywords isKindOfClass:[NSNull class]] || [keywords length]<=0)
    {
        keywords = @"";
    }
    
    [_tagHeaderCell.brandButton setTitle:brandName forState:UIControlStateNormal];
    [_tagHeaderCell.categoryButton setTitle:categoryName forState:UIControlStateNormal];
    [_tagHeaderCell.keywordButton setTitle:keywords forState:UIControlStateNormal];
	
    [_scroll asyncReloadData];
}

- (void)updateDatas
{
	SearchModel * model = [self currentModel];
	if ( model )
	{
//		if ( NO == model.loaded )
		{
			[model prevPageFromServer];
		}
	}
}

- (SearchModel *)currentModel
{
	if ( self.TAB_HOT == self.tabIndex )
	{
		return self.model1;
	}
	else if ( self.TAB_CHEAPEST == self.tabIndex )
	{
		return self.model2;
	}
	else if ( self.TAB_EXPENSIVE == self.tabIndex )
	{
		return self.model3;
	}
    else if ( self.TAB_COOL == self.tabIndex )
	{
		return self.model4;
	}
	return self.model1;
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
	
	if ( [msg is:API.search] )
	{
		if ( msg.sending )
		{
			if ( NO == [self currentModel].loaded )
			{
				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setFooterLoading:YES];
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setFooterLoading:NO];
			[_scroll setHeaderLoading:NO];

			[self dismissTips];
		}

		if ( msg.succeed )
		{
			[_scroll setFooterMore:[self currentModel].more];
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
//			[self presentFailureTips:@"网络异常，请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
	
	if ( [notification is:CartModel.UPDATED] )
	{
		NSUInteger count = 0;
		
		for ( CART_GOODS * goods in [CartModel sharedInstance].goods )
		{
			count += goods.goods_number.intValue;
		}
		
		_floatingCart.data = __INT( count );
	}
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	if ( [self currentModel].loaded && 0 == [self currentModel].goods.count )
	{
		return 1;
	}
	
    if ( self.currentMode == self.MODE_GRID )
    {
        return 2;
    }
    
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( [self currentModel].loaded && 0 == [self currentModel].goods.count )
	{
		return 1;
	}
	
	return [self currentModel].goods.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( [self currentModel].loaded && 0 == [self currentModel].goods.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}

    if ( self.currentMode == self.MODE_GRID )
    {
        BeeUICell * cell = [scrollView dequeueWithContentClass:[GoodsListGridCell_iPhone class]];
        cell.data = [[self currentModel].goods objectAtIndex:index];
        return cell;
    }
    else if ( self.currentMode == self.MODE_LARGE )
    {
        BeeUICell * cell = [scrollView dequeueWithContentClass:[GoodsListLargeCell_Phone class]];
        cell.data = [[self currentModel].goods objectAtIndex:index];
        return cell;
    }
    else
    {
        return nil;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( [self currentModel].loaded && 0 == [self currentModel].goods.count )
	{
		return self.size;
	}

    id data = [[self currentModel].goods objectAtIndex:index];
    
    if ( self.currentMode == self.MODE_GRID )
    {
        return [GoodsListGridCell_iPhone estimateUISizeByWidth:(scrollView.width / 2)
													   forData:data];
    }
    else if ( self.currentMode == self.MODE_LARGE )
    {
        return [GoodsListLargeCell_Phone estimateUISizeByWidth:scrollView.width
														forData:data];
    }
    else
    {
        return CGSizeZero;
    }
}

#pragma mark - tag

- (void)_pressedBrandBtn:(UIButton*)btn
{
    AdvancedSearchBoard_iPhone * board = [AdvancedSearchBoard_iPhone board];
    board.filter = self.model1.filter;
    [self.stack pushBoard:board animated:YES];
}

- (void)_pressedCategoryBtn:(UIButton*)btn
{
    SearchBoard_iPhone * board = [SearchBoard_iPhone board];
    //board.filter = self.model1.filter;
    [self.stack pushBoard:board animated:YES];
}

- (void)_pressedKeywordBtn:(UIButton*)btn
{
    SearchBoard_iPhone * board = [SearchBoard_iPhone board];
    //board.filter = self.model1.filter;
    [self.stack pushBoard:board animated:YES];
}

@end
