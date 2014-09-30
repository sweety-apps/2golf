//
//  OrderListBoard_iPhone.m
//  2golf
//
//  Created by rolandxu on 9/30/14.
//  Copyright (c) 2014 geek-zoo studio. All rights reserved.
//

#import "OrderListBoard_iPhone.h"
#import "OrderModel.h"
#import "CommonWaterMark.h"
#import "AwaitPayBoard_iPhone.h"
#import "AwaitShipBoard_iPhone.h"
#import "ShippedBoard_iPhone.h"
#import "FinishedBoard_iPhone.h"
#import "ErrorMsg.h"
#import "AppBoard_iPhone.h"
#import "PayBoard_iPhone.h"

@interface OrderListBoard_iPhone()
{
    BeeUIScrollView* _scroll;
}

@property (nonatomic,assign) NSInteger currentSelectBtnIndex;
@property (nonatomic, retain) OrderModel * orderModel;

@end


@implementation OrderListBoard_iPhone

- (void)load
{
    [super load];
    self.orderModel = [[[OrderModel alloc] init] autorelease];
    [self.orderModel addObserver:self];
}

- (void)unload
{
    [self.orderModel removeObserver:self];
    self.orderModel = nil;
    [super unload];
}


ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"用品订单"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect;
        
        rect = self.viewBound;
        rect.origin.y+=40;
        rect.size.height-=40;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
        _scroll.dataSource = self;
        _scroll.vertical = YES;
        [_scroll showHeaderLoader:YES animated:YES];
        [self.view addSubview:_scroll];
        [self pressedSwitchBtn:self.btnsel0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"moneyPaid" object:nil];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        rect.origin.y+=40;
        rect.size.height-=40;
        _scroll.frame =rect;
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



- (IBAction)pressedSwitchBtn:(UIButton *)sender
{
    NSArray* btnArr = @[
                        self.btnsel0,
                        self.btnsel1,
                        self.btnsel2,
                        self.btnsel3,
                        self.btnsel4,
                        ];
    
    for (int i = 0; i < btnArr.count; ++i)
    {
        UIButton* b = btnArr[i];
        b.selected = NO;
        if (b == sender)
        {
            self.currentSelectBtnIndex = i;
            b.selected = YES;
        }
    }
    [self fetchData];
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

ON_SIGNAL2( BeeUIScrollView, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
    {
        [self.orderModel prevPageFromServer];
    }
    else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] ||
             [signal is:BeeUIScrollView.FOOTER_REFRESH] )
    {
        [self.orderModel nextPageFromServer];
    }
}

ON_SIGNAL2( AwaitPayCell_iPhone, signal )
{
    AwaitPayCell_iPhone * cell = (AwaitPayCell_iPhone *)signal.source;
    
    if ( [signal is:AwaitPayCell_iPhone.ORDER_CANCEL] )
    {
        [self.orderModel cancel:cell.order];
    }
    else if ( [signal is:AwaitPayCell_iPhone.ORDER_PAY] )
    {
        ORDER * order = cell.order;
        
        if ( order.order_info )
        {
            if ( NSOrderedSame == [order.order_info.pay_code compare:@"cod" options:NSCaseInsensitiveSearch] )
            {
                [[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_noneed")];
                return;
            }
        }
        
        PayBoard_iPhone * board = [PayBoard_iPhone board];
        board.orderID = order.order_id;
        board.orderSN = order.order_sn;
        board.totalFee = [order.total_fee substringFromIndex:1];
        board.titleString = __TEXT(@"pay");
        board.order = order.order_info;
        [self.stack pushBoard:board animated:NO];
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
            if ( self.orderModel.loaded )
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
    }
    else
    {
        [_scroll setHeaderLoading:msg.sending];
        [_scroll setFooterLoading:msg.sending];
    }
    
    if ( [msg is:API.order_list] )
    {
        if ( msg.succeed && ((STATUS *)msg.GET_OUTPUT(@"status")).succeed.boolValue )
        {
            [_scroll setFooterMore:self.orderModel.more];
            [_scroll syncReloadData];
        }
        else if ( msg.failed )
        {
            //            [self presentFailureTips:@"加载失败"];
            [ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
    else if ( [msg is:API.order_cancel] )
    {
        if ( msg.succeed && ((STATUS *)msg.GET_OUTPUT(@"status")).succeed.boolValue )
        {
            [self presentSuccessTips:__TEXT(@"successful_operation")];
            
            [self.orderModel prevPageFromServer];

        }
    }
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

ON_NOTIFICATION3( ServiceAlipay, WAITING, notification )
{
}

ON_NOTIFICATION3( ServiceAlipay, SUCCEED, notification )
{
    [[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_succeed")];
    
    if ( [UserModel online] )
    {
        [self.orderModel prevPageFromServer];
    }
}

ON_NOTIFICATION3( ServiceAlipay, FAILED, notification )
{
    //[[BeeUIApplication sharedInstance] presentMessageTips:__TEXT(@"pay_failed")];
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    if ( self.orderModel.loaded && 0 == self.orderModel.orders.count )
    {
        return 1;
    }
    
    return self.orderModel.orders.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if ( self.orderModel.loaded && 0 == self.orderModel.orders.count )
    {
        return [scrollView dequeueWithContentClass:[NoResultCell class]];
    }
    BeeUICell* cell = nil;
    switch (_currentSelectBtnIndex) {
        case 0:
            cell = [scrollView dequeueWithContentClass:[AwaitPayCell_iPhone class]];
            break;
        case 1:
            cell = [scrollView dequeueWithContentClass:[AwaitShipCell_iPhone class]];
            break;
        case 2:
            cell = [scrollView dequeueWithContentClass:[ShippedCell_iPhone class]];
            break;
        case 3:
            cell = [scrollView dequeueWithContentClass:[FinishedCell_iPhone class]];
            break;
        case 4:
            cell = [scrollView dequeueWithContentClass:[FinishedCell_iPhone class]];
            break;
        default:
            break;
    }
    cell.data = [self.orderModel.orders objectAtIndex:index];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    if ( self.orderModel.loaded && 0 == self.orderModel.orders.count )
    {
        return self.size;
    }
    
    ORDER * order = [self.orderModel.orders objectAtIndex:index];
    int height = 0;
    switch (_currentSelectBtnIndex) {
        case 0:
            height = [AwaitPayCell_iPhone heightByCount:order.goods_list.count];
            break;
        case 1:
            height = [AwaitShipCell_iPhone heightByCount:order.goods_list.count];
            break;
        case 2:
            height = [ShippedCell_iPhone heightByCount:order.goods_list.count];
            break;
        case 3:
            height = [FinishedCell_iPhone heightByCount:order.goods_list.count];
            break;
        case 4:
            height = [FinishedCell_iPhone heightByCount:order.goods_list.count];
            break;
        default:
            break;
    }
    return CGSizeMake(scrollView.width, height);
}


-(void)fetchData
{
    NSArray* statusArr = @[
                           @"await_pay",
                             @"await_ship",
                             @"shipped",
                             @"cancelled",
                             @"finished"
                             ];

    [self presentLoadingTips:@"正在加载"];
    self.orderModel.type = [statusArr objectAtIndex:_currentSelectBtnIndex];
    [self.orderModel prevPageFromServer];
}
@end
