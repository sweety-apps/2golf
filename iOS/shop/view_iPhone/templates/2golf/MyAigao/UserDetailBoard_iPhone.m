//
//  UserDetailBoard_iPhone.m
//  2golf
//
//  Created by rolandxu on 14-10-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "UserDetailBoard_iPhone.h"
#import "AppBoard_iPhone.h"

@implementation UserDetailCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data
{
    return CGSizeMake( width, 524.0f );
}

- (void)load
{
    [super load];
    
    
}

ON_SIGNAL3( UserDetailCell_iPhone, birthdaybtn, signal )
{
    if ( [signal is:BeeUIButton.TOUCH_UP_INSIDE] )
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickBirthday:)]) {
            [self.delegate onClickBirthday:nil];
        }
        [self endEditing:YES];
    }
}

ON_SIGNAL3(UserDetailCell_iPhone, sexmalechk, signal)
{
    $(@"#sexmalechk").SELECT();
    $(@"#sexfemalechk").UNSELECT();
    $(@"#sexsecretchk").UNSELECT();
    [self endEditing:YES];
}


ON_SIGNAL3(UserDetailCell_iPhone, sexfemalechk, signal)
{
    $(@"#sexmalechk").UNSELECT();
    $(@"#sexfemalechk").SELECT();
    $(@"#sexsecretchk").UNSELECT();
    [self endEditing:YES];
}


ON_SIGNAL3(UserDetailCell_iPhone, sexsecretchk, signal)
{
    
    $(@"#sexmalechk").UNSELECT();
    $(@"#sexfemalechk").UNSELECT();
    $(@"#sexsecretchk").SELECT();
    [self endEditing:YES];
    
}

ON_SIGNAL2( BeeUITextField, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUITextField.RETURN] )
    {
        NSArray * inputs = $(self).FIND(@".input").views;
        
        BeeUITextField * input = (BeeUITextField *)signal.source;
        
        NSInteger index = [inputs indexOfObject:input];
        
        if ( UIReturnKeyNext == input.returnKeyType )
        {
            BeeUITextField * next = [inputs objectAtIndex:(index + 1)];
            [next becomeFirstResponder];
        }
        else if ( UIReturnKeyDone == input.returnKeyType )
        {
            [self endEditing:YES];
        }
    }
    
    NSLog(@"%@",$(@"#nameinput").text);
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        USER* user = self.data;
        $(@"#vipnumber").TEXT(user.vip_number);
        $(@"#name").TEXT(user.name);
        $(@"#nameinput").TEXT(user.name);
        $(@"#tel").TEXT(user.user_name);
        $(@"#telinput").TEXT(user.user_name);
        $(@"#birthday").TEXT(user.birthday);
        $(@"#birthdaybtn").TEXT(user.birthday);
        $(@"#email").TEXT(user.email);
        $(@"#emailinput").TEXT(user.email);
        
        switch (user.sex_val) {
            case 0:
                $(@"#sex").TEXT(@"保密");
                $(@"#sexmalechk").UNSELECT();
                $(@"#sexfemalechk").UNSELECT();
                $(@"#sexsecretchk").SELECT();
                break;
            case 1:
                $(@"#sex").TEXT(@"男");
                $(@"#sexmalechk").SELECT();
                $(@"#sexfemalechk").UNSELECT();
                $(@"#sexsecretchk").UNSELECT();
                break;
            case 2:
                $(@"#sex").TEXT(@"女");
                $(@"#sexmalechk").UNSELECT();
                $(@"#sexfemalechk").SELECT();
                $(@"#sexsecretchk").UNSELECT();
                break;
                
            default:
                break;
        }
    }
    else
    {
        
    }
}

-(void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (_isEditing) {
        $(@"#name").HIDE();
        $(@"#nameinput").SHOW();
        
        $(@"#tel").HIDE();
        $(@"#telinput").SHOW();
        
        $(@"#birthday").HIDE();
        $(@"#birthdaybtn").SHOW();
        
        $(@"#sex").HIDE();
        $(@"#sexmalechk").SHOW();
        $(@"#sexfemalechk").SHOW();
        $(@"#sexsecretchk").SHOW();
        
        
        $(@"#email").HIDE();
        $(@"#emailinput").SHOW();
        
    }
    else
    {
        $(@"#name").SHOW();
        $(@"#nameinput").HIDE();
        
        $(@"#tel").SHOW();
        $(@"#telinput").HIDE();
        
        $(@"#birthday").SHOW();
        $(@"#birthdaybtn").HIDE();
        
        $(@"#sex").SHOW();
        $(@"#sexmalechk").HIDE();
        $(@"#sexfemalechk").HIDE();
        $(@"#sexsecretchk").HIDE();
        
        
        $(@"#email").SHOW();
        $(@"#emailinput").HIDE();
    }
}

-(void)setBirthdayString:(NSString *)birthdayString
{
    _birthdayString = birthdayString;
    $(@"#birthday").TEXT(_birthdayString);
    $(@"#birthdaybtn").TEXT(_birthdayString);
}

-(USER*)getCurrentUserInfo
{
    USER* ret = self.data;
    ret.name = $(@"#nameinput").text;
    ret.user_name = $(@"#telinput").text;
    ret.birthday = $(@"#birthdaybtn").text;
    
    if($(@"#sexmalechk").selected)
    {
        ret.sex_val = 1;
    }
    else if($(@"#sexfemalechk").selected)
    {
        ret.sex_val = 2;
    }
    else if($(@"#sexsecretchk").selected)
    {
        ret.sex_val = 0;
    }
    
    ret.email = $(@"#emailinput").text;
    return ret;
}
@end

@interface UserDetailBoard_iPhone ()
<UserDetailCell_iPhoneDelegate,UIActionSheetDelegate>
{
    BeeUIScrollView* _scroll;
    UIDatePicker* _datepicker;
    UIButton* _confirm;
    USER* user ;
    UserDetailCell_iPhone* _cell;
}
@end

@implementation UserDetailBoard_iPhone

- (void)load
{
	[super load];
	[[UserModel sharedInstance] addObserver:self];
    
    [user release];
    user = nil;
    user = [[UserModel sharedInstance].user retain];
}

- (void)unload
{
    [[UserModel sharedInstance] removeObserver:self];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];
    
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"会员详情"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
        
        self.isEditing = NO;
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"body-bg.png"]];
		_scroll = [[BeeUIScrollView alloc] init];
		_scroll.dataSource = self;
        [_scroll showHeaderLoader:YES animated:NO];
        [_scroll showFooterLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        [_scroll setBackgroundColor:[UIColor clearColor]];
        [self.view setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0f alpha:1.0]];
        
        _datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 216, 320, 216)];
        [self.view addSubview:_datepicker];
        [_datepicker setHidden:YES];
        _datepicker.datePickerMode = UIDatePickerModeDate;
        _confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirm setTitle:@"确定" forState:UIControlStateNormal];
        [_confirm setFrame:CGRectMake(270, _datepicker.frame.origin.y - 30, 50, 30)];
        [_confirm setBackgroundColor:[UIColor clearColor]];
        [_confirm addTarget:self action:@selector(onClickConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [_confirm setHidden:YES];
        [_confirm setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:_confirm];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
		SAFE_RELEASE_SUBVIEW( _scroll );
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		_scroll.frame = self.viewBound;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        [[UserModel sharedInstance] loadCache];
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
//		[self updateViews];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
		[[UserModel sharedInstance] updateProfile];
        
        [_scroll reloadData];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
		self.isEditing = NO;
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
        if ( self.isEditing )
        {
            USER* tmpuser = [_cell getCurrentUserInfo];
            [[UserModel sharedInstance] updateUser:tmpuser.name phone:tmpuser.user_name email:tmpuser.email sexval:tmpuser.sex_val birthday:tmpuser.birthday];
        }
        else
        {
            self.isEditing = YES;
            [self updateViews];
        }

	}
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[[UserModel sharedInstance] updateProfile];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
//		[self.usermodel nextPageFromServer];
	}
}


- (void)updateViews
{
    if ( self.isEditing )
    {
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav-right.png"]];
        [_scroll reloadData];
        [_scroll setHeaderShown:NO];
        
    }
    else
    {

    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if (index < 6) {
        _cell = [scrollView dequeueWithContentClass:[UserDetailCell_iPhone class]];
        _cell.data = user;
        _cell.isEditing = self.isEditing;
        _cell.delegate = self;
//        if(index != 0)
//        {
//            cell.isEditing = self.isEditing;
//            if (self.isEditing && index == 1) {
////                [cell.editvalueview becomeFirstResponder];
//            }
//        }
//        else
//        {
//            cell.isEditing = NO;
//        }
//        cell.titleview.text = [_titlearray objectAtIndex:index];
//        cell.valueview.text = [_valuearray objectAtIndex:index] ;
//        cell.editvalueview.text = [_valuearray objectAtIndex:index];
//        cell.valueview.tag = index;
//        if (index == 2) {
//            cell.editvalueview.keyboardType = UIKeyboardTypePhonePad;
//        }
//        else if(index == 5)
//        {
//            cell.editvalueview.keyboardType = UIKeyboardTypeEmailAddress;
//        }
//        else
//        {
//            cell.editvalueview.delegate = self;
//        }
        return _cell;
    }
    else if(index == 6)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(30, 0, 270, 40)];
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 1)];
//        [view setBackgroundColor:[UIColor colorWithString:@"b0afb0"]];
        [view setBackgroundColor:[UIColor colorWithRed:176/255.0 green:175/255.0 blue:176/255 alpha:1.0]];
        [cell.contentView addSubview:view];
        return cell;
    }
    else if(index == 7)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, 280, 120)];
        BeeUIImageView* view = [[BeeUIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, 120)];
        [view setUrl:[UserModel sharedInstance].user.vip_card_url];
        [cell addSubview:view];
        return cell;
    }
    else if(index == 8)
    {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        UILabel* view = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 280, 40)];
        [view setTextAlignment:NSTextAlignmentLeft];
        [view setText:@"会员特权："];
        [cell addSubview:view];
        return cell;
    }
    else if (index == 9)
    {
//        UITableViewCell* cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(20, 0, privilegesize.width, privilegesize.height)];
//        UITextView* lbl = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, privilegesize.width, privilegesize.height)];
//        [lbl setText:[UserModel sharedInstance].user.privilege];
//        [cell addSubview:lbl];
//        [lbl setFont:[UIFont systemFontOfSize:16]];
//        [lbl setBackgroundColor:[UIColor clearColor]];
//        [lbl setEditable:NO];
//        return cell;
    }
    else
    {
        return nil;
    }
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    return [UserDetailCell_iPhone estimateUISizeByWidth:scrollView.width forData:user];
}

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( [msg is:API.user_info] )
    {
        {
            [_scroll setHeaderLoading:msg.sending];
        }
        
        if ( msg.succeed )
        {
            [user release];
            user = nil;
            user = [[UserModel sharedInstance].user retain];
            [_scroll reloadData];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[formatter dateFromString:user.birthday];
            
            _datepicker.date = date;
            
            [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
        }
    }
    else if([msg is:API.user_update])
    {
        {
            [_scroll setHeaderLoading:msg.sending];
        }
        
        if ( msg.succeed )
        {
            [self presentMessageTips:@"更新个人资料成功"];
            [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_compile") image:[UIImage imageNamed:@"nav-right.png"]];
            self.isEditing = NO;
            [user release];
            user = nil;
            user = [[UserModel sharedInstance].user retain];
            [_scroll reloadData];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[formatter dateFromString:user.birthday];
            
            _datepicker.date = date;

        }
    }
}

-(void)_resetData
{
//    [_valuearray removeAllObjects];
//    [_valuearray addObject:[UserModel sharedInstance].user.vip_number];
//    [_valuearray addObject:[UserModel sharedInstance].user.name];
//    [_valuearray addObject:[UserModel sharedInstance].user.user_name];
//    [_valuearray addObject:[UserModel sharedInstance].user.birthday];
//    [_valuearray addObject:[UserModel sharedInstance].user.sex];
//    [_valuearray addObject:[UserModel sharedInstance].user.email];
//    privilegesize = [[UserModel sharedInstance].user.privilege sizeWithFont:[UIFont systemFontOfSize:18] byWidth:280];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)onClickBirthday:(id)sender
{
    [_datepicker setHidden:NO];
    [_confirm setHidden:NO];
}

-(void)onClickConfirm:(id)sender
{
    [_datepicker setHidden:YES];
    [_confirm setHidden:YES];
    user.birthday = [NSString stringWithFormat:@"%04d-%02d-%02d",[_datepicker.date year],[_datepicker.date month],[_datepicker.date day]];
    [_scroll reloadData];
    
}
@end
