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

#import "AwaitShipBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "OrdersBoard_iPhone.h"
#import "CommonWaterMark.h"

#pragma mark -

@implementation AwaitShipCellFooter_iPhone

SUPPORT_RESOURCE_LOADING( YES )

- (void)dataDidChanged
{
    $(@"#cart-goods-desc").TEXT( __TEXT(@"balance_rental") );
    
    if ( self.data )
    {
        $(@"#cart-goods-price").TEXT( self.data );
    }
    else
    {
        $(@"#cart-goods-price").TEXT(@"0.00");
    }
}

@end

@implementation AwaitShipCell_iPhone

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    CGSize size = CGSizeMake( width, [self.class heightByCount:3] );
    return size;
}

+ (CGFloat)heightByCount:(NSInteger)count
{
    return ( 195 + 90 * count );
}

- (void)layoutDidFinish
{
    _scroll.frame = CGRectMakeBound(self.width, self.height);
	[_scroll reloadData];
}

- (void)load
{
    [super load];
    
    _scroll = [[BeeUIScrollView alloc] init];
    _scroll.scrollEnabled = NO;
    _scroll.dataSource = self;
    [self addSubview:_scroll];
    
    _dataCounts = 3;
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        self.order = self.data;
        
        _dataCounts = self.order.goods_list.count + 3;
        
        [_scroll reloadData];
    }
    else
    {
        _dataCounts = 3;
    }
}


#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	return _dataCounts;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if ( 0 == index )
    {
        OrderCellHeader_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellHeader_iPhone class]];
        cell.data = self.order;
        return cell;
    }
    else if( (_dataCounts - 1) == index )
    {
        AwaitShipCellFooter_iPhone * cell = [scrollView dequeueWithContentClass:[AwaitShipCellFooter_iPhone class]];
        cell.data = self.order.total_fee;
        return cell;
    }
    else if( (_dataCounts - 2) == index )
    {
        OrderCellInfo_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellInfo_iPhone class]];
        cell.formated_integral_money = self.order.formated_integral_money;
        cell.formated_bonus = self.order.formated_bonus;
        cell.formated_shipping_fee = self.order.formated_shipping_fee;
        cell.data = nil;
        return cell;
    }
    else
    {
        OrderCellBody_iPhone * cell = [scrollView dequeueWithContentClass:[OrderCellBody_iPhone class]];
        cell.data = [self.order.goods_list objectAtIndex:(index - 1)];
        return cell;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeZero;
    
    if ( 0 == index )
    {
        size = CGSizeMake(320, 50);
    }
    else if( (_dataCounts - 1) == index )
    {
        size = CGSizeMake(320, 90);
    }
    else if( (_dataCounts - 2) == index )
    {
        size = CGSizeMake(320, 70);
    }
    else
    {
        size = CGSizeMake(320, 90);
    }
    
	return size;
}

@end

#pragma mark -

@interface AwaitShipBoard_iPhone()
{
	BeeUIScrollView * _scroll;
}
@end

#pragma mark -

@implementation AwaitShipBoard_iPhone

- (void)load
{
    [super load];
    
    self.awaitShipModel = [[[OrderAwaitShipModel alloc] init] autorelease];
    [self.awaitShipModel addObserver:self];
}

- (void)unload
{
    [self.awaitShipModel removeObserver:self];
    self.awaitShipModel = nil;
    
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:__TEXT(@"await_ship")];
        
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll showHeaderLoader:YES animated:NO];
        [_scroll showFooterLoader:YES animated:NO];
		[self.view addSubview:_scroll];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		_scroll.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[_scroll reloadData];
		
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ( [UserModel online] )
        {
            [self.awaitShipModel prevPageFromServer];
        }
        else
        {
            [[AppBoard_iPhone sharedInstance] showLogin];
        }
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self.awaitShipModel prevPageFromServer];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
		[self.awaitShipModel nextPageFromServer];
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

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.order_list] )
    {
        if ( msg.sending )
        {
            if ( self.awaitShipModel.loaded )
            {
				[_scroll setHeaderLoading:YES];
				[_scroll setFooterLoading:YES];
            }
            else
            {
                [self presentLoadingTips:__TEXT(@"tips_loading")];
            }
        }
        else 
        {
            [self dismissTips];

            [_scroll setHeaderLoading:NO];
			[_scroll setFooterLoading:NO];
        }
        
        if ( msg.succeed )
        {
			[_scroll setFooterMore:self.awaitShipModel.more];
			[_scroll asyncReloadData];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
	if ( self.awaitShipModel.loaded && 0 == self.awaitShipModel.orders.count )
	{
		return 1;
	}

	return self.awaitShipModel.orders.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if ( self.awaitShipModel.loaded && 0 == self.awaitShipModel.orders.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}

	AwaitShipCell_iPhone * cell = [scrollView dequeueWithContentClass:[AwaitShipCell_iPhone class]];
	cell.data = [self.awaitShipModel.orders objectAtIndex:index];
	return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( self.awaitShipModel.loaded && 0 == self.awaitShipModel.orders.count )
	{
		return self.size;
	}

	ORDER * order = [self.awaitShipModel.orders objectAtIndex:index];
	int height = [AwaitShipCell_iPhone heightByCount:order.goods_list.count];
	return CGSizeMake(scrollView.width, height);
}

@end
