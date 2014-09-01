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
//  RechargeBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "RechargeBoard_iPhone.h"
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
#import "RechargeViewUICell.h"
#import "ExtractViewUICell.h"
#import "NibLoader.h"
#import "LTInterface.h"
#import "RegionPickBoard_iPhone.h"

#pragma mark -

@interface RechargeBoard_iPhone() <RechargeViewUICellDelegate,ExtractViewUICellDelegate,UIActionSheetDelegate,UITextFieldDelegate,LTInterfaceDelegate>
{
	BeeUIScrollView* _scroll;
    
    RechargeViewUICell* _rechargeCell;
    ExtractViewUICell* _extractCell;
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度

}

@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,assign) BOOL isExtract;
@property (nonatomic,retain) MyOrderListTopSwitchViewController* switchCtrl;
@property (nonatomic,retain) NSNumber* rechargeMoneyValue;
@property (nonatomic,assign) int rechargePayway;

@end

@implementation RechargeBoard_iPhone

- (void)load
{
	[super load];
    self.switchCtrl = [[MyOrderListTopSwitchViewController alloc] initWithNibName:@"MyOrderListTopSwitchViewController" bundle:nil];
}

- (void)unload
{
    self.dataDict = nil;
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
        self.isExtract = NO;
        [self.switchCtrl.buttonCourse addTarget:self action:@selector(_selectRecharge) forControlEvents:UIControlEventTouchUpInside];
        [self.switchCtrl.buttonTaocan addTarget:self action:@selector(_selectExtract) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect;
        
        ////
        rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeedPaid) name:@"moneyPaid" object:nil];
        //注册键盘监听消息
        [self registerKeyBoardNotification];
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
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
        
        [self.switchCtrl.buttonCourse setTitle:@"充值" forState:UIControlStateNormal];
        [self.switchCtrl.buttonTaocan setTitle:@"提现" forState:UIControlStateNormal];
        
        [self resetCells];
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

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
	}
    else if ( [signal is:BeeUIScrollView.DID_DRAG] )
	{
        [self.view endEditing:YES];
	}
}

ON_SIGNAL2( BeeUIAlertView, signal)
{
    if ([signal is:@"confirm_extract"])
    {
        [self requestWithdrawData];
    }
}


#pragma mark -

- (void)resetCells
{
    _rechargeCell = CREATE_NIBVIEW(@"RechargeViewUICell");
    _extractCell = CREATE_NIBVIEW(@"ExtractViewUICell");
    _rechargeCell.delegate = self;
    _extractCell.delegate = self;
    
    _rechargeCell.confirmView.valueTextField.delegate = self;
    
    _extractCell.kaihuhangTextField.delegate = self;
    _extractCell.yinhangzhanghaoTextField.delegate = self;
    _extractCell.humingTextField.delegate = self;
    _extractCell.tixianjineTextField.delegate = self;
    _extractCell.passwordField.delegate = self;
    
    [_scroll reloadData];
}

#pragma mark -


- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
	return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	if (!self.isExtract)
    {
        _rechargeCell.data = nil;
        _rechargeCell.data = [UserModel sharedInstance];
        return _rechargeCell;
    }
    else
    {
        _extractCell.data = nil;
        _extractCell.data = [UserModel sharedInstance];
        return _extractCell;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    if (!self.isExtract)
    {
        return _rechargeCell.frame.size;
    }
    else
    {
        return _extractCell.frame.size;
    }
}

#pragma mark - Network


- (void)requestRechargeData
{
    NSDictionary* paramDict = @{
                                @"money":self.rechargeMoneyValue,
                                @"session":[UserModel sharedInstance].session.objectToDictionary
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"recharge"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestUnionPayXML
{
    NSDictionary* paramDict = @{
                                @"money":self.rechargeMoneyValue,
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"payid":[self.dataDict[@"pay_id"] stringValue],
                                @"rechargeid":self.dataDict[@"id"],
                                @"method":@"submitService"
                                
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"order/unionpay"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (void)requestWithdrawData
{
    NSString* note = [NSString stringWithFormat:@"%@ %@ %@"
                      ,_extractCell.kaihuhangTextField.text
                      ,_extractCell.yinhangzhanghaoTextField.text
                      ,_extractCell.humingTextField.text
                      ];
    double withdrawValue = [_extractCell.tixianjineTextField.text doubleValue];
    
    NSDictionary* paramDict = @{
                                @"money":[NSNumber numberWithDouble:withdrawValue],
                                @"note":note,
                                @"session":[UserModel sharedInstance].session.objectToDictionary
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"withdraw"])
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
        if ([[req.url absoluteString] rangeOfString:@"recharge"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //充值成功
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self _realRecharge];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
        else if ([[req.url absoluteString] rangeOfString:@"withdraw"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //取消订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self presentMessageTips:dict[@"status"][@"error_desc"]];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
        else if ([[req.url absoluteString] rangeOfString:@"order/unionpay"].length > 0)
        {
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                
                NSString* xml = self.dataDict[@"xml"];
                UIViewController *viewCtrl = nil;
                self.hidesBottomBarWhenPushed = YES;
                
                viewCtrl = [LTInterface getHomeViewControllerWithType:0 strOrder:xml andDelegate:self];
                [self.stack pushViewController:viewCtrl animated:YES];
//                [viewCtrl release];
//                RegionPickBoard_iPhone * board = [[[RegionPickBoard_iPhone alloc] init] autorelease];
//                board.rootBoard = self;
//                board.regions = [RegionModel sharedInstance].regions;
//                [self.stack pushBoard:board animated:YES];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
    }
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        case 1:
            
        {
            if (self.rechargeMoneyValue)
            {
                self.rechargePayway = buttonIndex;
                [self requestRechargeData];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.user_info] )
    {
        if ( msg.succeed )
        {
            [_scroll asyncReloadData];
        }
    }
}

- (void) succeedPaid
{
    [[UserModel sharedInstance] updateProfile];
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

#pragma mark -

- (void)_realRecharge
{
    switch (self.rechargePayway)
    {
        case 0:
        {
            if (self.rechargeMoneyValue)
            {
                //支付宝支付
                NSLog(@"支付宝充值");
                if (self.rechargeMoneyValue
                    && (self.dataDict[@"is_paid"] && ![self.dataDict[@"is_paid"] boolValue]))
                {
                    [CommonUtility alipayCourseWithPayId:[self.dataDict[@"pay_id"] stringValue]
                                                 ordersn:self.dataDict[@"id"]
                                                    body:self.dataDict[@"user_note"]
                                                   price:self.dataDict[@"amount"]
                                          callbackTarget:self
                                             callbackSel:@selector(paymentResult:)];
                }
            }
            
        }
            break;
        case 1:
            if (self.rechargeMoneyValue)
            {
                //银联支付
                NSLog(@"银联支付");
                if (self.rechargeMoneyValue
                    && (self.dataDict[@"is_paid"] && ![self.dataDict[@"is_paid"] boolValue]))
                {
                    [self requestUnionPayXML];
                }
            }
            break;
        default:
            break;
    }
}

- (void)_selectRecharge
{
    [self.switchCtrl selectButtonCourse];
    self.isExtract = NO;
    [self resignFirstResponder];
    [self resetCells];
}

- (void)_selectExtract
{
    if ([[UserModel sharedInstance].user.user_money doubleValue] < 50)
    {
        [self presentMessageTips:@"账户余额大于50元才能提现"];
        return;
    }
    [self.switchCtrl selectButtonTaocan];
    self.isExtract = YES;
    [self resignFirstResponder];
    [self resetCells];
}

#pragma mark - <RechargeViewUICellDelegate>

- (void)rechargeViewUICell:(RechargeViewUICell*)cell
            confirmedValue:(NSNumber*)value
{
    self.rechargeMoneyValue = value;
    UIActionSheet* as = [[[UIActionSheet alloc] initWithTitle:@"选择充值方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝充值",@"银联充值",nil] autorelease];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - <ExtractViewUICellDelegate>

- (void)extractViewUICell:(ExtractViewUICell*)cell
           confirmedValue:(NSNumber*)value
{
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    alert.title = @"确认提取现金";
    alert.message = [NSString stringWithFormat:@"提取 ￥%@ 到\n%@\n%@\n%@"
                     ,cell.tixianjineTextField.text
                     ,cell.kaihuhangTextField.text
                     ,cell.yinhangzhanghaoTextField.text
                     ,cell.humingTextField.text
                     ];
    [alert addCancelTitle:__TEXT(@"button_no")];
    [alert addButtonTitle:__TEXT(@"button_yes") signal:@"confirm_extract"];
    [alert showInViewController:self];
}

#pragma mark- 键盘通知事件 ［核心代码］


//注册键盘监听消息
-(void)registerKeyBoardNotification
{
    return;
    //增加监听，当键盘出现或改变时收出消息    ［核心代码］
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //计算偏移量
    if (self.isExtract)
    {
        i_offset = i_textFieldY - 440;//keyboardHeight - (self.view.frame.size.height-(i_textFieldY+i_textFieldHeight));
    }
    else
    {
        i_offset = i_textFieldY - 200;//keyboardHeight - (self.view.frame.size.height-(i_textFieldY+i_textFieldHeight));
    }
    
    //进行偏移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(i_offset > 0)
    {
        CGRect rect = CGRectMake(0.0f,i_offset,width,height); //把整个view 往上提，肯定要用负数 y
        [_scroll setContentOffset:rect.origin animated:YES];;
    }
    
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(NO && i_offset > 0)
    {
        //恢复到偏移前的正常量
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        CGRect rect = CGRectMake(0.0f,20,width,height); //把整个view 往上提，肯定要用负数 y   注意self.view 的y 是从20开始的，即StautsBarHeight
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
    
    i_offset = 0;
}

#pragma mark <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _extractCell.tixianjineTextField)
    {
        NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        double value = [newString doubleValue];
        if (value + 5.0 < [[UserModel sharedInstance].user.user_money doubleValue])
        {
            NSNumber* zje = [NSNumber numberWithDouble:value + 5.0];
            _extractCell.zongjineLabel.text = [NSString stringWithFormat:@"￥%@",zje];
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    i_textFieldY = [textField convertRect:textField.frame toView:_scroll].origin.y;
    i_textFieldHeight = textField.size.height;
    //[self keyboardWillHide:nil];
    [self keyboardWillShow:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self keyboardWillHide:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark LTInterfaceDelegate
/*交易插件退出回调方法，需要商户客户端实现
 *参数：
 strResult：交易结果，若为空则用户未进行交易。
 返回值：无
 */
- (void) returnWithResult:(NSString *)strResult
{
    
}
@end
