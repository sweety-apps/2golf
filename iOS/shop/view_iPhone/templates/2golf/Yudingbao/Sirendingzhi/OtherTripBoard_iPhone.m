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
//  OtherTripBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-8.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "OtherTripBoard_iPhone.h"
#import "ServerConfig.h"
#import "CommonUtility.h"
#import "UserModel.h"

#pragma mark -

@interface OtherTripBoard_iPhone() <UIScrollViewDelegate>
{
    
    int i_offset;    //偏移量
    int i_textFieldY;          //textField 的y 值
    int i_textFieldHeight;    //textField的高度
}
@end

@implementation OtherTripBoard_iPhone

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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"私人订制"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        i_offset = 0;    //默认偏移量为0
        i_textFieldY = 0;
        i_textFieldHeight = 0;
        
        //注册键盘监听消息
        [self registerKeyBoardNotification];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        self.customerName.delegate = self;
        self.personNum.delegate = self;
        self.destination.delegate = self;
        self.goDate.delegate = self;
        self.backDate.delegate = self;
        self.hotelStars.delegate = self;
        self.hotelRoomModel.delegate = self;
        self.hotelRoomNum.delegate = self;
        self.qiuchangName.delegate = self;
        self.otherNeeds.delegate = self;
        self.email.delegate = self;
        self.phoneNum.delegate = self;
        
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(320, 800);
        
        self.scrollView.delegate = self;
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

#pragma mark Event

- (IBAction)onPressedSend:(id)sender
{
    if (![CommonUtility checkLoginAndPresentLoginView])
    {
        return;
    }
    
    NSArray* textFeilds = @[
                            self.customerName,
                            self.personNum,
                            self.destination,
                            self.goDate,
                            self.backDate,
                            self.hotelStars,
                            self.hotelRoomModel,
                            self.hotelRoomNum,
                            self.qiuchangName,
                            self.otherNeeds,
                            self.email,
                            self.phoneNum
                            ];
    
    for (UITextField* tf in textFeilds)
    {
        if ([tf.text length] == 0)
        {
            [[[UIApplication sharedApplication] keyWindow] presentFailureTips:@"请完整填写后再提交"];
            return;
        }
    }
    
    [self fetchData];
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"name":self.customerName.text,
                                @"num":self.personNum.text,
                                @"start_date":self.goDate.text,
                                @"end_date":self.backDate.text,
                                @"hotel_type":self.hotelRoomModel.text,
                                @"hotel_level":self.hotelStars.text,
                                @"hotel_num":self.hotelRoomNum.text,
                                @"course_name":self.qiuchangName.text,
                                @"use_car":[NSNumber numberWithBool:self.needCar.on],
                                @"email":self.email.text,
                                @"phone":self.phoneNum.text,
                                @"contact":self.customerName.text,
                                @"need_guide":@0,
                                @"extra":self.otherNeeds.text
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"personalcombo"])
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
        if ([[req.url absoluteString] rangeOfString:@"personalcombo"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                [[BeeUITipsCenter sharedInstance] presentMessageTips:@"行程表格已提交" inView:[[UIApplication sharedApplication] keyWindow]];
                [self.stack popBoardAnimated:YES];
            }
            else
            {
                [self presentFailureTips:(dict[@"status"])[@"error_desc"]];
            }
        }
    }
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
    //获取键盘的高度
    //NSDictionary *userInfo = [aNotification userInfo];
    //NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = CGRectMake(0, 0, 320, 246);
    int keyboardHeight = keyboardRect.size.height;
    
    //计算偏移量
    i_offset = i_textFieldY - 40;//keyboardHeight - (self.view.frame.size.height-(i_textFieldY+i_textFieldHeight));
    
    //进行偏移
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(i_offset > 0)
    {
        CGRect rect = CGRectMake(0.0f,i_offset,width,height); //把整个view 往上提，肯定要用负数 y
        [self.scrollView setContentOffset:rect.origin animated:YES];;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    i_textFieldY = [textField convertRect:textField.frame toView:self.scrollContentView].origin.y;
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

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self resignFirstResponder];
}

@end
