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
//  QiuchangOrderResultBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderResultBoard_iPhone.h"
#import "QiuchangOrderCellViewController.h"
#import "UserModel.h"
#import "ServerConfig.h"
#import "AppBoard_iPhone.h"
#import "QuichangDetailBoard_iPhone.h"
#import "SirendingzhiDetailBoard_iPhone.h"

#pragma mark -

@interface QiuchangOrderResultBoard_iPhone() <QiuchangOrderCell_iPhoneDelegate,UIActionSheetDelegate>
{
	QiuchangOrderCell_iPhone* _cell;
    BOOL _popedInfoBox;
    BeeUIScrollView *	_scroll;
    BeeUICell* _containerCell;
}
@end

@implementation QiuchangOrderResultBoard_iPhone

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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"预订结果"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        _cell = [[QiuchangOrderCell_iPhone cell] retain];
        [self _manuData];
        _cell.data = _dataDict;
        _cell.delegate = self;
        QiuchangOrderCell_iPhoneLayout* lo = [QiuchangOrderCell_iPhoneLayout layoutWithDict:self.dataDict];
        [_cell setCellLayout:lo];
        
        CGRect rect = _cell.frame;
        rect.size.height += 80 + self.backToHomeButton.frame.size.height;
        _containerCell = [[BeeUICell cell] retain];
        _containerCell.backgroundColor = [UIColor clearColor];
        _containerCell.frame = rect;
        
        ////
        rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [_cell release];
        [_containerCell release];
        SAFE_RELEASE_SUBVIEW( _scroll );
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
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll.frame =rect;
        
        rect = _cell.frame;
        rect.origin.y = 0;
        _cell.frame = rect;
        [self.backToHomeButton setBackgroundImage:[__IMAGE(@"searcher_new_btn_green") stretched] forState:UIControlStateNormal];
        
        [_containerCell addSubview:_cell];
        
        rect = self.backToHomeButton.frame;
        rect.origin.y = CGRectGetMaxY(_cell.frame) + 40;
        self.backToHomeButton.frame = rect;
        [_containerCell addSubview:self.backToHomeButton];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES animated:NO];
        
        if (!_popedInfoBox && _dataDict)
        {
            _popedInfoBox = YES;
            int status = [_dataDict[@"status"] integerValue];
            switch (status)
            {
                case 0:
                {
                    //"待确认";
                    NSString* tabName = nil;
                    switch (_cell.orderCellType)
                    {
                        case EOrderCellTypeCourse:
                            tabName = @"球场";
                            break;
                        case EOrderCellTypeTaocan:
                            tabName = @"套餐";
                            break;
                            
                        default:
                            break;
                    }
                    NSString* msg = [NSString stringWithFormat:@"我们将尽快确认您的预订请求，并尽快通知您，您可以在\"我的爱高\"->\"历史订场\"里 【%@】 页中查看订单状态",tabName];
                    BeeUIAlertView * alert = [BeeUIAlertView spawn];
                    alert.title = @"您的订单已收到，等待服务商确认";
                    alert.message = msg;
                    [alert addCancelTitle:@"确定"];
                    [alert showInViewController:self];
                }
                    break;
                case 1:
                {
                    //"待付款";
                    BeeUIAlertView * alert = [BeeUIAlertView spawn];
                    alert.title = @"订单已收到，您可以直接付款以完成预订";
                    [alert addCancelTitle:@"确定"];
                    [alert showInViewController:self];
                }
                    break;
                case 2:
                {
                    //"完成预订";
                    BeeUIAlertView * alert = [BeeUIAlertView spawn];
                    if ([self.dataDict[@"type"] intValue] == 1)
                    {
                        //球场订单
                        alert.title = @"恭喜您成功预订，于预订时间到球场付款打球即可";
                    }
                    else if ([self.dataDict[@"type"] intValue] == 2)
                    {
                        //套餐订单
                        alert.title = @"恭喜您成功预订，我们将尽快通知您后续的安排";
                    }
                    
                    [alert addCancelTitle:@"确定"];
                    [alert showInViewController:self];
                }
                    break;
                default:
                {
                    
                }
                    break;
            }
        }
        
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
        BeeUIBoard* destBoard = nil;
        for (BeeUIBoard* board in [self.stack boards])
        {
            if ([board isKindOfClass:[QuichangDetailBoard_iPhone class]]
                || [board isKindOfClass:[SirendingzhiDetailBoard_iPhone class]])
            {
                destBoard = board;
                break;
            }
        }
        if (destBoard)
        {
            [self.stack popToBoard:destBoard animated:YES];
        }
        else
        {
            [self.stack popBoardAnimated:YES];
        }
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

#pragma mark -

- (IBAction)pressedBackToHome:(id)sender
{
    [self.stack popToRootViewControllerAnimated:YES];
}

#pragma mark -

-(void)setDataDict:(NSMutableDictionary *)dataDict
{
    [dataDict retain];
    [_dataDict release];
    _dataDict = [dataDict retain];
    _cell.data = dataDict;
}

- (void)_manuData
{
    if (self.dataDict)
    {
        NSDictionary* dict = @{};
        if ([self.dataDict[@"type"] intValue] == 1)
        {
            //球场订单
            dict = @{
                     @"id": self.dataDict[@"id"],
                     @"order_sn": self.dataDict[@"order_sn"],
                     @"courseid": self.dataDict[@"courseid"],
                     @"coursename": self.dataDict[@"coursename"],
                     @"createtime": [self.dataDict[@"createtime"] stringValue],
                     @"playtime": self.dataDict[@"playtime"],
                     @"status": [self.dataDict[@"status"] stringValue],
                     @"description": self.dataDict[@"description"],
                     @"players": self.dataDict[@"players"],
                     @"tel": [self.dataDict[@"tel"] stringValue],
                     @"price": @{
                             @"courseid": self.dataDict[@"courseid"],
                             @"caddie": @NO,
                             @"holecount": @0,
                             @"green": @NO,
                             @"cabinet": @NO,
                             @"car": @YES,
                             @"insurance": @NO,
                             @"meal": @NO,
                             @"tips": @NO,
                             @"deposit": @0,
                             @"distributorname": self.priceDict[@"distributorname"],
                             @"distributortype": @"1",
                             @"payway": @"3",
                             @"price": self.dataDict[@"price"],
                             @"teetimeprice": @[ ],
                             @"date": @"",
                             },
                     @"type": [self.dataDict[@"type"] stringValue]
                     };
        }
        else if ([self.dataDict[@"type"] intValue] == 2)
        {
            //套餐订单
            dict = @{
                     @"id": self.dataDict[@"id"],
                     @"order_sn": self.dataDict[@"order_sn"],
                     @"courseid": self.dataDict[@"courseid"],
                     @"coursename": self.dataDict[@"coursename"],
                     @"createtime": [self.dataDict[@"createtime"] stringValue],
                     @"playtime": self.dataDict[@"playtime"],
                     @"status": [self.dataDict[@"status"] stringValue],
                     @"description": self.dataDict[@"description"],
                     @"players": self.dataDict[@"players"],
                     @"tel": [self.dataDict[@"tel"] stringValue],
                     @"price": self.dataDict[@"price"],
                     @"type": [self.dataDict[@"type"] stringValue]
                     };
        }
        self.dataDict = [[NSMutableDictionary dictionaryWithDictionary:dict] retain];
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    return _containerCell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return _containerCell.frame.size;
}


#pragma mark - Network

- (void)requestCancelCourse:(NSString*)orderId
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"order_id":orderId
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/cancel"])
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
        if ([[req.url absoluteString] rangeOfString:@"courseorder/cancel"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //取消订单
                self.dataDict[@"status"] = @6;
                [self presentMessageTips:@"取消成功"];
                _cell.data = self.dataDict;
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}


#pragma mark <QiuchangOrderCell_iPhoneDelegate>

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                 onPressedCancel:(NSDictionary*)data
{
    [self requestCancelCourse:data[@"id"]];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                  onPressedShare:(NSDictionary*)data
{
    [cell shareOrder:data];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
                    onPressedPay:(NSDictionary*)data
{
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付", nil];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
               onPressedQiuchang:(NSDictionary*)data
{
    
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            //支付宝支付
            NSLog(@"支付宝支付");
        }
            break;
            
        default:
            break;
    }
}


- (void)dealloc {
    [_backToHomeButton release];
    [super dealloc];
}
@end
