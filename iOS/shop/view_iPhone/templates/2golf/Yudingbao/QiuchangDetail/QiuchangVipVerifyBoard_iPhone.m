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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10010"]];//打电话
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


#pragma mark - Event

-(IBAction)onPressedSendBtn:(id)sender
{
    BeeUIAlertView* alert = [BeeUIAlertView spawn];
    alert.message = @"已发送验证信息给球会，等待球会确认";
    [alert addCancelTitle:@"返回" signal:self.SEND_VERIFY_OK];
    [alert showInViewController:self];
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

@end
