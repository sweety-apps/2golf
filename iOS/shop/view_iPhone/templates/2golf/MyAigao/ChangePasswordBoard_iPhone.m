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
//  ChangePasswordBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-25.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "ChangePasswordBoard_iPhone.h"
#import "CommonUtility.h"
#import "UserModel.h"
#import "ServerConfig.h"
#import "NSObject+_golfCommon.h"

#pragma mark -

@interface ChangePasswordBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation ChangePasswordBoard_iPhone

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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"修改密码"];
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

- (IBAction)pressedBtn:(id)sender {
    if ([self.oldPasswordFeild.text length] <= 0)
    {
        [self presentMessageTips:@"请输入旧密码"];
        return;
    }
    if ([self.newPasswordFeild.text length] <= 0)
    {
        [self presentMessageTips:@"请输入新密码"];
        return;
    }
    [self fetchData];
}


#pragma mark - Network


- (void)fetchData
{
    if ([UserModel online])
    {
        NSDictionary* paramDict = @{
                                    @"session":[UserModel sharedInstance].session.objectToDictionary,
                                    @"oldpassword":self.oldPasswordFeild.text,
                                    @"newpassword":self.newPasswordFeild.text
                                    };
        [self presentLoadingTips:@"正在加载"];
        self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"changepassword"])
        .PARAM(@"json",[paramDict JSONString])
        //.PARAM(@"session",[UserModel sharedInstance].session.objectToDictionary)
        //.PARAM(@"oldpassword",self.oldPasswordFeild.text)
        //.PARAM(@"newpassword",self.newPasswordFeild.text)
        .TIMEOUT(30);
    }
    else
    {
        [self presentFailureTips:@"登陆有效期已过，请重新登陆"];
    }
    
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
        if ([[req.url absoluteString] rangeOfString:@"changepassword"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [[[UIApplication sharedApplication] keyWindow] presentMessageTips:@"密码修改成功，请重新登陆"];
                [[UserModel sharedInstance] signout];
                [self.stack popBoardAnimated:NO];
                [CommonUtility checkLoginAndPresentLoginView];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
    }
}

- (void)dealloc {
    [_oldPasswordFeild release];
    [_newPasswordFeild release];
    [super dealloc];
}

@end
