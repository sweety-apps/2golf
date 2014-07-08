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
//  QiuchangVipVerifyBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangVipVerifyBoard_iPhone.h"
#import "UserModel.h"
#import "CommonUtility.h"
#import "ServerConfig.h"

#pragma mark -

@interface QiuchangVipVerifyBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QiuchangVipVerifyBoard_iPhone

DEF_SIGNAL(DAIL_PHONE_OK)
DEF_SIGNAL(SEND_VERIFY_OK)

- (void)load
{
	[super load];
}

- (void)unload
{
    self.numTextFeild = nil;
    self.nameTextFeild = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"会员身份验证"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [self resignFirstResponder];
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

ON_SIGNAL2( BeeUIAlertView, signal)
{
    if ([signal is:self.DAIL_PHONE_OK])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008229222"]];//打电话
    }
    if ([signal is:self.SEND_VERIFY_OK])
    {
        [self.stack popBoardAnimated:YES];
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

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self resignFirstResponder];
    
    return YES;
}

#pragma mark - Event

-(IBAction)onPressedSendBtn:(id)sender
{
    if (![CommonUtility checkLoginAndPresentLoginView])
    {
        return;
    }
    if (
        [self.numTextFeild.text length] <= 0 ||
        [self.nameTextFeild.text length] <= 0
        )
    {
        [self presentFailureTips:@"请输入完整信息"];
        return;
    }
    [self fetchData];
}

-(IBAction)onPressedPhoneBtn:(id)sender
{
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    //			alert.title = @"提交订单成功";
    alert.message = @"拨打电话?";
    alert.delegate = self;
    [alert addCancelTitle:@"取消"];
    [alert addButtonTitle:@"拨打" signal:self.DAIL_PHONE_OK];
    [alert showInViewController:self];
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"coursename":self.nameTextFeild.text,
                                @"cardnumber":self.numTextFeild.text,
                                @"courseid":self.courseId
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"authapply"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
    
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self dismissTips];
        [self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
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
        if ([[req.url absoluteString] rangeOfString:@"authapply"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                BeeUIAlertView* alert = [BeeUIAlertView spawn];
                alert.message = @"已发送验证信息给球会，等待球会确认";
                [alert addCancelTitle:@"返回" signal:self.SEND_VERIFY_OK];
                [alert showInViewController:self];
            }
            else
            {
                [self presentFailureTips:(dict[@"status"])[@"error_desc"]];
            }
        }
    }
}

@end
