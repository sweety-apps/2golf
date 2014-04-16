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
	
#import "IndexBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "GoodsListBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"
#import "HelpBoard_iPhone.h"
#import "NotificationBoard_iPhone.h"
#import "Placeholder.h"

#import "CommonFootLoader.h"
#import "CommonPullLoader.h"

#import "SouSuoQiuChangBoard_iPhone.h"

#pragma mark -

@interface BannerPhotoCell_iPhone()
{
	BeeUIImageView * _image;
}
@end

#pragma mark -

@implementation BannerPhotoCell_iPhone

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

- (void)dataDidChanged
{
	BANNER * banner = self.data;
	if ( banner )
	{
		_image.url = banner.photo.largeURL;
	}
}

@end

#pragma mark -

@implementation BannerCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@synthesize shadow = _shadow;
@synthesize scroll = _scroll;
@synthesize pageControl = _pageControl;

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
}

- (void)unload
{
    self.shadow = nil;
	self.scroll = nil;
	self.pageControl = nil;
	
	[super unload];
}

- (void)layoutDidFinish
{
    self.scroll.frame = self.bounds;
	[_scroll reloadData];
    
    CGRect shadowFrame = CGRectMake(0, self.scroll.height - 16, 320, 16);
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
    [self.scroll reloadData];
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

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return ((NSArray *)self.data).count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	BANNER * banner = [(NSArray *)self.data safeObjectAtIndex:index];
	if ( banner )
	{
		BannerPhotoCell_iPhone * cell = [scrollView dequeueWithContentClass:[BannerPhotoCell_iPhone class]];
		cell.data = banner;
		return cell;
	}
	
	return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return scrollView.bounds.size;
}

@end

#pragma mark -

@implementation IndexNotifiCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@end

#pragma mark -

@implementation CategoryCell_iPhone

DEF_SIGNAL( CATEGORY_TOUCHED )
DEF_SIGNAL( GOODS1_TOUCHED )
DEF_SIGNAL( GOODS2_TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
}

- (void)dataDidChanged
{
	CATEGORY * category = self.data;
	if ( category )
	{
		$(@"#category-title").TEXT( category.name );
		
		if ( category.goods.count > 0 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:0];
			
			$(@"#category-image").SHOW();
			$(@"#category-image").IMAGE( goods.img.thumbURL );
		}
		else
		{
            $(@"#category-image").HIDE();
//			$(@"#category-image").IMAGE( [Placeholder image] );
		}
		
		if ( category.goods.count > 1 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:1];
			
			$(@"#goods-title1").SHOW();
			$(@"#goods-title1").TEXT( goods.name );

			$(@"#goods-price1").SHOW();
			$(@"#goods-price1").TEXT( goods.shop_price );
			
			$(@"#goods-image1").SHOW();
			$(@"#goods-image1").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title1").HIDE();
			$(@"#goods-price1").HIDE();
            $(@"#goods-image1").HIDE();
//			$(@"#goods-image1").IMAGE( [Placeholder image] );
		}

		if ( category.goods.count > 2 )
		{
			SIMPLE_GOODS * goods = [category.goods objectAtIndex:2];

			$(@"#goods-title2").SHOW();
			$(@"#goods-title2").TEXT( goods.name );
			
			$(@"#goods-price2").SHOW();
			$(@"#goods-price2").TEXT( goods.shop_price );
			
			$(@"#goods-image2").SHOW();
			$(@"#goods-image2").IMAGE( goods.img.thumbURL );
		}
		else
		{
			$(@"#goods-title2").HIDE();
			$(@"#goods-price2").HIDE();
            $(@"#goods-image2").HIDE();
//			$(@"#goods-image2").IMAGE( [Placeholder image] );
		}
	}
}

ON_SIGNAL3( CategoryCell_iPhone, category, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.CATEGORY_TOUCHED];
    }
}

ON_SIGNAL3( CategoryCell_iPhone, goods1, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS1_TOUCHED];
    }
}

ON_SIGNAL3( CategoryCell_iPhone, goods2, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        [self sendUISignal:self.GOODS2_TOUCHED];
    }
}

@end

#pragma mark -

@implementation RecommendCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
	NSArray * array = self.data;
	
    if ( array.count >= 1 )
	{
		$(@"#goods-1").SHOW();
		$(@"#goods-1").DATA( [array objectAtIndex:0] );
	}
	else
	{
		$(@"#goods-1").HIDE();
	}

    if ( array.count >= 2 )
	{
		$(@"#goods-2").SHOW();
		$(@"#goods-2").DATA( [array objectAtIndex:1] );
	}
	else
	{
		$(@"#goods-2").HIDE();
	}

    if ( array.count >= 3 )
	{
		$(@"#goods-3").SHOW();
		$(@"#goods-3").DATA( [array objectAtIndex:2] );
	}
	else
	{
		$(@"#goods-3").HIDE();
	}

	if ( array.count >= 4 )
	{
		$(@"#goods-4").SHOW();
		$(@"#goods-4").DATA( [array objectAtIndex:3] );
	}
	else
	{
		$(@"#goods-4").HIDE();
	}
}

@end

#pragma mark -

@implementation RecommendGoodsCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    self.tappable = YES;
    self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
	SIMPLE_GOODS * goods = self.data;
	if ( goods )
	{
		$(@"#goods-subprice").TEXT( goods.market_price );
	    $(@"#recommend-goods-price").TEXT( [goods.promote_price empty] ? goods.shop_price : goods.promote_price );
		$(@"#recommend-goods-image").IMAGE( goods.img.thumbURL );
	}
}

@end

@implementation IndexNotifiBarItem_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    NSNumber * number = self.data;
    
    if ( number && number.integerValue > 0 )
    {
        $(@"#badge-bg").SHOW();
        $(@"#badge-count").SHOW();
        $(@"#badge-count").TEXT( [NSString stringWithFormat:@"%@", self.data] );
    }
    else
    {
        $(@"#badge-bg").HIDE();
        $(@"#badge-count").HIDE();
    }
}

@end

@implementation YudingbaoMainCell_iPhone

DEF_SIGNAL( TOUCHED )
DEF_SIGNAL(BUTTON_TOUCHED_DOWN)
DEF_SIGNAL(BUTTON_TOUCHED_UP)

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    //self.tappable = YES;
    //self.tapSignal = self.TOUCHED;
}

- (void)dataDidChanged
{
    [((BeeUIButton*)$(@"#icon-1").view) addTarget:self action:@selector(touchDown1:) forControlEvents:UIControlEventTouchDown];
    [((BeeUIButton*)$(@"#icon-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpInside];
    [((BeeUIButton*)$(@"#icon-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpOutside];
    [((BeeUIButton*)$(@"#icon-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchCancel];
//    [((BeeUIButton*)$(@"#icon-in-1").view) addTarget:self action:@selector(touchDown1:) forControlEvents:UIControlEventTouchDown];
//    [((BeeUIButton*)$(@"#icon-in-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpInside];
//    [((BeeUIButton*)$(@"#icon-in-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpOutside];
//    [((BeeUIButton*)$(@"#icon-in-1").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchCancel];
    
    [((BeeUIButton*)$(@"#icon-2").view) addTarget:self action:@selector(touchDown2:) forControlEvents:UIControlEventTouchDown];
    [((BeeUIButton*)$(@"#icon-2").view) addTarget:self action:@selector(touchUp2:) forControlEvents:UIControlEventTouchUpInside];
    [((BeeUIButton*)$(@"#icon-2").view) addTarget:self action:@selector(touchUp2:) forControlEvents:UIControlEventTouchUpOutside];
    [((BeeUIButton*)$(@"#icon-2").view) addTarget:self action:@selector(touchUp2:) forControlEvents:UIControlEventTouchCancel];
//    [((BeeUIButton*)$(@"#icon-in-2").view) addTarget:self action:@selector(touchDown1:) forControlEvents:UIControlEventTouchDown];
//    [((BeeUIButton*)$(@"#icon-in-2").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpInside];
//    [((BeeUIButton*)$(@"#icon-in-2").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpOutside];
//    [((BeeUIButton*)$(@"#icon-in-2").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchCancel];
    
    [((BeeUIButton*)$(@"#icon-3").view) addTarget:self action:@selector(touchDown3:) forControlEvents:UIControlEventTouchDown];
    [((BeeUIButton*)$(@"#icon-3").view) addTarget:self action:@selector(touchUp3:) forControlEvents:UIControlEventTouchUpInside];
    [((BeeUIButton*)$(@"#icon-3").view) addTarget:self action:@selector(touchUp3:) forControlEvents:UIControlEventTouchUpOutside];
    [((BeeUIButton*)$(@"#icon-3").view) addTarget:self action:@selector(touchUp3:) forControlEvents:UIControlEventTouchCancel];
//    [((BeeUIButton*)$(@"#icon-in-3").view) addTarget:self action:@selector(touchDown1:) forControlEvents:UIControlEventTouchDown];
//    [((BeeUIButton*)$(@"#icon-in-3").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpInside];
//    [((BeeUIButton*)$(@"#icon-in-3").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpOutside];
//    [((BeeUIButton*)$(@"#icon-in-3").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchCancel];
    
    [((BeeUIButton*)$(@"#icon-4").view) addTarget:self action:@selector(touchDown4:) forControlEvents:UIControlEventTouchDown];
    [((BeeUIButton*)$(@"#icon-4").view) addTarget:self action:@selector(touchUp4:) forControlEvents:UIControlEventTouchUpInside];
    [((BeeUIButton*)$(@"#icon-4").view) addTarget:self action:@selector(touchUp4:) forControlEvents:UIControlEventTouchUpOutside];
    [((BeeUIButton*)$(@"#icon-4").view) addTarget:self action:@selector(touchUp4:) forControlEvents:UIControlEventTouchCancel];
//    [((BeeUIButton*)$(@"#icon-in-4").view) addTarget:self action:@selector(touchDown1:) forControlEvents:UIControlEventTouchDown];
//    [((BeeUIButton*)$(@"#icon-in-4").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpInside];
//    [((BeeUIButton*)$(@"#icon-in-4").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchUpOutside];
//    [((BeeUIButton*)$(@"#icon-in-4").view) addTarget:self action:@selector(touchUp1:) forControlEvents:UIControlEventTouchCancel];
}

- (void)touchDown1:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-1");
    query.DURATION(0.05f).ANIMATE(^(){
        query
        .SCALE(0.94f,0.94f)
        .LEFT(query.view.left+3.f)
        .TOP(query.view.top+3.f)
        ;
    });
}

- (void)touchUp1:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-1");
    query.ANIMATE(^(){
        query
        .SCALE(1.0f,1.0f)
        .LEFT(query.view.left-3.f)
        .TOP(query.view.top-3.f);
    });
}

- (void)touchDown2:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-2");
    query.DURATION(0.05f).ANIMATE(^(){
        query
        .SCALE(0.94f,0.94f)
        .LEFT(query.view.left-3.f)
        .TOP(query.view.top+3.f);
    });
}

- (void)touchUp2:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-2");
    query.ANIMATE(^(){
        query
        .SCALE(1.0f,1.0f)
        .LEFT(query.view.left+3.f)
        .TOP(query.view.top-3.f);
    });
}

- (void)touchDown3:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-3");
    query.DURATION(0.05f).ANIMATE(^(){
        query
        .SCALE(0.94f,0.94f)
        .LEFT(query.view.left+3.f)
        .TOP(query.view.top-3.f);
    });
}

- (void)touchUp3:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-3");
    query.ANIMATE(^(){
        query
        .SCALE(1.0f,1.0f)
        .LEFT(query.view.left-3.f)
        .TOP(query.view.top+3.f);
    });
}

- (void)touchDown4:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-4");
    query.DURATION(0.05f).ANIMATE(^(){
        query
        .SCALE(0.94f,0.94f)
        .LEFT(query.view.left-3.f)
        .TOP(query.view.top-3.f);
    });
}

- (void)touchUp4:(id)sender
{
    BeeUIQuery* query = $(@"#icon-out-4");
    query.ANIMATE(^(){
        query
        .SCALE(1.0f,1.0f)
        .LEFT(query.view.left+3.f)
        .TOP(query.view.top+3.f);
    });
}

ON_SIGNAL2( BeeUIButton, signal )
{
    if ( [signal isSentFrom:$(@"#icon-1").view] )
    {
        //球场搜索
        [self sendUISignal:@"GO_QIUCHANGSOUSUO"];
    }
    if ( [signal isSentFrom:$(@"#icon-2").view] )
    {
        //球场特惠
        [self sendUISignal:@"GO_QIUCHANGTEHUI"];
    }
    if ( [signal isSentFrom:$(@"#icon-3").view] )
    {
        //热销推荐
        [self sendUISignal:@"GO_TEHUITUIJIAN"];
    }
    if ( [signal isSentFrom:$(@"#icon-4").view] )
    {
        //私人订制
        [self sendUISignal:@"GO_SIRENDINGZHI"];
    }
}

@end

#pragma mark -

@interface IndexBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}
@end

#pragma mark -

@implementation IndexBoard_iPhone

DEF_SIGNAL(DAIL_PHONE_OK);
DEF_SIGNAL(DAIL_PHONE_NAV_BTN);

@synthesize model1 = _model1;
@synthesize model2 = _model2;
//@synthesize model3 = _model3;

#pragma mark -

- (void)load
{
	[super load];
	
	self.model1 = [[[BannerModel alloc] init] autorelease];
	[self.model1 addObserver:self];

	self.model2 = [[[CategoryModel alloc] init] autorelease];
	[self.model2 addObserver:self];

//	self.model3 = [[[HelpModel alloc] init] autorelease];
//	[self.model3 addObserver:self];

}

- (void)unload
{
	self.model1 = nil;
	self.model2 = nil;
//	self.model3 = nil;

	[super unload];
}

static UIImageView* gBarBGView = nil;
static BeeUIButton* gPhoneBtn = nil;
static BOOL gIsFirstCreate = NO;

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{		
    [super handleUISignal_BeeUIBoard:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
		[self setTitleString:__TEXT(@"ecmobile")];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:__TEXT(@"ecmobile")];

        UIView* phoneBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        phoneBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* phoneBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.image = __IMAGE(@"telephoneicon");
        gPhoneBtn = phoneBtn;
        [phoneBtn addSignal:self.DAIL_PHONE_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = phoneBtn.frame;
        rect.size.height+=6;
        phoneBtnContainerView.frame = rect;
        rect = phoneBtn.frame;
        rect.origin.y+=6;
        phoneBtn.frame = rect;
        //[phoneBtnContainerView addSubview:phoneBtn];
        
        [self showBarButton:BeeUINavigationBar.RIGHT custom:phoneBtn];
        //[self showBarButton:BeeUINavigationBar.RIGHT custom:[IndexNotifiBarItem_iPhone cell]];
        $(self.rightBarButton).FIND(@"#badge-bg, #badge-count").HIDE();
        
        gIsFirstCreate = YES;
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.bounces = NO;
		//[_scroll showHeaderLoader:YES animated:NO];
		[self.view addSubview:_scroll];
        
        //NavigationBar背景太短
        UIImageView* barBGView = [[[UIImageView alloc] initWithImage:__IMAGE(@"titlebarbg")] autorelease];
        rect = barBGView.frame;
        rect.origin.y = 0;
        barBGView.frame = rect;
        gBarBGView=barBGView;
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:barBGView atIndex:2];
        //[bar setFrame:CGRectMake(0, 20, 320, 50)];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self.model1 loadCache];
		[self.model2 loadCache];
//		[self.model3 loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
		
		if ( [UserModel online] )
		{
			[[CartModel sharedInstance] fetchFromServer];
		}
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {        
        if ( NO == self.model1.loaded )
		{
			[self.model1 fetchFromServer];
		}
        
		if ( NO == self.model2.loaded )
		{
			[self.model2 fetchFromServer];
		}
        
//		if ( NO == self.model3.loaded )
//		{
//			[self.model3 fetchFromServer];
//		}
        
        [_scroll reloadData];
        
        
        
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_WILL_CHANGE] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_DID_CHANGED] )
    {
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
	if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.model1 fetchFromServer];
		[self.model2 fetchFromServer];
        
//		if ( NO == self.model3.loaded )
//		{
//			[self.model3 fetchFromServer];
//		}
		
		[[CartModel sharedInstance] fetchFromServer];
	}
}

ON_SIGNAL2( BannerPhotoCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
    BANNER * banner = signal.sourceCell.data;

    // TODO: for test to be removed
//    banner.action = BANNER_ACTION_GOODS;
//    banner.action_id = @(33);

//    banner.action = BANNER_ACTION_CATEGORY;
//    banner.action_id = @(1);

//    banner.action = BANNER_ACTION_BRAND;
//    banner.action_id = @();
    
	if ( banner )
	{
        if ( [banner.action isEqualToString:BANNER_ACTION_GOODS] )
        {
            GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
            board.goodsModel.goods_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_BRAND] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
            board.model1.filter.brand_id = banner.action_id;
            board.model2.filter.brand_id = banner.action_id;
            board.model3.filter.brand_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [banner.action isEqualToString:BANNER_ACTION_CATEGORY] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
			board.category = banner.description;
            board.model1.filter.category_id = banner.action_id;
            board.model2.filter.category_id = banner.action_id;
            board.model3.filter.category_id = banner.action_id;
            [self.stack pushBoard:board animated:YES];
        }
        else
        {
            WebViewBoard_iPhone * board = [[[WebViewBoard_iPhone alloc] init] autorelease];
            board.defaultTitle = banner.description.length ? banner.description : __TEXT(@"new_activity");
            board.urlString = banner.url;
            [self.stack pushBoard:board animated:YES];
        }
	}
}

ON_SIGNAL2( CategoryCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
	CATEGORY * category = signal.sourceCell.data;
    
    if ( category )
	{
        if ( [signal is:CategoryCell_iPhone.CATEGORY_TOUCHED] )
        {
            GoodsListBoard_iPhone * board = [GoodsListBoard_iPhone board];
			board.category = category.name;
            board.model1.filter.category_id = category.id;
            board.model2.filter.category_id = category.id;
            board.model3.filter.category_id = category.id;
            [self.stack pushBoard:board animated:YES];
        }
        else if ( [signal is:CategoryCell_iPhone.GOODS1_TOUCHED] )
        {
            SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:1];
            
            if ( goods )
            {
                GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
                board.goodsModel.goods_id = goods.id;
                [self.stack pushBoard:board animated:YES];
            }
        }
        else if ( [signal is:CategoryCell_iPhone.GOODS2_TOUCHED] )
        {
            SIMPLE_GOODS * goods = [category.goods safeObjectAtIndex:2];
            
            if ( goods )
            {
                GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
                board.goodsModel.goods_id = goods.id;
                [self.stack pushBoard:board animated:YES];
            }
        }
    }
}

ON_SIGNAL2( RecommendGoodsCell_iPhone, signal )
{	
	[super handleUISignal:signal];
	
    SIMPLE_GOODS * goods = signal.sourceCell.data;
	if ( goods )
	{
	    GoodsDetailBoard_iPhone * board = [GoodsDetailBoard_iPhone board];
		board.goodsModel.goods_id = goods.id;
		[self.stack pushBoard:board animated:YES];	
	}
}

ON_SIGNAL3( IndexNotifiBarItem_iPhone, notify, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE ] )
    {
        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL( signal )
{
    if ( [signal is:self.DAIL_PHONE_NAV_BTN] )
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        //			alert.title = @"提交订单成功";
        alert.message = @"拨打电话?";
        [alert addCancelTitle:__TEXT(@"button_no")];
        [alert addButtonTitle:@"拨打" signal:self.DAIL_PHONE_OK];
        [alert showInViewController:self];
        
    }
    if ( [signal is:@"GO_QIUCHANGSOUSUO"] )
    {
        [self.stack pushBoard:[SouSuoQiuChangBoard_iPhone boardWithNibName:@"SouSuoQiuChangViewController"] animated:YES];
    }
    if ( [signal is:@"GO_QIUCHANGTEHUI"] )
    {
        
    }
    if ( [signal is:@"GO_TEHUITUIJIAN"] )
    {
        
    }
    if ( [signal is:@"GO_SIRENDINGZHI"] )
    {
        
    }
    
}

ON_SIGNAL2( BeeUIAlertView, signal)
{
    if ([signal is:self.DAIL_PHONE_OK])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10010"]];//打电话
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.home_data] )
	{
		if ( msg.sending )
		{
			if ( NO == self.model1.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];

			[self dismissTips];
		}

		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
	else if ( [msg is:API.home_category] )
	{
		if ( msg.sending )
		{
			if ( NO == self.model2.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];
			
			[self dismissTips];
		}
		
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	NSUInteger row = 2;

	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( index == 0 )
	{		
		BeeUICell * cell = [scrollView dequeueWithContentClass:[BannerCell_iPhone class]];
        cell.data = self.model1.banners;
		return cell;
	}

	if ( index == 1 )
	{
		BeeUICell * cell = [scrollView dequeueWithContentClass:[YudingbaoMainCell_iPhone class]];
        cell.data = self.model1.goods;
		return cell;
	}

    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( index == 0 )
	{
		return CGSizeMake( scrollView.width, 97.0f );
	}

	if ( index == 1 )
	{
		return CGSizeMake( scrollView.width, scrollView.height - 97.0f-[AppBoard_iPhone sharedInstance].tabbar.height);
	}
	
    return CGSizeZero;
}

@end
