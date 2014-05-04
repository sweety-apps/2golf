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
//  QiuchangOrderEditBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderEditBoard_iPhone.h"
#import "QiuchangOrderEditCellViewController.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "QiuchangOrderResultBoard_iPhone.h"

#pragma mark -

@interface QiuchangOrderEditBoard_iPhone() <QiuchangOrderEditCell_iPhoneDelegate>
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) NSMutableDictionary* dataDict;

@property (nonatomic,assign) NSInteger numPeople;
@property (nonatomic,assign) NSInteger price1;
@property (nonatomic,assign) NSInteger price2;
@property (nonatomic,assign) NSInteger price3;

@end

@implementation QiuchangOrderEditBoard_iPhone

- (void)load
{
	[super load];
    
    self.numPeople = 1;
    self.price1 = 200;
    self.price2 = 1020;
    self.price3 = 200;
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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"开始预订"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect = self.viewBound;
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

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] )
	{
	}
    else if ( [signal is:BeeUIScrollView.DID_DRAG] )
	{
        [self.view endEditing:YES];
	}
}

- (void)setUpData:(NSDictionary *)dataDict
{
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [self resetData];
}

#pragma mark -

- (void)resetData
{
    self.cellArray = nil;
    self.cellArray = [NSMutableArray array];
    
    NSString* str = nil;
    
    QiuchangOrderEditCell_iPhone* cell = nil;
    
    // 1
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalH];
    [cell setLeftText:@"服务商"];
    [cell setRightText:(self.dataDict[@"price"])[@"distributorname"] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"球场"];
    [cell setRightText:self.dataDict[@"coursename"] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (date == nil)
    {
        date = [NSDate date];
    }
    str = [NSString stringWithFormat:@"%d年%d月%d日\n%@",[date year],[date month],[date day],[date weekdayChinese]];
    if ([str length] == 0)
    {
        str = @"2014年02月21日\n星期五";
    }
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"日期"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    
    //时间
    date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    if (date == nil)
    {
        date = [NSDate date];
    }
    str = [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
    if ([str length] == 0)
    {
        str = @"08:30";
    }
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalB];
    [cell setLeftText:@"时间"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //2
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setContact];
    [cell setLeftText:@"姓名"];
    [cell setRightText:self.dataDict[@"players"] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPhoneNum];
    [cell setLeftText:@"电话"];
    //[cell setRightText:self.dataDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    str = [NSString stringWithFormat:@"%d",self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPeopleNum];
    [cell setLeftText:@"打球人数"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //3
    str = [NSString stringWithFormat:@"￥%d",self.price1*self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalH];
    [cell setLeftText:@"押金"];
    [cell setRightText:str color:[UIColor redColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    str = [NSString stringWithFormat:@"￥%d",self.price2*self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"球场现付"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    str = [NSString stringWithFormat:@"￥%d",self.price3*self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"订单总价"];
    [cell setRightText:str color:[UIColor redColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"说明"];
    [cell setRightText:self.dataDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setConfirm];
    [cell setLeftText:@"打球人数"];
    [cell setRightText:self.dataDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    
    [_scroll reloadData];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.cellArray)
    {
        row = [self.cellArray count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    return self.cellArray[index];
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    BeeUICell* cell = self.cellArray[index];
	return cell.frame.size;
}

#pragma mark - <QiuchangOrderEditCell_iPhoneDelegate>

- (void)onPressedContact:(QiuchangOrderEditCell_iPhone*)cell
{
    
}

- (void)onPressedConfirm:(QiuchangOrderEditCell_iPhone*)cell
{
    QiuchangOrderResultBoard_iPhone* board = [QiuchangOrderResultBoard_iPhone boardWithNibName:@"QiuchangOrderResultBoard_iPhone"];
    [self.stack pushBoard:board animated:YES];
}

- (void)onPressedIncreasePeople:(QiuchangOrderEditCell_iPhone*)cell
{
    NSInteger num = self.numPeople;
    num++;
    self.numPeople = num;
    [self resetData];
}

- (void)onPressedDecreasePeople:(QiuchangOrderEditCell_iPhone*)cell
{
    NSInteger num = self.numPeople;
    if (num <= 1)
    {
        num = 2;
    }
    num--;
    self.numPeople = num;
    [self resetData];
}

#pragma mark - Network


- (void)fetchData
{
    self.HTTP_GET([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/generate"]).TIMEOUT(30);
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
        if ([[req.url absoluteString] rangeOfString:@"courseorder/generate"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self setUpData:self.dataDict];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}


@end