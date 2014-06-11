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

#pragma mark -

@interface QiuchangOrderResultBoard_iPhone() <QiuchangOrderCell_iPhoneDelegate>
{
	QiuchangOrderCell_iPhone* _cell;
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
        
        _cell = [QiuchangOrderCell_iPhone cell];
        [self _manuData];
        _cell.data = _dataDict;
        _cell.delegate = self;
        [self.view addSubview:_cell];
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
        CGRect rect = _cell.frame;
        rect.origin.y = 6;
        _cell.frame = rect;
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
                             @"distributorname": @"",
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
    
}

- (void)QiuchangOrderCell_iPhone:(QiuchangOrderCell_iPhone*)cell
               onPressedQiuchang:(NSDictionary*)data
{
    
}

@end
