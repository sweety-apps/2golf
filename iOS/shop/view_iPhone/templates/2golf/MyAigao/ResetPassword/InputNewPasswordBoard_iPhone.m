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
//  InputNewPasswordBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "InputNewPasswordBoard_iPhone.h"
#import "ServerConfig.h"
#import "UserModel.h"
#import "NSObject+_golfCommon.h"

#pragma mark -

@interface InputNewPasswordBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation InputNewPasswordBoard_iPhone

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
    [_verifyCodeField release];
    [_newPassword release];
    [super dealloc];
}
- (IBAction)pressdBtn:(id)sender {
    if ([self.phoneNum length] <= 0)
    {
        [self.stack popBoardAnimated:YES];
        return;
    }
    if ([self.verifyCodeField.text length] <= 0)
    {
        [self presentMessageTips:@"请输入验证码"];
        return;
    }
    if ([self.newPassword.text length] <= 0)
    {
        [self presentMessageTips:@"请输入新密码"];
        return;
    }
    [self fetchData];
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"tel":self.phoneNum,
                                @"type":@"resetpwd",
                                @"code":self.verifyCodeField.text,
                                @"newpwd":self.newPassword.text
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"verifycode"])
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
        if ([[req.url absoluteString] rangeOfString:@"verifycode"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [[[UIApplication sharedApplication] keyWindow] presentMessageTips:@"密码修改成功，请重新登陆"];
                [[UserModel sharedInstance] signout];
                [self.stack popToFirstBoardAnimated:YES];
            }
            else
            {
                [self presentFailureTips:(dict[@"status"])[@"error_desc"]];
            }
        }
    }
}
@end
