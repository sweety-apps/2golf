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
	
#import "ProfileBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "AddressListBoard_iPhone.h"
#import "SettingBoard_iPhone.h"
#import "AwaitPayBoard_iPhone.h"
#import "AwaitShipBoard_iPhone.h"
#import "ShippedBoard_iPhone.h"
#import "FinishedBoard_iPhone.h"
#import "CollectionBoard_iPhone.h"
#import "NotificationBoard_iPhone.h"
#import "HelpCell_iPhone.h"
#import "HelpBoard_iPhone.h"
#import "Placeholder.h"
#import "MyOrderListBoard_iPhone.h"
#import "ChangePasswordBoard_iPhone.h"
#import "RechargeBoard_iPhone.h"
#import "MyPointsBoard_iPhone.h"
#import "HelpMainBoard_iPhone.h"
#import "HelpArticlesBoard_iPhone.h"
#import "CommonUtility.h"
#import "WebViewBoard_iPhone.h"

#pragma mark -

@implementation ProfileCell_iPhone

SUPPORT_RESOURCE_LOADING(YES);

- (void)load
{
    [super load];
    [self checkXMLAndLayout];
}

- (void)checkXMLAndLayout
{
    BOOL needRelayout = NO;
    NSString* xmlName = nil;
    
    if ([UserModel online])
    {
        if (self.layout && [self.layout.name isEqualToString:@"ProfileCell_iPhone_Login"]) {
            needRelayout = NO;
        }
        else
        {
            needRelayout = YES;
            xmlName = @"ProfileCell_iPhone_Login.xml";
        }
    }
    else
    {
        if (self.layout && [self.layout.name isEqualToString:@"ProfileCell_iPhone_Unlogin"]) {
            needRelayout = NO;
        }
        else
        {
            needRelayout = YES;
            xmlName = @"ProfileCell_iPhone_Unlogin.xml";
        }
    }
    
    if (needRelayout)
    {
        self.FROM_RESOURCE(xmlName);
        self.layout.name = [xmlName substringToIndex:[xmlName rangeOfString:@".xml"].location];
        [self performSelector:@selector(updateContents) withObject:nil afterDelay:0.01];
    }
    else
    {
        [self updateContents];
    }
}

- (void)updateContents
{
    if ( self.data )
    {
        UserModel * userModel = self.data;
        
		if ( [UserModel online] )
		{
            NSString* namestr = @"";
            if ([userModel.user.is_vip intValue] == 1) {
                namestr = [NSString stringWithFormat:@"%@\n%@",userModel.user.name,userModel.user.vip_number];
            } else {
                if (userModel.user.name.length != 0) {
                    namestr = [NSString stringWithFormat:@"%@\n%@",userModel.user.name,userModel.user.user_name == nil ?@"":userModel.user.user_name];
                } else {
                    namestr = userModel.user.user_name;
                }
            }
            
			$(@"#name").TEXT(namestr);
		}
		else
		{
			//$(@"#name").TEXT(__TEXT(@"click_to_login"));
		}
        
        NSInteger order_num = 0;
        
        if (userModel.user.order_num &&
            [userModel.user.order_num[@"combo_order"] isKindOfClass:[NSString class]] &&
            [userModel.user.order_num[@"course_order"] isKindOfClass:[NSString class]])
        {
            order_num = [userModel.user.order_num[@"combo_order"] intValue] + [userModel.user.order_num[@"course_order"] intValue];
        }
        
        if ( 0 == order_num )
		{
			$(@"#order-count").TEXT( @"无" );
		}
		else
		{
			$(@"#order-count").TEXT( [NSString stringWithFormat:@"%d%@", order_num, @""] );
		}
        
		if ( 0 == userModel.user.collection_num.intValue )
		{
			$(@"#fav-count").TEXT( @"无" );
		}
		else
		{
			$(@"#fav-count").TEXT( [NSString stringWithFormat:@"%@%@", userModel.user.collection_num, @""] );
		}
        
        $(@"#current-version").TEXT([NSString stringWithFormat:@"%d",kCurrentAppVersion]);
        
		NSNumber * num1 = [[userModel.user.order_num objectAtPath:@"await_pay"] asNSNumber];
		if ( num1 && num1.intValue )
		{
			$(@"#await_pay-bg").SHOW();
			$(@"#await_pay").SHOW().DATA( num1 );
		}
		else
		{
			$(@"#await_pay-bg").HIDE();
			$(@"#await_pay").HIDE();
		}
        
		NSNumber * num2 = [[userModel.user.order_num objectAtPath:@"await_ship"] asNSNumber];
		if ( num2 && num2.intValue )
		{
			$(@"#await_ship-bg").SHOW();
			$(@"#await_ship").SHOW().DATA( num2 );
		}
		else
		{
			$(@"#await_ship-bg").HIDE();
			$(@"#await_ship").HIDE();
		}
		
		NSNumber * num3 = [[userModel.user.order_num objectAtPath:@"shipped"] asNSNumber];
		if ( num3 && num3.intValue )
		{
			$(@"#shipped-bg").SHOW();
			$(@"#shipped").SHOW().DATA( num3 );
		}
		else
		{
			$(@"#shipped-bg").HIDE();
			$(@"#shipped").HIDE();
		}
		
		NSNumber * num4 = [[userModel.user.order_num objectAtPath:@"finished"] asNSNumber];
		if ( num4 && num4.intValue )
		{
			$(@"#finished-bg").SHOW();
			$(@"#finished").SHOW().DATA( num4 );
		}
		else
		{
			$(@"#finished-bg").HIDE();
			$(@"#finished").HIDE();
		}
		
		if ( [UserModel online] )
		{
			if ( [UserModel sharedInstance].avatar )
			{
                $(@"#header-avatar-head-icon").SHOW();
                $(@"#header-avatar-head-icon").IMAGE( [UserModel sharedInstance].avatar );
                $(@"#header-avatar").HIDE();
			}
			else
			{
                $(@"#header-avatar-head-icon").HIDE();
				$(@"#header-avatar").IMAGE( [Placeholder has_avatar] );
                $(@"#header-avatar").SHOW();
			}
			
			$(@"#header-carema").SHOW();
			$(@"#carema").SHOW();
			$(@"#signin").HIDE();
            
            if ( userModel.user.rank_level.integerValue == RANK_LEVEL_NORMAL )
            {
                $(@"#header-level-icon").HIDE();
            }
            else
            {
                $(@"#header-level-icon").HIDE();
                $(@"#header-level-icon").DATA( @"profile-vip-icon.png" );
            }
            
            $(@"#header-level-name").HIDE();
            $(@"#header-level-name").DATA( userModel.user.rank_name );
            
            if ([userModel.user.user_money floatValue] > 0.0001)
            {
                $(@"#header_money_name").DATA(@"余额");
                $(@"#header_money_value").DATA( [NSString stringWithFormat:@"￥%@",userModel.user.user_money]);
            }
            else
            {
                $(@"#header_money_name").DATA(@"我要充值");
                $(@"#header_money_value").DATA(@"");
            }
            
            $(@"#header_score_value").DATA( [userModel.user.points stringValue]);
            
            if ([userModel.user.is_vip intValue] == 1) {
                $(@"#lblenterofhighmember").TEXT(@"爱高会员详情>");
            }
            else
            {
                $(@"#lblenterofhighmember").TEXT(@"成为爱高会员>");
            }
		}
		else
		{
			// [[AppBoard_iPhone sharedInstance] showLogin];
			$(@"#header-avatar-head-icon").HIDE();
			$(@"#header-avatar").IMAGE( [Placeholder avatar] );
			$(@"#header-carema").HIDE();
			$(@"#carema").HIDE();
			$(@"#signin").SHOW();
            $(@"#header-level-icon").HIDE();
            $(@"#header-level-name").HIDE();
            
            //[self setNeedsDisplay];
            //[self setNeedsLayout];
		}
    }
}

- (void)dataDidChanged
{
    [self checkXMLAndLayout];
}

@end

@interface ProfileCell_iPhone_Login : ProfileCell_iPhone

@end

@implementation ProfileCell_iPhone_Login

@end

@interface ProfileCell_iPhone_Unlogin : ProfileCell_iPhone

@end

@implementation ProfileCell_iPhone_Unlogin

@end

#pragma mark -

@interface ProfileBoard_iPhone()
{
	BeeUIScrollView *		_scroll;
    ProfileCell_iPhone *	_profile;
    
    BOOL _hasViewWillAppear;
}
@end

#pragma mark -

@implementation ProfileBoard_iPhone

DEF_SIGNAL( PHOTO_FROM_CAMERA )
DEF_SIGNAL( PHOTO_FROM_LIBRARY )
DEF_SIGNAL( PHOTO_REMOVE )

DEF_SIGNAL(DAIL_PHONE_OK);
DEF_SIGNAL(DAIL_PHONE_NAV_BTN);

- (void)load
{
    [super load];
    
    [[UserModel sharedInstance] addObserver:self];
    
	self.helpModel = [[[HelpModel alloc] init] autorelease];
	[self.helpModel addObserver:self];
}

- (void)unload
{
    [self.helpModel removeObserver:self];
    self.helpModel = nil;
    
    [[UserModel sharedInstance] removeObserver:self];

    [super unload];
}

#pragma mark -

static UIImageView* gBarBGView = nil;
static BeeUIButton* gPhoneBtn = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self showNavigationBarAnimated:NO];
		[self setTitleString:@"爱高"];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"我的爱高"];
        
        UIView* phoneBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        phoneBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* phoneBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.image = __IMAGE(@"telephoneicon");
        gPhoneBtn = phoneBtn;
        [phoneBtn addSignal:self.DAIL_PHONE_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = phoneBtn.frame;
        rect.size.height+=6;
        phoneBtnContainerView.frame = rect;
        rect = phoneBtn.frame;
        rect.origin.y+=6;
        phoneBtn.frame = rect;
        //[phoneBtnContainerView addSubview:phoneBtn];
        
        [self showBarButton:BeeUINavigationBar.RIGHT custom:phoneBtn];
        
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        _scroll.disableResyncCellPosition = YES;
		[self.view addSubview:_scroll];
        
        _profile = [[ProfileCell_iPhone alloc] initWithFrame:CGRectZero];
        [_scroll showHeaderLoader:YES animated:YES];
        _scroll.headerShown = NO;
        _scroll.footerShown = NO;
		
		[self observeNotification:UserModel.LOGIN];
		[self observeNotification:UserModel.LOGOUT];
		[self observeNotification:UserModel.KICKOUT];
		[self observeNotification:UserModel.UPDATED];
        
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
        //[bar setFrame:CGRectMake(0, 20, 320, 50)];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		[self unobserveAllNotifications];
		
		SAFE_RELEASE_SUBVIEW( _scroll );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		_scroll.frame = self.viewBound;
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [self.helpModel loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if (!_hasViewWillAppear)
        {
            _hasViewWillAppear = YES;
            [self updateState];
            
            if ( NO == self.helpModel.loaded )
            {
                [self.helpModel fetchFromServer];
            }
        }
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        _hasViewWillAppear = NO;
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
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
    }
    else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
    {
        [self.stack pushBoard:[SettingBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
        [[UserModel sharedInstance] updateProfile];
		
        if ( NO == self.helpModel.loaded )
		{
			[self.helpModel fetchFromServer];
		}
        
		[[CartModel sharedInstance] fetchFromServer];
	}
}

ON_SIGNAL2( ProfileBoard_iPhone, signal )
{
    if ( [signal is:self.PHOTO_FROM_CAMERA] )
    {
        //Take Photo with Camera
        @try {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
                UIImagePickerController *cameraVC = [[UIImagePickerController alloc] init];
                [cameraVC setSourceType:UIImagePickerControllerSourceTypeCamera];
                [cameraVC.navigationBar setBarStyle:UIBarStyleBlack];
                [cameraVC setDelegate:self];
                [cameraVC setAllowsEditing:YES];
                [self presentModalViewController:cameraVC animated:YES];
                [cameraVC release];
                
            }else {
                CC(@"Camera is not available.");
            }
        }
        @catch (NSException *exception) {
            CC(@"Camera is not available.");
        }
    }
    else if ( [signal is:self.PHOTO_FROM_LIBRARY] )
    {
        //Show Photo Library
        @try {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc] init];
                [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
                [imgPickerVC setDelegate:self];
                [imgPickerVC setAllowsEditing:YES];
                [self presentModalViewController:imgPickerVC animated:YES];
                [imgPickerVC release];
            }else {
                CC(@"Album is not available.");
            }
        }
        @catch (NSException *exception) {
            //Error
            CC(@"Album is not available.");
        }
    }
	else if ( [signal is:self.PHOTO_REMOVE] )
	{
        $(_profile).FIND(@"#header-avatar").DATA( [Placeholder image] );

        [[UserModel sharedInstance] setAvatar:nil];
        
        [self updateState];
        
		[self dismissModalViewControllerAnimated:YES];
	}
    else if ( [signal is:self.DAIL_PHONE_NAV_BTN] )
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        //			alert.title = @"提交订单成功";
        alert.message = @"拨打电话?";
        [alert addCancelTitle:@"取消"];
        [alert addButtonTitle:@"拨打" signal:self.DAIL_PHONE_OK];
        [alert showInViewController:self];
        
    }
}

ON_SIGNAL2( BeeUIAlertView, signal)
{
    if ([signal is:self.DAIL_PHONE_OK])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008229222"]];//打电话
    }
}

ON_SIGNAL3( ProfileCell_iPhone, signin, signal )
{
	if ( NO == [UserModel online] )
	{
		[[AppBoard_iPhone sharedInstance] showLogin];
		return;
	}	
}

ON_SIGNAL3( ProfileCell_iPhone, collection, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
		
        [self.stack pushBoard:[CollectionBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, notification, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[NotificationBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, manage, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AddressListBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_await_pay, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AwaitPayBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_await_ship, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[AwaitShipBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_shipped, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[ShippedBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, change_password, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        
        [self.stack pushBoard:[ChangePasswordBoard_iPhone boardWithNibName:@"ChangePasswordBoard_iPhone"] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, help, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        /*
        if (self.helpModel && [self.helpModel.articleGroups count] > 0)
        {
            ARTICLE_GROUP * articleGroup = self.helpModel.articleGroups[0];
            if ( articleGroup )
            {
                HelpBoard_iPhone * board = [HelpBoard_iPhone board];
                board.articleGroup = articleGroup;
                [self.stack pushBoard:board animated:YES];
            }
        }
         */
        HelpArticlesBoard_iPhone* board = [HelpArticlesBoard_iPhone boardWithNibName:@"HelpArticlesBoard_iPhone"];
        board.helpModel = self.helpModel;
        [self.stack pushBoard:board animated:YES];
		
    }
}

ON_SIGNAL3( ProfileCell_iPhone, order_finished, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

        [self.stack pushBoard:[FinishedBoard_iPhone board] animated:YES];
    }
}


ON_SIGNAL3( ProfileCell_iPhone, orders_list, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        
        MyOrderListBoard_iPhone* board = [MyOrderListBoard_iPhone boardWithNibName:@"MyOrderListBoard_iPhone"];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, new_version, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.2golf.cn/app/"]];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, recharge, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		RechargeBoard_iPhone* board = [RechargeBoard_iPhone boardWithNibName:@"RechargeBoard_iPhone"];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, header_score_button, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        MyPointsBoard_iPhone* board = [MyPointsBoard_iPhone boardWithNibName:@"MyPointsBoard_iPhone"];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, pay, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}
        
        [self.stack pushBoard:[AwaitShipBoard_iPhone board] animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, logout, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
		if ( NO == [UserModel online] )
		{
			[self updateState];
			return;
		}
        
        [self signout];
    }
}
ON_SIGNAL3( ProfileCell_iPhone, btnenterofhighmember, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        WebViewBoard_iPhone * board = [WebViewBoard_iPhone board];
        board.defaultTitle = @"会员权益";
        UserModel* userModel = _profile.data;
        if ([userModel.user.is_vip intValue] == 1) {
            board.htmlString = userModel.user.vip_info;
        }
        else
        {
            board.urlString = @"http://2golf.cn/article.php?id=258";
        }
        board.isToolbarHiden = YES;
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL3( ProfileCell_iPhone, carema, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		if ( NO == [UserModel online] )
		{
			[[AppBoard_iPhone sharedInstance] showLogin];
			return;
		}

		if ( [UserModel sharedInstance].avatar )
		{
			BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
			[confirm addDestructiveTitle:__TEXT(@"delete_photo") signal:self.PHOTO_REMOVE];
			[confirm addCancelTitle:__TEXT(@"button_cancel")];
			[confirm showInViewController:self];
		}
		else
		{
			BeeUIActionSheet * confirm = [BeeUIActionSheet spawn];
			
			if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
				[confirm addButtonTitle:__TEXT(@"from_camera") signal:self.PHOTO_FROM_CAMERA];
			}
			if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] )
			{
				[confirm addButtonTitle:__TEXT(@"from_album") signal:self.PHOTO_FROM_LIBRARY];
			}

			[confirm addCancelTitle:__TEXT(@"button_cancel")];
			[confirm showInViewController:self];
		}
	}
}

ON_SIGNAL2( HelpCell_iPhone, signal )
{
	[super handleUISignal:signal];
	
    ARTICLE_GROUP * articleGroup = signal.sourceCell.data;
	if ( articleGroup )
	{
		HelpBoard_iPhone * board = [HelpBoard_iPhone board];
		board.articleGroup = articleGroup;
		[self.stack pushBoard:board animated:YES];
	}
}

ON_NOTIFICATION3( PushModel, UPDATED, notification )
{
	[_scroll asyncReloadData];
}

ON_NOTIFICATION3( UserModel, LOGIN, notification )
{
	[self updateState];
}

ON_NOTIFICATION3( UserModel, LOGOUT, notification )
{
	[self updateState];
}

ON_NOTIFICATION3( UserModel, KICKOUT, notification )
{
	[self updateState];
}

ON_NOTIFICATION3( UserModel, UPDATED, notification )
{
}

ON_SIGNAL2( signout_yes, signal )
{
	[super handleUISignal:signal];
    
    [[UserModel sharedInstance] signout];
    
    [self updateState];
    
    //[self performSelector:@selector(updateState) withObject:nil afterDelay:0.5];
}

- (void)updateState
{
	if ( [UserModel online] )
	{
		[[CartModel sharedInstance] fetchFromServer];
		
		if ( ![UserModel sharedInstance].loaded )
		{
			[[UserModel sharedInstance] updateProfile];
		}
		
		[_scroll showHeaderLoader:YES animated:YES];
	}
	else
	{
//		[[AppBoard_iPhone sharedInstance] showLogin];
		
		[_scroll showHeaderLoader:YES animated:YES];
	}
    
    [_profile release];
    _profile = [[ProfileCell_iPhone alloc] initWithFrame:CGRectZero];
	
	[_scroll reloadData];
}

#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];

    if ( [msg is:API.user_info] )
    {
//        if ( ![UserModel sharedInstance].loaded )
        {
            [_scroll setHeaderLoading:msg.sending];
        }

        if ( msg.succeed )
        {
            [_scroll asyncReloadData];
        }
    }
    else if ( [msg is:API.shopHelp] )
	{
		if ( msg.sending )
		{
			if ( NO == self.helpModel.loaded )
			{
//				[self presentLoadingTips:__TEXT(@"tips_loading")];
			}
			else
			{
				[_scroll setHeaderLoading:YES];
			}
		}
		else
		{
			[_scroll setHeaderLoading:NO];
			
			[self dismissTips];
		}
		
		if ( msg.succeed )
		{
			[_scroll asyncReloadData];
		}
		else if ( msg.failed )
		{
            //            [self presentFailureTips:@"加载失败,请稍后再试"];
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
    }
    else if ( [msg is:API.user_signin] )
    {
        [self updateState];
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger row = 0;
    
	row += 1;
	//row += self.helpModel.articleGroups.count;
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
        _profile.data = [UserModel sharedInstance];
        return _profile;
	}
    
    /*
	section += self.helpModel.articleGroups.count;
	if ( index < section )
	{
		BeeUICell * cell = [scrollView dequeueWithContentClass:[HelpCell_iPhone class]];
        cell.data = [self.helpModel.articleGroups safeObjectAtIndex:(self.helpModel.articleGroups.count - (section - index))];
		return cell;
	}
     */
    
    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    NSUInteger section = 0;
	
	section += 1;
	if ( index < section )
	{
        return [ProfileCell_iPhone estimateUISizeByWidth:scrollView.width forData:[UserModel sharedInstance]];
	}
    
    /*
	section += self.helpModel.articleGroups.count;
	if ( index < section )
	{
		id data = [self.helpModel.articleGroups safeObjectAtIndex:(self.helpModel.articleGroups.count - (section - index))];
		return [HelpCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
	}
     */
    
    return CGSizeZero;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	if ( image )
	{
        $(_profile).FIND(@"#header-avatar").IMAGE( image );

        [[UserModel sharedInstance] setAvatar:image];
	}
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

- (void)signout
{
	BeeUIActionSheet * sheet = [BeeUIActionSheet spawn];
	[sheet addButtonTitle:__TEXT(@"signout") signal:@"signout_yes"];
	[sheet addCancelTitle:__TEXT(@"cancel")];
	[sheet showInViewController:self];
}

@end
