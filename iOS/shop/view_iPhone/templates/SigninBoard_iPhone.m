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

#import "SigninBoard_iPhone.h"
#import "SignupBoard_iPhone.h"
#import "SendVerifyCodeBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "model.h"
#import "RememberPasswordView.h"
#import "CommonSharedData.h"

#pragma mark -

@interface SigninBoard_iPhone() <RememberPasswordViewDelegate>
{
	BeeUIScrollView * _scroll;
}
@property (nonatomic,retain) RememberPasswordView* remeberPswView;
@end

#pragma mark -

@implementation SigninBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

SUPPORT_RESOURCE_LOADING( YES )
SUPPORT_AUTOMATIC_LAYOUT( YES )

DEF_SINGLETON( SigninBoard_iPhone )

- (void)load
{
	[[UserModel sharedInstance] addObserver:self];
}

- (void)unload
{
	[[UserModel sharedInstance] removeObserver:self];
}

#pragma mark -

static UIImageView* gBarBGView = nil;
static BeeUIButton* gRightBtn = nil;
static BeeUIButton* gLeftBtn = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:NO];
		[self setTitleString:@"爱高"];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:__TEXT(@"member_signin")];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect;
        
        //右上角购物车按钮
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = __IMAGE(@"goodsmyorderbtn");
        [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor]];
        [rightBtn setTitle:__TEXT(@"login_login") forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-8, 0, 56, 38);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        //rightBtnContainerView.left = -15;
        
        //NavigationBar背景太短
        UIImageView* barBGView = [[[UIImageView alloc] initWithImage:__IMAGE(@"titlebarbg")] autorelease];
        rect = barBGView.frame;
        if (IOS7_OR_LATER)
        {
            rect.origin.y = 0;
        }
        else
        {
            rect.origin.y = -20;
        }
        barBGView.frame = rect;
        gBarBGView=barBGView;
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:barBGView atIndex:2];
        [gBarBGView retain];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        self.remeberPswView = nil;
        [gBarBGView release];
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
        [self showNavigationBarAnimated:NO];
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:gBarBGView atIndex:2];
        
        [((UIButton*)$(@"#signup").view).titleLabel setFont:[UIFont systemFontOfSize:18]];
        [((UIButton*)$(@"#changepswd").view).titleLabel setFont:[UIFont systemFontOfSize:18]];
        
        if (self.remeberPswView == nil)
        {
            self.remeberPswView = CREATE_NIBVIEW(@"RememberPasswordView");
            CGRect rct = self.remeberPswView.frame;
            rct.origin = CGPointMake(0, 110);
            self.remeberPswView.frame = rct;
            [self.view addSubview:self.remeberPswView];
            self.remeberPswView.delegate = self;
        }
        self.remeberPswView.checkBtn.selected = [[CommonSharedData sharedInstance] hasCheckedSelectedSaveUserNameAndPassword] ? YES : NO;
        $(@"username").TEXT(@"");
        $(@"password").TEXT(@"");
        if ([[CommonSharedData sharedInstance] hasCheckedSelectedSaveUserNameAndPassword])
        {
            NSString* userName = [[CommonSharedData sharedInstance] getSavedUserName];
            NSString* psw = [[CommonSharedData sharedInstance] getSavedPawword];
            if (userName != nil)
            {
                $(@"username").TEXT(userName);
            }
            if (psw != nil)
            {
                $(@"password").TEXT(psw);
            }
        }
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [[CommonSharedData sharedInstance] saveUserName:@"" andPassword:@""];
        NSString * userName = $(@"username").text.trim;
        NSString * password = $(@"password").text.trim;
        if (self.remeberPswView.checkBtn.selected)
        {
            [[CommonSharedData sharedInstance] saveUserName:userName andPassword:password];
        }
        [[CommonSharedData sharedInstance] setCheckedSelectedSaveUserNameAndPassword:self.remeberPswView.checkBtn.selected];
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];

	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
		[[AppBoard_iPhone sharedInstance] hideLogin];
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
		
	}
}

ON_SIGNAL( signal )
{
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        [self doLogin];
    }
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];

    if ( [signal is:BeeUITextField.RETURN] )
    {
		if ( $(@"username").focusing )
		{
			$(@"password").FOCUS();
            return;
		}
		else
		{
			[self doLogin];
		}
		
        [self.view endEditing:YES];
    }
}

ON_SIGNAL3( SigninBoard_iPhone, signup, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self.stack pushBoard:[[[SignupBoard_iPhone alloc] init] autorelease] animated:YES];
	}
}

ON_SIGNAL3( SigninBoard_iPhone, changepswd, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self.stack pushBoard:[SendVerifyCodeBoard_iPhone boardWithNibName:@"SendVerifyCodeBoard_iPhone"] animated:YES];
	}
}

- (void)doLogin
{
	NSString * userName = $(@"username").text.trim;
	NSString * password = $(@"password").text.trim;
	
	if ( 0 == userName.length || NO == [userName isChineseUserName] )
	{
		[self presentMessageTips:__TEXT(@"wrong_username")];
		return;
	}
    
	if ( userName.length < 3 )
	{
		[self presentMessageTips:__TEXT(@"username_too_short")];
		return;
	}
    
	if ( userName.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"username_too_long")];
		return;
	}
    
	if ( 0 == password.length || NO == [password isPassword] )
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}
    
	if ( password.length < 6 )
	{
		[self presentMessageTips:__TEXT(@"password_too_short")];
		return;
	}
	
	if ( password.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"password_too_long")];
		return;
	}

    [[CommonSharedData sharedInstance] saveUserName:@"" andPassword:@""];
    if (self.remeberPswView.checkBtn.selected)
    {
        [[CommonSharedData sharedInstance] saveUserName:userName andPassword:password];
    }
    [[CommonSharedData sharedInstance] setCheckedSelectedSaveUserNameAndPassword:self.remeberPswView.checkBtn.selected];
    
	[[UserModel sharedInstance] signinWithUser:userName password:password];
}

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.user_signin] )
	{
		if ( msg.sending )
		{
			[self presentLoadingTips:__TEXT(@"signing_in")];
		}
		else
		{
			[self dismissTips];
		}

		if ( msg.succeed )
		{
			if ( [UserModel sharedInstance].firstUse )
			{
				[[AppBoard_iPhone sharedInstance] presentSuccessTips:__TEXT(@"welcome")];
			}
			else
			{
				[[AppBoard_iPhone sharedInstance] presentSuccessTips:__TEXT(@"welcome_back")];
			}
			
			[[AppBoard_iPhone sharedInstance] hideLogin];
		}
		else if ( msg.failed )
		{
//			[self presentFailureTips:@"登录失败，请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

#pragma mark <RememberPasswordViewDelegate>

- (void) rememberPasswordSelected:(BOOL)selected
{
    if (!selected)
    {
        //$(@"username").TEXT(@"");
        //$(@"password").TEXT(@"");
    }
}

@end
