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
//  QiuchangDetailBottomBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangDetailBottomBoard_iPhone.h"
#import "MyOrderListBoard_iPhone.h"
#import "CommonUtility.h"

#pragma mark -

@interface QiuchangDetailBottomCell_iPhone ()

@property (nonatomic,retain) QiuchangDetailBottomBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation QiuchangDetailBottomCell_iPhone

DEF_SIGNAL(DAIL_PHONE_OK)

- (void)load
{
    [super load];
    
    self.ctrl = [QiuchangDetailBottomBoard_iPhone boardWithNibName:@"QiuchangDetailBottomBoard_iPhone"];
    self.frame = self.ctrl.view.frame;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
}

- (void)unload
{
    self.ctrl = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSDictionary* dict = self.data;
        [self.ctrl.phoneBtn addTarget:self action:@selector(_pressedPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.ctrl.mylistBtn addTarget:self action:@selector(_pressedMyOrderListBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

#pragma mark

- (void)_pressedPhoneBtn:(UIButton*)btn
{
    BeeUIAlertView * alert = [BeeUIAlertView spawn];
    //			alert.title = @"提交订单成功";
    alert.message = @"拨打电话?";
    [alert addCancelTitle:@"取消"];
    [alert addButtonTitle:@"拨打" signal:self.DAIL_PHONE_OK];
    alert.anotherSignalView = self;
    [alert show];
}

- (void)_pressedMyOrderListBtn:(UIButton*)btn
{
    if (![CommonUtility checkLoginAndPresentLoginView])
    {
        return;
    }
    
    MyOrderListBoard_iPhone* board = [MyOrderListBoard_iPhone boardWithNibName:@"MyOrderListBoard_iPhone"];
    
    [[[self superview] superview].board.stack pushBoard:board animated:YES];
}

ON_SIGNAL( signal)
{
    if ([signal is:self.DAIL_PHONE_OK])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008229222"]];//打电话
    }
}

@end


#pragma mark -

@interface QiuchangDetailBottomBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation QiuchangDetailBottomBoard_iPhone

@synthesize phoneBtn;
@synthesize mylistBtn;

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
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

@end
