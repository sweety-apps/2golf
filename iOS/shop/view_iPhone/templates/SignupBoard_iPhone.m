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

#import "SignupBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "model.h"

#pragma mark -

@interface SignupBoard_iPhone()

@property (nonatomic,retain) NSMutableArray* datas;
@property (nonatomic,retain) NSMutableArray* inputs;

@end

#pragma mark -

@implementation SignupBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
    [super load];
    
    self.datas = [NSMutableArray array];
    
	[[UserModel sharedInstance] addObserver:self];
}

- (void)unload
{
	[[UserModel sharedInstance] removeObserver:self];
    
    [self.datas removeAllObjects];
	self.datas = nil;
    
    [super unload];
}

#pragma mark -

static BeeUIButton* gRightBtn = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal_BeeUIBoard:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		self.titleString = __TEXT(@"member_signup");
        [self showNavigationBarAnimated:NO];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角购物车按钮
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = __IMAGE(@"goodsmyorderbtn");
        [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor]];
        [rightBtn setTitle:__TEXT(@"register_regist") forState:UIControlStateNormal];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-8, 0, 56, 38);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        UILabel* infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 80)];
        infoLbl.backgroundColor = [UIColor clearColor];
        infoLbl.textAlignment = NSTextAlignmentCenter;
        infoLbl.textColor = [UIColor grayColor];
        infoLbl.font = [UIFont systemFontOfSize:14.0f];
        infoLbl.numberOfLines = 0;
        infoLbl.text = @"密码只支持大小写字母和数字，请不要含有 . , / ! 等特殊符号";
        [self.view addSubview:infoLbl];
        
        [self observeNotification:BeeUIKeyboard.HIDDEN];
        [self observeNotification:BeeUIKeyboard.SHOWN];
        [self observeNotification:BeeUIKeyboard.HEIGHT_CHANGED];
	}
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveNotification:BeeUIKeyboard.HIDDEN];
        [self unobserveNotification:BeeUIKeyboard.HEIGHT_CHANGED];
        [self unobserveNotification:BeeUIKeyboard.SHOWN];
        
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
        [self updateTextField];
    }
}

ON_SIGNAL( signal )
{
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        [self doRegister];
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

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUITextField.RETURN] )
    {
        NSArray * inputs = self.inputs;
        
        BeeUITextField * input = (BeeUITextField *)signal.source;
        
        NSInteger index = [inputs indexOfObject:input];
        
        if ( UIReturnKeyNext == input.returnKeyType )
        {
            BeeUITextField * next = [inputs objectAtIndex:(index + 1)];
            [next becomeFirstResponder];
        }
        else if ( UIReturnKeyDone == input.returnKeyType )
        {
            [self.view endEditing:YES];
            [self doRegister];
        }
    }
    else if ( [signal is:BeeUITextField.WILL_ACTIVE] )
    {
        NSArray * inputs = self.inputs;
        
        BeeUITextField * input = (BeeUITextField *)signal.source;
        
        NSInteger index = [inputs indexOfObject:input];
        
        if ( index > 4 )
        {
            //[self.table setContentOffset:CGPointMake(0, (index-3) * 45) animated:YES];
        }
    }
}

ON_SIGNAL3( SignupBoard_iPhone, signin, signal )
{
	if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
	{
		[self.stack popBoardAnimated:YES];
	}
}


- (void)handleNotification_BeeUIKeyboard_SHOWN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 0 : 0;
    
    [UIView animateWithDuration:0.35f animations:^{
        //[self.table setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HEIGHT_CHANGED:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    CGFloat keyboardHeight = [BeeUIKeyboard sharedInstance].height;
    
    CGFloat offsetHeight = [BeeSystemInfo isPhoneRetina4] ? 0 : 0;
    
    [UIView animateWithDuration:0.35f animations:^{
        //[self.table setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight - offsetHeight, 0)];
    }];
}

- (void)handleNotification_BeeUIKeyboard_HIDDEN:(NSNotification *)notification
{
    [super handleNotification:notification];
    
    [UIView animateWithDuration:0.35f animations:^{
        //[self.table setContentInset:UIEdgeInsetsZero];
    }];
}

- (void)updateTextField
{
    
#if 1
    NSArray * fields = [UserModel sharedInstance].fields;
#else
    NSMutableArray * fields = [NSMutableArray array];
    
    for ( int i=0; i<5; i++ )
    {
        SIGNUP_FIELD * f = [[[SIGNUP_FIELD alloc] init] autorelease];
        f.name = [NSString stringWithFormat:@"Field%d", i];
        f.id = @(i);
        f.need = @(NO);
        [fields addObject:f];
    }
#endif
    
    FormElement * username = [FormElement input];
    username.tagString = @"username";
    username.placeholder = __TEXT(@"login_username");
    username.returnKeyType = UIReturnKeyNext;
    //((FormInputCell*)username).input.maxLength = 11;
    
    FormElement * email = [FormElement input];
    email.tagString = @"email";
    email.placeholder = __TEXT(@"register_email");
    email.returnKeyType = UIReturnKeyNext;
    
    FormElement * password = [FormElement input];
    password.tagString = @"password";
    password.placeholder = @"密码(密码至少6位)";
    password.isSecure = YES;
    password.returnKeyType = UIReturnKeyNext;
    
    FormElement * password2 = [FormElement input];
    password2.tagString = @"password2";
    password2.placeholder = __TEXT(@"register_confirm");
    password2.isSecure = YES;
    
    if ( fields.count == 0 )
    {
        password2.returnKeyType = UIReturnKeyDone;
    }
    else
    {
        password2.returnKeyType = UIReturnKeyNext;
    }
    
    NSArray * group1 = @[username, email, password, password2];
    [self.datas addObject:group1];

    if ( fields && 0 != fields.count  )
    {
        NSMutableArray * group2 = [NSMutableArray array];
        
        for ( int i=0; i<fields.count; i++ )
        {
            SIGNUP_FIELD * field = fields[i];
            
            FormElement * element = [FormElement input];
            element.tagString = field.id.stringValue;
            element.placeholder = field.name;
            element.data = field;
            
            if ( i == (fields.count - 1) )
            {
                element.returnKeyType = UIReturnKeyDone;
            }
            else
            {
                element.returnKeyType = UIReturnKeyNext;
            }
            
            [group2 addObject:element];
        }
        
        [self.datas addObject:group2];
    }
}

- (void)doRegister
{    
    NSString * userName = nil;
  	NSString * email = nil;
  	NSString * password = nil;
  	NSString * password2 = nil;
    
    NSMutableArray * fields = [NSMutableArray array];

    userName = $(@"username").text;
    password = $(@"password").text;
    password2 = $(@"password2").text;
    
    if ([userName length] > 0)
    {
        email = [NSString stringWithFormat:@"%@@2golf.com",userName];
    }
	
	if ( 0 == userName.length || NO == [userName isChineseUserName] )
	{   
		[self presentMessageTips:__TEXT(@"wrong_username")];
		return;
	}
    
	if ( userName.length < 11 )
	{
		[self presentMessageTips:@"电话号码不能少于11位"];
		return;
	}
    
	if ( userName.length > 20 )
	{
		[self presentMessageTips:@"错误的电话号码"];
		return;
	}

	if ( 0 == email.length || NO == [email isEmail] )
	{
		[self presentMessageTips:__TEXT(@"wrong_email")];
		return;
	}
    
    if ( 0 == password.length)
    {
        [self presentMessageTips:@"请输入密码"];
        return;
    }
    
    if ( password.length < 6 )
	{
		[self presentMessageTips:__TEXT(@"password_too_short")];
		return;
	}
	
	if ( 0 == password.length || NO == [password isPassword] )
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}
	
	
	if ( password.length > 20 )
	{
		[self presentMessageTips:__TEXT(@"password_too_long")];
		return;
	}
	
	if ( NO == [password isEqualToString:password2] )
	{
		[self presentMessageTips:__TEXT(@"wrong_password")];
		return;
	}

	[[UserModel sharedInstance] signupWithUser:userName
									  password:password
										 email:email
										fields:fields];
}

- (void)handleMessage:(BeeMessage *)msg
{
	if ( [msg is:API.user_signup] )
	{
		if ( msg.sending )
		{
			[self presentLoadingTips:__TEXT(@"signing_up")];
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
			[ErrorMsg presentErrorMsg:msg inBoard:self];
		}
	}
}

@end
