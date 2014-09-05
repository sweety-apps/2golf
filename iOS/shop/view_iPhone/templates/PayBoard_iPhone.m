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
	
#import "PayBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "CommonUtility.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "LTInterface.h"

#pragma mark -

@interface PayBoard_iPhone ()
<LTInterfaceDelegate>

@property (nonatomic, retain) NSMutableDictionary* dataDict;

@end

#pragma mark -

@implementation PayBoard_iPhone

- (void)load
{
    [super load];
    
    self.isFromCheckoutBoard = NO;
    
    self.orderModel = [[[OrderModel alloc] init] autorelease];
    [self.orderModel addObserver:self];
}

- (void)unload
{
    [self.orderModel removeObserver:self];
    self.orderModel = nil;
    [super unload];
}

#pragma mark -

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self hideNavigationBarAnimated:NO];
//        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:__TEXT(@"pay")];
//        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeedPaid) name:@"moneyPaid" object:nil];
        
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
        
        if ( NSOrderedSame == [self.order.pay_code compare:@"upop" options:NSCaseInsensitiveSearch] )
        {
            if ( self.orderID )
            {
                ORDER * order = [[[ORDER alloc] init] autorelease];
                order.order_id = self.orderID;
                [self.orderModel pay:order];
                
                [self requestXML];
            }
        }
        else if ( NSOrderedSame == [self.order.pay_code compare:@"alipay" options:NSCaseInsensitiveSearch] )
        {
            if ( self.orderID )
            {
                ORDER * order = [[[ORDER alloc] init] autorelease];
                order.order_id = self.orderID;
                [self.orderModel pay:order];
                
                [self requestPaylog:[self.orderID stringValue]];
            }
        }
        else if ( NSOrderedSame == [self.order.pay_code compare:@"balance" options:NSCaseInsensitiveSearch] )
        {
            
        }

        
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        if ( self.isFromCheckoutBoard )
        {
            if ( self.previousBoard.previousBoard.previousBoard )
            {
                [self.stack popToBoard:self.previousBoard.previousBoard.previousBoard animated:YES];
            }
            else
            {
                [self.stack popBoardAnimated:YES];
            }
        }
        else
        {
            [self.stack popBoardAnimated:YES];
        }
	}
}

- (void)handleMessage:(BeeMessage *)msg
{
//    if ( msg.sending )
//    {
//        [self presentLoadingTips:__TEXT(@"tips_loading")];
//    }
//    else
//    {
//        [self dismissTips];
//    }
    
    if ( [msg is:API.order_pay] )
    {
        if ( msg.succeed )
        {
            //self.htmlString = self.orderModel.html;
            //[self refresh];
        }
        else if ( msg.failed )
        {
			[ErrorMsg presentErrorMsg:msg inBoard:self];
        }
    }
}

#pragma mark - Network
-(void)requestXML
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"orderid":self.order.order_id,
                                @"method":@"submitService"
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"order/unionpay"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestUnionPayQuery
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"orderid":self.order.order_id,
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"order/unionpayQuery"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestPaylog:(NSString*)orderId
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"orderid":orderId
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"paylog"])
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
        //球场详情
        if ([[req.url absoluteString] rangeOfString:@"paylog"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //拉订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                if (self.dataDict)
                {
                    NSString* payid = self.dataDict[@"log_id"];
                    [CommonUtility alipayCourseWithPayId:payid
                                                 ordersn:self.orderSN
                                                    body:payid
                                                   price:self.totalFee
                                          callbackTarget:self
                                             callbackSel:@selector(paymentResult:)];
                }
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
                [self.stack popBoardAnimated:YES];
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

- (void) succeedPaid
{
    [[UserModel sharedInstance] updateProfile];
    [self.stack popBoardAnimated:YES];
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
    [self succeedPaid];
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
                    [self presentSuccessTips:@"交易成功"];
                    [self requestUnionPayQuery];
                    [self succeedPaid];
                    return;
                }
            }
        }
        [self presentFailureTips:@"交易失敗"];
        
    }
    [self.stack popBoardAnimated:YES];
}

@end
