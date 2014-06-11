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
//  MyOrderListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "MyOrderListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "QiuchangOrderCellViewController.h"
#import "UserModel.h"
#import "ServerConfig.h"
#import "MyOrderListTopSwitchViewController.h"

#pragma mark -

@interface MyOrderListBoard_iPhone() <QiuchangOrderCell_iPhoneDelegate>
{
	BeeUIScrollView* _scroll;
}

@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableArray* courseArray;
@property (nonatomic,retain) NSMutableArray* taocanArray;
@property (nonatomic,retain) NSArray* currentArray;
@property (nonatomic,assign) BOOL isTaocan;
@property (nonatomic,retain) MyOrderListTopSwitchViewController* switchCtrl;

@end

@implementation MyOrderListBoard_iPhone

- (void)load
{
	[super load];
    self.switchCtrl = [[MyOrderListTopSwitchViewController alloc] initWithNibName:@"MyOrderListTopSwitchViewController" bundle:nil];
}

- (void)unload
{
    self.dataDict = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场列表"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self setTitleView:self.switchCtrl.view];
        
        [self.switchCtrl selectButtonCourse];
        self.isTaocan = NO;
        [self.switchCtrl.buttonCourse addTarget:self action:@selector(_selectCourse) forControlEvents:UIControlEventTouchUpInside];
        [self.switchCtrl.buttonTaocan addTarget:self action:@selector(_selectTaocan) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect rect;
        
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
        
        [self fetchData];
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

- (void)resetCells
{
    [self devideDatas];
    if (!self.isTaocan)
    {
        self.currentArray = self.courseArray;
    }
    else
    {
        self.currentArray = self.taocanArray;
    }
    [_scroll reloadData];
}

- (void)devideDatas
{
    self.courseArray = [NSMutableArray array];
    self.taocanArray = [NSMutableArray array];
    for (NSDictionary* dict in self.dataDict[@"order"])
    {
        if ([dict[@"type"] intValue] == 1)
        {
            [self.courseArray addObject:dict];
        }
        else if ([dict[@"type"] intValue] == 2)
        {
            [self.taocanArray addObject:dict];
        }
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.currentArray)
    {
        row = [self.currentArray count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	QiuchangOrderCell_iPhone* cell = [scrollView dequeueWithContentClass:[QiuchangOrderCell_iPhone class]];
    
    cell.tag = index;
    cell.delegate = self;
    cell.data = self.currentArray[index];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    return [QiuchangOrderCell_iPhone getCellSize];
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary
                                };
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/list"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

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
        [_scroll setHeaderLoading:NO];
        [self dismissTips];
        [self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
        [_scroll setHeaderLoading:NO];
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
        if ([[req.url absoluteString] rangeOfString:@"courseorder/list"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //拉订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
        else if ([[req.url absoluteString] rangeOfString:@"courseorder/cancel"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //取消订单
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self presentMessageTips:@"取消成功"];
                [self fetchData];
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

#pragma mark -

- (void)_selectCourse
{
    [self.switchCtrl selectButtonCourse];
    self.isTaocan = NO;
    [self fetchData];
}

- (void)_selectTaocan
{
    [self.switchCtrl selectButtonTaocan];
    self.isTaocan = YES;
    [self fetchData];
}

@end
