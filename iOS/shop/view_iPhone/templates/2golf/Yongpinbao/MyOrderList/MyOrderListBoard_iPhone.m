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
#import "CommonWaterMark.h"
#import "QiuchangOrderCell_iPhoneV2.h"
#import "LTInterface.h"
#import "QuichangDetailBoard_iPhone.h"
#import "QiuChangOrderDetailBoard_iPhone.h"
#pragma mark -

@interface MyOrderListBoard_iPhone() <QiuchangOrderCell_iPhoneV2Delegate,UIActionSheetDelegate,LTInterfaceDelegate>
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
@property (nonatomic,assign) BOOL hasRefreshed;
@property (nonatomic, assign) BOOL	loaded;

@end

@implementation MyOrderListBoard_iPhone

- (void)load
{
	[super load];
    self.switchCtrl = [[MyOrderListTopSwitchViewController alloc] initWithNibName:@"MyOrderListTopSwitchViewController" bundle:nil];
    self.currentLayoutArray = [NSMutableArray array];
    self.loaded = false;
}

- (void)unload
{
    self.dataDict = nil;
    self.currentLayoutArray = nil;
	[super unload];
}

#pragma mark Signal
ON_SIGNAL2( QiuchangOrderCell_iPhoneV2, signal )
{
    QiuChangOrderDetailBoard_iPhone * board = [QiuChangOrderDetailBoard_iPhone board];
    CourseOrderCellInfo_iPhone* cell = (CourseOrderCellInfo_iPhone*)signal.source;
    board.order = cell.data;
    [self.stack pushBoard:board animated:YES];
    
}


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
        
        if (!self.hasRefreshed)
        {
            self.hasRefreshed = YES;
            [self pressedSwitchBtn:self.btnsel0];
        }
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


- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView*)scrollView
{
    return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    if ( self.loaded && 0 == self.currentArray.count )
	{
		return 1;
	}
    
	return self.currentArray.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if ( self.loaded && 0 == self.currentArray.count )
	{
		return [scrollView dequeueWithContentClass:[NoResultCell class]];
	}
    
//	QiuchangOrderCell_iPhone* cell = [scrollView dequeueWithContentClass:[QiuchangOrderCell_iPhone class]];
    QiuchangOrderCell_iPhoneV2* cell = [scrollView dequeueWithContentClass:[QiuchangOrderCell_iPhoneV2 class]];
    
    cell.tag = index;
    cell.delegate = self;
    cell.data = self.currentArray[index];
    
//    QiuchangOrderCell_iPhoneLayout* lo = self.currentLayoutArray[index];
    
//    [cell setCellLayout:lo];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	if ( self.loaded && 0 == self.currentArray.count )
	{
		return self.size;
	}
    
	int height = 195;
	return CGSizeMake(scrollView.width, height);
    
}

#pragma mark - Network

-(void)requestXML
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"orderid":self.payingData[@"id"],
                                @"method":@"submitService"
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"order/unionpay"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)fetchData
{
    NSArray* statusArr = @[
                           @-1,
                             @0,
                             @1,
                             @2,
                             @3,
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
    return [super commonCheckRequest:req];
}

- (void) handleRequest:(BeeHTTPRequest *)req
{
    NSDictionary* dict = [self commonCheckRequest:req];
    if (dict)
    {
        //订单列表
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
			self.loaded = YES;
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
        else if([[req.url absoluteString] rangeOfString:@"order/unionpay"].length >0 )
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //拉订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                if (self.dataDict)
                {
                    NSString* xml = self.dataDict[@"xml"];
                    UIViewController *viewCtrl = nil;
                    self.hidesBottomBarWhenPushed = YES;
                    
                    viewCtrl = [LTInterface getHomeViewControllerWithType:0 strOrder:xml andDelegate:self];
                    [self.stack pushViewController:viewCtrl animated:NO];
                    
                }
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
                [self.stack popBoardAnimated:YES];
            }
        }

    }
}





#pragma mark <QiuchangOrderCell_iPhoneV2Delegate>

//- (void)QiuchangOrderCell_iPhoneV2:(QiuchangOrderCell_iPhoneV2*)cell
//                 onPressedCancel:(NSDictionary*)data
//{
//    [self requestCancelCourse:data[@"id"]];
//}
//
//- (void)QiuchangOrderCell_iPhoneV2:(QiuchangOrderCell_iPhoneV2*)cell
//                  onPressedShare:(NSDictionary*)data
//{
//    [cell shareOrder:data];
//}

-(void)onPressOrderAgain:(NSDictionary *)courseorder
{
    NSDate* date = [CommonUtility getDateFromZeroPerDay:[NSDate dateWithTimeIntervalSinceNow:3600*24 ]];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
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
    
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    if (courseorder)
    {
        [board setCourseId:courseorder[@"price"][@"courseid"]];
    }
    [self.stack pushBoard:board animated:YES];
}

- (void)onPressPay:(NSDictionary *)courseorder
{
    self.payingData = courseorder;
    UIActionSheet* as = [[[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"银联支付",@"支付宝支付",@"余额支付", nil] autorelease];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];
}

//- (void)QiuchangOrderCell_iPhoneV2:(QiuchangOrderCell_iPhoneV2*)cell
//               onPressedQiuchang:(NSDictionary*)data
//{
//    
//}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* realPrice = [self _getPayingPrice];
    
    switch (buttonIndex)
    {
        case 0:
            [self requestXML];
            break;
        case 1:
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
        
        case 2:
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
                //                [self _presentAertView];
                [self presentSuccessTips:@"交易成功"];
                self.hasRefreshed = NO;
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

#pragma mark LTInterfaceDelegate
/*交易插件退出回调方法，需要商户客户端实现
 *参数：
 strResult：交易结果，若为空则用户未进行交易。
 返回值：无
 */
- (void) returnWithResult:(NSString *)strResult
{
    //    strResult = @"<?xml version=\"1.0\" encoding=\"UTF-8\" ?> <upomp application=\"LanchPay.Rsp\" version=\"1.0.0 \"><merchantId>商户代码（15-24位数字）</merchantId><merchantOrderId>商户订单号</merchantOrderId><merchantOrderTime>商户订单时间</merchantOrderTime><respCode>应答码(0000为成功，其他为失败)</respCode><respDesc>应答码描述</respDesc></upomp>";
    if(strResult == nil)
    {
        [self presentFailureTips:@"用戶取消交易"];
    }
    else
    {
        CXMLDocument *document = [[CXMLDocument alloc] initWithXMLString:strResult options:0 error:nil];
        if (document != nil) {
            CXMLElement* rootelement = document.rootElement;
            if (rootelement != nil) {
                NSArray* elements = [rootelement elementsForName:@"respCode"];
                CXMLElement* elementcode = [elements objectAtIndex:0];
                NSString* stringvalue = [elementcode stringValue];
                if ([stringvalue isEqualToString:@"0000"]) {
                    self.hasRefreshed = NO;
                    [self presentSuccessTips:@"交易成功"];
//                    [self succeedPaid];
                    return;
                }
            }
        }
        [self presentFailureTips:@"交易失敗"];
        
    }
}
@end
