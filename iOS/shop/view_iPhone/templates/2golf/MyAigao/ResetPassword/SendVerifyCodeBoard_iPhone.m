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
//  SendVerifyCodeBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SendVerifyCodeBoard_iPhone.h"
#import "UserModel.h"
#import "ServerConfig.h"
#import "InputNewPasswordBoard_iPhone.h"
#import "NSObject+_golfCommon.h"

#pragma mark -

@interface SendVerifyCodeBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation SendVerifyCodeBoard_iPhone

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"重置密码"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
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
        [self.stack popBoardAnimated:YES];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

- (void)dealloc {
    [_phoneNumTextFeild release];
    [super dealloc];
}
- (IBAction)pressedSend:(id)sender {
    if ([self.phoneNumTextFeild.text length] >= 10)
    {
        [self fetchData];
    }
    else
    {
        [self presentMessageTips:@"请输入正确手机号"];
    }
}

- (void)jumpToNextPage
{
    InputNewPasswordBoard_iPhone* board = [InputNewPasswordBoard_iPhone boardWithNibName:@"InputNewPasswordBoard_iPhone"];
    board.phoneNum = self.phoneNumTextFeild.text;
    [self.stack pushBoard:board animated:YES];
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"tel":self.phoneNumTextFeild.text,
                                @"type":@"resetpwd"
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"sendsms"])
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
        if ([[req.url absoluteString] rangeOfString:@"sendsms"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [self jumpToNextPage];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
    }
}
@end
