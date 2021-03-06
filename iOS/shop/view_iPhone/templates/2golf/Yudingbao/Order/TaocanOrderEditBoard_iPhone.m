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
//  TaocanOrderEditBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-6-9.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "TaocanOrderEditBoard_iPhone.h"
#import "QiuchangOrderEditCellViewController.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "QiuchangOrderResultBoard_iPhone.h"
#import "ContactListBoard_iPhone.h"
#import "CommonSharedData.h"
#import "CommonUtility.h"
#import "UserModel.h"
#import "QiuChangOrderDetailBoard_iPhone.h"
#define kCellTagUserDescription (5)

#pragma mark -

@interface TaocanOrderEditBoard_iPhone() <QiuchangOrderEditCell_iPhoneDelegate,UITextFieldDelegate>
{
	BeeUIScrollView *	_scroll;
}
@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) UITextField* phoneTextField;
@property (nonatomic,retain) UITextField* descriptionTextField;
@property (nonatomic,retain) NSString* description;

@property (nonatomic,assign) double numPeople;
@property (nonatomic,assign) double price1;
@property (nonatomic,assign) double price2;
@property (nonatomic,assign) double price3;
@property (nonatomic,assign) double priceAll;

@end

@implementation TaocanOrderEditBoard_iPhone

- (void)load
{
	[super load];
    
    self.description = nil;
    self.numPeople = 1;
    self.price1 = 200;
    self.price2 = 1020;
    self.price3 = 200;
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
        
        [self resetData];
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

#pragma mark -

- (void)resetData
{
    if (self.dataDict==nil)
    {
        return;
    }
    self.cellArray = nil;
    self.cellArray = [NSMutableArray array];
    
    NSString* str = nil;
    int pcount = 0;
    
    QiuchangOrderEditCell_iPhone* cell = nil;
    
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (date == nil)
    {
        date = [NSDate dateWithTimeIntervalSinceNow:3600*24 + 3600];//明天1小时以后
    }
    str = [NSString stringWithFormat:@"%d年%d月%d日\n%@",[date year],[date month],[date day],[date weekdayChinese]];
    if ([str length] == 0)
    {
        str = @"2014年02月21日\n星期五";
    }
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalH];
    [cell setLeftText:@"日期"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //2
    str = [[CommonSharedData sharedInstance] getContactListNamesString];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setContactM];
    [cell setLeftText:@"姓名"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.ctrl.contactBtn.hidden = NO;
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //3
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPhoneNum];
    self.phoneTextField = cell.ctrl.phoneTextField;
    self.phoneTextField.text = [[CommonSharedData sharedInstance] getContactPhoneNum];
    self.phoneTextField.delegate = self;
    [cell setLeftText:@"电话"];
    //[cell setRightText:self.dataDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //4
    str = [NSString stringWithFormat:@"%d",(int)self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPeopleNumM];
    [cell setLeftText:@"打球人数"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    //5
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"备注"];
    cell.ctrl.normalRightTitle.hidden = YES;
    cell.ctrl.phoneTextField.hidden = NO;
    cell.ctrl.phoneTextField.keyboardType = UIKeyboardTypeDefault;
    cell.ctrl.phoneTextField.placeholder = @"请输入备注说明";
    self.descriptionTextField = cell.ctrl.phoneTextField;
    self.descriptionTextField.text = self.description;
    cell.tag = kCellTagUserDescription;
    cell.delegate = self;
    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setConfirm];
    [cell setLeftText:@""];
    [cell setRightText:@"" color:[UIColor blackColor]];
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
    ContactListBoard_iPhone* board = [ContactListBoard_iPhone boardWithNibName:@"ContactListBoard_iPhone"];
    [self.stack pushBoard:board animated:YES];
}

- (void)onPressedConfirm:(QiuchangOrderEditCell_iPhone*)cell
{
    if (![CommonUtility checkLoginAndPresentLoginView])
    {
        return;
    }
    
    if ([[[CommonSharedData sharedInstance] getContactListNamesString] length] <=0)
    {
        [self presentFailureTips:@"请输入打球人姓名"];
        return;
    }
    
    if ([self.phoneTextField.text length] <= 0)
    {
        [self presentFailureTips:@"请填写联系电话"];
        return;
    }
    
    [self generateOrder];
}


- (void)onPressedIncreasePeople:(QiuchangOrderEditCell_iPhone*)cell
{
    NSInteger num = self.numPeople;
    num++;
    self.numPeople = num;
    self.description = self.descriptionTextField.text;
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
    self.description = self.descriptionTextField.text;
    [self resetData];
}

#pragma mark - Network

- (void)showOrderResult:(NSDictionary*)resultDict
{
//    QiuchangOrderResultBoard_iPhone* board = [QiuchangOrderResultBoard_iPhone boardWithNibName:@"QiuchangOrderResultBoard_iPhone"];
//    board.dataDict = [NSMutableDictionary dictionaryWithDictionary:resultDict];
//    [self.stack pushBoard:board animated:YES];
    
    QiuChangOrderDetailBoard_iPhone * board = [QiuChangOrderDetailBoard_iPhone board];
    board.order = [NSMutableDictionary dictionaryWithDictionary:resultDict];
    board.isResult = YES;
    [self.stack pushBoard:board animated:NO];
}

- (void)generateOrder
{
    [self presentProgressTips:@"正在生成订单"];
    NSString* desStr = self.descriptionTextField.text;
    if (desStr == nil)
    {
        desStr = @"";
    }
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary,
                                @"players":[NSString stringWithFormat:@"%d",(int)self.numPeople],
                                @"contacts":[[CommonSharedData sharedInstance] getContactListNamesString],
                                @"tel":self.phoneTextField.text,
                                @"price":[NSString stringWithFormat:@"%@",[ NSNumber numberWithDouble:self.priceAll]],
                                @"id":self.dataDict[@"id"],
                                @"type":@"2",
                                @"agentid":self.dataDict[@"distributorid"],
                                @"timestamp":[NSString stringWithFormat:@"%ld",[CommonUtility getSearchTimeStamp]],
                                @"postscript":desStr
                                };
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"courseorder/generate"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    return [super commonCheckRequest:req];
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
                //self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                //[self setUpData:self.dataDict];
                [self showOrderResult:[NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])]];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:dict[@"status"][@"error_desc"]];
            }
        }
    }
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[CommonSharedData sharedInstance] setContactPhoneNum:self.phoneTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
