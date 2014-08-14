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
//  MyOrderListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "MyOrderListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "QiuchangOrderCellViewController.h"
#import "UserModel.h"
#import "ServerConfig.h"
#import "MyOrderListTopSwitchViewController.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "CommonUtility.h"
#import "RechargeBoard_iPhone.h"

#pragma mark -

@interface MyOrderListBoard_iPhone() <QiuchangOrderCell_iPhoneDelegate,UIActionSheetDelegate>
{
	BeeUIScrollView* _scroll;
}

@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableArray* courseArray;
@property (nonatomic,retain) NSMutableArray* taocanArray;
@property (nonatomic,retain) NSArray* currentArray;
@property (nonatomic,retain) NSMutableArray* currentLayoutArray;
@property (nonatomic,assign) BOOL isTaocan;
@property (nonatomic,retain) MyOrderListTopSwitchViewController* switchCtrl;
@property (nonatomic,retain) NSDictionary* payingData;
@property (nonatomic,assign) NSInteger currentSelectBtnIndex;

@end

@implementation MyOrderListBoard_iPhone

- (void)load
{
	[super load];
    self.switchCtrl = [[MyOrderListTopSwitchViewController alloc] initWithNibName:@"MyOrderListTopSwitchViewController" bundle:nil];
    self.currentLayoutArray = [NSMutableArray array];
}

- (void)unload
{
    self.dataDict = nil;
    self.currentLayoutArray = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@""];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGSize rSize = __IMAGE(@"titleicon").size;
        CGRect rRect = CGRectMake(0, 10, rSize.width, rSize.height+10);
        UIImageView* rightImg = [[UIImageView alloc] initWithFrame:rRect];
        rightImg.image = __IMAGE(@"titleicon");
        rightImg.contentMode = UIViewContentModeBottom;
        rightImg.backgroundColor = [UIColor clearColor];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightImg];
        [self setTitleView:self.switchCtrl.view];
        
        [self.switchCtrl selectButtonCourse];
        self.isTaocan = NO;
        [self.switchCtrl.buttonCourse addTarget:self action:@selector(_selectCourse) forControlEvents:UIControlEventTouchUpInside];
        [self.switchCtrl.buttonTaocan addTarget:self action:@selector(_selectTaocan) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect;
        
        ////
        rect = self.viewBound;
        rect.origin.y+=40;
        rect.size.height-=40;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        
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
        
        [self pressedSwitchBtn:self.btnsel0];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES animated:NO];
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
    if ( [signal is:@"pay_with_account"] )
    {
        if (self.payingData)
        {
            [self requestMoneyPayCourse:self.payingData[@"id"]];
        }
    }
    else if ([signal is:@"increase_account"])
    {
        RechargeBoard_iPhone* board = [RechargeBoard_iPhone boardWithNibName:@"RechargeBoard_iPhone"];
        [self.stack pushBoard:board animated:YES];
    }
}

#pragma mark -

- (void)resetCells
{
    [self devideDatas];
    if (!self.isTaocan)
    {
        self.currentArray = self.courseArray;
    }
    else
    {
        self.currentArray = self.taocanArray;
    }
    [self reorderDatas];
    [self resetLayouts];
    [_scroll reloadData];
    //[_scroll scrollToLastPage:NO];
    //[_scroll scrollToFirstPage:NO];
}

- (void)resetLayouts
{
    [self.currentLayoutArray removeAllObjects];
    for (NSDictionary* dict in self.currentArray)
    {
        QiuchangOrderCell_iPhoneLayout* lo = [QiuchangOrderCell_iPhoneLayout layoutWithDict:dict];
        [self.currentLayoutArray addObject:lo];
    }
}

- (void)reorderDatas
{
    //按照订单时间排序
    id tmp = nil;
    NSArray* lists = @[self.courseArray,self.taocanArray];
    for (NSMutableArray* arr in lists)
    {
        for (int i = 0; i < arr.count ; ++i)
        {
            for (int j = i + 1; j < arr.count; ++j)
            {
                NSNumber* dti = arr[i][@"createtime"];
                NSNumber* dtj = arr[j][@"createtime"];
                if ([dtj intValue] > [dti intValue])
                {
                    tmp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = tmp;
                }
            }
            
        }
    }
}

- (void)devideDatas
{
    self.courseArray = [NSMutableArray array];
    self.taocanArray = [NSMutableArray array];
    for (NSDictionary* dict in self.dataDict[@"order"])
    {
        if ([dict[@"type"] intValue] == 1)
        {
            [self.courseArray addObject:dict];
        }
        else if ([dict[@"type"] intValue] == 2)
        {
            [self.taocanArray addObject:dict];
        }
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.currentArray)
    {
        row = [self.currentArray count];
    }
    //scrollView->_lineCount = 0;
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	QiuchangOrderCell_iPhone* cell = [scrollView dequeueWithContentClass:[QiuchangOrderCell_iPhone class]];
    
    cell.tag = index;
    cell.delegate = self;
    cell.data = self.currentArray[index];
    
    QiuchangOrderCell_iPhoneLayout* lo = self.currentLayoutArray[index];
    
    [cell setCellLayout:lo];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    QiuchangOrderCell_iPhoneLayout* lo = self.currentLayoutArray[index];
    return lo.cellSize;
}

#pragma mark - Network


- (void)fetchData
{
    NSArray* statusArr = @[
                           @-1,
                             @0,
                             @1,
                             @3,
                             @2,
                             @6
                           ];
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"status":statusArr[self.currentSelectBtnIndex]
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/list"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestCancelCourse:(NSString*)orderId
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"order_id":orderId
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/cancel"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestMoneyPayCourse:(NSString*)orderId
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"orderid":orderId
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"balance"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
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
        if ([[req.url absoluteString] rangeOfString:@"courseorder/list"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //拉订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
        else if ([[req.url absoluteString] rangeOfString:@"courseorder/cancel"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //取消订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self presentMessageTips:@"取消成功"];
                [self fetchData];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
        else if ([[req.url absoluteString] rangeOfString:@"balance"].length > 0)
        {
            //余额支付
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self presentMessageTips:@"付款成功"];
                [self _presentAertView];
                [self fetchData];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
    }
}





#pragma mark <QiuchangOrderCell_iPhoneDelegate>

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                 onPressedCancel:(NSDictionary*)data
{
    [self requestCancelCourse:data[@"id"]];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                  onPressedShare:(NSDictionary*)data
{
    [cell shareOrder:data];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                    onPressedPay:(NSDictionary*)data
{
    self.payingData = data;
    UIActionSheet* as = [[[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付",@"余额支付", nil] autorelease];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
               onPressedQiuchang:(NSDictionary*)data
{
    
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* realPrice = [self _getPayingPrice];
    
    switch (buttonIndex)
    {
        case 0:
        {
            //支付宝支付
            NSLog(@"支付宝支付");
            if (realPrice)
            {
                [CommonUtility alipayCourseWithPayId:self.payingData[@"pay_id"]
                                             ordersn:self.payingData[@"order_sn"]
                                                body:self.payingData[@"pay_id"]
                                               price:realPrice
                                      callbackTarget:self
                                         callbackSel:@selector(paymentResult:)];
            }
            
        }
            break;
        
        case 1:
        {
            //余额支付
            NSLog(@"余额支付");
            if ([[UserModel sharedInstance].user.user_money floatValue] < [[self _getPayingPrice] floatValue])
            {
                BeeUIAlertView * alert = [BeeUIAlertView spawn];
                alert.title = @"您的余额不足以支付";
                [alert addCancelTitle:@"取消"];
                [alert addButtonTitle:@"充值" signal:@"increase_account"];
                [alert showInViewController:self];
            }
            else
            {
                BeeUIAlertView * alert = [BeeUIAlertView spawn];
                alert.title = [NSString stringWithFormat:@"确定使用余额中￥%@支付此订单？",[self _getPayingPrice]];
                alert.message = [NSString stringWithFormat:@"支付后余额还剩￥%.2f",[[UserModel sharedInstance].user.user_money floatValue] - [[self _getPayingPrice] floatValue]];
                [alert addCancelTitle:@"取消"];
                [alert addButtonTitle:@"支付" signal:@"pay_with_account"];
                [alert showInViewController:self];
            }
            
        }
            break;
            
        default:
            break;
    }
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{
    //结果处理
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                [self _presentAertView];
			}
        }
        else
        {
            //交易失败
            [[[UIApplication sharedApplication] keyWindow] presentFailureTips:@"交易失败"];
        }
    }
    else
    {
        //失败
    }
    [self fetchData];
}

#pragma mark -

- (void)_selectCourse
{
    [self.switchCtrl selectButtonCourse];
    self.isTaocan = NO;
    [self fetchData];
}

- (void)_selectTaocan
{
    [self.switchCtrl selectButtonTaocan];
    self.isTaocan = YES;
    [self fetchData];
}

- (NSString*)_getPayingPrice
{
    NSObject* price = nil;
    NSString* realPrice = nil;
    
    if (self.payingData)
    {
        price = self.payingData[@"price"];
        if ([price isKindOfClass:[NSString class]])
        {
            realPrice = (NSString*)price;
        }
        else if([price isKindOfClass:[NSNumber class]])
        {
            realPrice = [NSString stringWithFormat:@"%@",price];
        }
        else if([price isKindOfClass:[NSDictionary class]])
        {
            if ([((NSDictionary*)price)[@"price"] isKindOfClass:[NSDictionary class]])
            {
                realPrice = ((NSDictionary*)price)[@"price"][@"price"];
            }
            else
            {
                realPrice = ((NSDictionary*)price)[@"price"];
            }
            
        }
    }
    
    return realPrice;
}

- (void)_presentAertView
{
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    NSString* price = [self _getPayingPrice];
    alert.title = @"付款成功";
    alert.message = [NSString stringWithFormat:@"恭喜您获得爱高积分：%d分\n支付金额中会有1块钱支持慈善活动",[price intValue]];
    [alert addCancelTitle:@"好的"];
    [alert showInViewController:self];
}

- (void)dealloc {
    [_btnsel0 release];
    [_btnsel1 release];
    [_btnsel2 release];
    [_btnsel3 release];
    [_btnsel4 release];
    [_btnsel5 release];
    [super dealloc];
}

- (IBAction)pressedSwitchBtn:(UIButton *)sender
{
    NSArray* btnArr = @[
                        self.btnsel0,
                        self.btnsel1,
                        self.btnsel2,
                        self.btnsel3,
                        self.btnsel4,
                        self.btnsel5
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
@end
