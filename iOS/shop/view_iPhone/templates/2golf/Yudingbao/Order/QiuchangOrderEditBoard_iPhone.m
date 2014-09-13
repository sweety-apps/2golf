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
#import "ContactListBoard_iPhone.h"
#import "CommonSharedData.h"
#import "CommonUtility.h"
#import "UserModel.h"
#import "QiuChangOrderDetailBoard_iPhone.h"

#pragma mark -

@interface QiuchangOrderEditBoard_iPhone() <QiuchangOrderEditCell_iPhoneDelegate,UITextFieldDelegate>
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) NSMutableArray* cellDataArray;
@property (nonatomic,retain) NSMutableDictionary* courseDict;
@property (nonatomic,retain) NSMutableDictionary* priceDict;
@property (nonatomic,retain) UITextField* phoneTextField;
@property (nonatomic,retain) UITextField* descriptionTextField; //备注

@property (nonatomic,assign) double numPeople;
@property (nonatomic,assign) double price1;
@property (nonatomic,assign) double price2;
@property (nonatomic,assign) double price3;
@property (nonatomic,assign) double priceAll;

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
    self.courseDict = nil;
    self.priceDict = nil;
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
        [self _buildCellData];
        [_scroll reloadData];
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

ON_SIGNAL( signal )
{
    if ( [signal is:@"exceed_alert_dail"] )
    {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008229222"]];//打电话
    }
}

- (void)setUpCourseData:(NSDictionary*)courseDict
{
    self.courseDict = [NSMutableDictionary dictionaryWithDictionary:courseDict];
//    [self resetCell];
}

- (void)setUpPriceData:(NSDictionary *)priceDict
{
    self.priceDict = [NSMutableDictionary dictionaryWithDictionary:priceDict];
//    [self resetCell];
}

#pragma mark -

- (void)resetData
{
    if (self.priceDict==nil || self.courseDict == nil)
    {
        return;
    }
    
    [self _buildCellData];
    [_scroll reloadData];
}

- (void)resetCell
{
    if (self.priceDict==nil || self.courseDict == nil)
    {
        return;
    }
    self.cellArray = nil;
    self.cellArray = [NSMutableArray array];
    
    NSString* str = nil;
    int pcount = 0;
    
    QiuchangOrderEditCell_iPhone* cell = nil;
    
    self.priceAll = [self.priceDict[@"price"] doubleValue]*self.numPeople;
    
    // 1
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalH];
    [cell setLeftText:@"服务商"];
    [cell setRightText:self.priceDict[@"distributorname"] color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"球场"];
    [cell setRightText:self.courseDict[@"coursename"] color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
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
//    [self.cellArray addObject:cell];
    
    
    //时间
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    str = [NSString stringWithFormat:@"%02d:%02d",[time hour],[time minute]];
    if ([str length] == 0)
    {
        str = @"08:30";
    }

    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalB];
    [cell setLeftText:@"时间"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    //2
    str = [[CommonSharedData sharedInstance] getContactListNamesString];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setContact];
    [cell setLeftText:@"姓名"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.ctrl.contactBtn.hidden = NO;
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPhoneNum];
    self.phoneTextField = cell.ctrl.phoneTextField;
    self.phoneTextField.text = [[CommonSharedData sharedInstance] getContactPhoneNum];
    self.phoneTextField.delegate = self;
    [cell setLeftText:@"电话"];
    //[cell setRightText:self.dataDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    //5
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"备注"];
    cell.ctrl.normalRightTitle.hidden = YES;
    cell.ctrl.phoneTextField.hidden = NO;
    cell.ctrl.phoneTextField.keyboardType = UIKeyboardTypeDefault;
    cell.ctrl.phoneTextField.placeholder = @"请输入备注说明";
    cell.ctrl.phoneTextField.delegate = self;
    self.descriptionTextField = cell.ctrl.phoneTextField;
    //self.descriptionTextField.text = self.description;
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    str = [NSString stringWithFormat:@"%d",(int)self.numPeople];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setPeopleNum];
    [cell setLeftText:@"打球人数"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    //3
    if (self.priceDict[@"deposit"] == [NSNull null])
    {
        str = @"0";
    }
    else
    {
        double val = [((NSNumber*)self.priceDict[@"deposit"]) doubleValue] *self.numPeople;
        str = [NSString stringWithFormat:@"￥%@",[NSNumber numberWithDouble:val]];
    }
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalH];
    [cell setLeftText:@"押金"];
    [cell setRightText:str color:[UIColor redColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    str = @"";
    NSDictionary* pdict = @{
                            @"green":@"果岭",
                            @"cabinet":@"衣柜",
                            @"insurance":@"保险",
                            @"car":@"球车",
                            @"meal":@"午餐",
                            @"tips":@"小费",
                            @"caddie":@"球童",
                            };
    pcount = 0;
    for (NSString* key in pdict)
    {
        if ([self.priceDict[key] boolValue])
        {
            if (pcount > 0)
            {
                str = [str stringByAppendingString:@","];
            }
            str = [str stringByAppendingString:pdict[key]];
            pcount++;
        }
    }
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"费用包含"];
    [cell setRightText:str color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    self.priceAll = [self.priceDict[@"price"] doubleValue]*self.numPeople;
    str = [NSString stringWithFormat:@"￥%@",[NSNumber numberWithDouble:self.priceAll]];
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"订单总价"];
    [cell setRightText:str color:[UIColor redColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"说明"];
    [cell setRightText:self.priceDict[@"description"] color:[UIColor blackColor]];
    cell.delegate = self;
    [cell resizeSelfWithRightText];
//    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setNormalM];
    [cell setLeftText:@"退订说明"];
    [cell setRightText:self.priceDict[@"cancel_desc"] color:[UIColor blackColor]];
    [cell resizeSelfWithRightText];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    cell = [QiuchangOrderEditCell_iPhone cell];
    [cell setConfirm];
    [cell setLeftText:@"打球人数"];
    [cell setRightText:self.priceDict[@""] color:[UIColor blackColor]];
    cell.delegate = self;
//    [self.cellArray addObject:cell];
    
    [_scroll reloadData];
}

-(void)_buildCellData
{
    self.cellDataArray = nil;
    self.cellDataArray = [NSMutableArray array];
    NSString* lefttext = @"服务商";
    NSString* righttext = self.priceDict[@"distributorname"];
    if (righttext == nil  || righttext.length == 0) {
        righttext = @"球会官方提供";
    }
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeTop],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"球场";
    righttext = self.courseDict[@"coursename"];
    //section0
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    righttext = [NSString stringWithFormat:@"%d月%d日 %@",[date month],[date day],[date weekdayChinese]];
    if ([righttext length] == 0)
    {
        righttext = @"02月21日 星期五";
    }
    lefttext = @"日期";
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    righttext = [NSString stringWithFormat:@"%02d:%02d",[time hour],[time minute]];
    if ([righttext length] == 0)
    {
        righttext = @"08:30";
    }
    
    lefttext = @"时间";
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeBottom],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    
    //section1
    lefttext = @"姓名";
    righttext = [[CommonSharedData sharedInstance] getContactListNamesString];
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellContact],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeTop],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"电话";
    righttext = [[CommonSharedData sharedInstance] getContactPhoneNum];
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellPhoneNum],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"打球人数";
    righttext = [NSString stringWithFormat:@"%d",(int)self.numPeople];
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellPeopleNum],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeBottom],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    //section2
    switch ([self.priceDict[@"payway"] intValue]) {
		case 3:// 全额预付
            lefttext = @"在线预付";
            righttext = [NSString stringWithFormat:@"¥%d",[((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] * (int)self.numPeople];
			break;
		case 4:// 部分现付
            lefttext = @"在线预付";
            righttext = [NSString stringWithFormat:@"¥%d",[self.priceDict[@"deposit"] intValue] * (int)self.numPeople];
			break;
		case 2:// 全额现付
            lefttext = @"押金";
            righttext = [NSString stringWithFormat:@"¥%d",[self.priceDict[@"deposit"] intValue] * (int)self.numPeople];
			break;
		default:
			break;
    }
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeTop],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"球场现付";
    switch ([self.priceDict[@"payway"] intValue]) {
		case 3:// 全额预付
            righttext = [NSString stringWithFormat:@"¥%d",0 * (int)self.numPeople];
			break;
		case 4:// 部分现付
            righttext = [NSString stringWithFormat:@"¥%d",([((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] - [self.priceDict[@"deposit"] intValue]) * (int)self.numPeople];
			break;
		case 2:// 全额现付
            righttext = [NSString stringWithFormat:@"¥%d",[((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] * (int)self.numPeople];
			break;
		default:
			break;
    }
    
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor redColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"订单总额";
    switch ([self.priceDict[@"payway"] intValue]) {
		case 3:// 全额预付
            righttext = [NSString stringWithFormat:@"¥%d",[((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] * (int)self.numPeople];
			break;
		case 4:// 部分现付
            righttext = [NSString stringWithFormat:@"¥%d",[((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] * (int)self.numPeople];
			break;
		case 2:// 全额现付
            righttext = [NSString stringWithFormat:@"¥%d",[((self.priceDict[@"teetimeprice"] == nil || ![self.priceDict[@"teetimeprice"]  isKindOfClass:[NSDictionary class]])?self.priceDict[@"price"]:self.priceDict[@"teetimeprice"][@"price"]) intValue] * (int)self.numPeople];
			break;
		default:
			break;
    }
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor redColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    lefttext = @"说明";
    righttext = [NSString stringWithFormat:@"%@\n%@",self.priceDict[@"description"],self.priceDict[@"cancel_desc"]];
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:lefttext,righttext,[NSNumber numberWithInt:QiuchangOrderEditCellNormal],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeMiddle],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
    
    [self.cellDataArray addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"",@"",[NSNumber numberWithInt:QiuchangOrderEditCellConfirm],[NSNumber numberWithInt:QiuchangOrderEditCellBkgTypeBottom],[UIColor blackColor],nil] forKeys:[NSArray arrayWithObjects:@"left",@"right",@"celltype",@"cellbkgtype",@"rightcolor",nil]]];
}

-(double)getRealMoney
{
    double ret = 0.0;
    
    return ret;
}
#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.cellDataArray)
    {
        row = [self.cellDataArray count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
//    return self.cellArray[index];
    QiuchangOrderEditCell_iPhone* cell = [scrollView dequeueWithContentClass:[QiuchangOrderEditCell_iPhone class]];
    cell.delegate = self;
    cell.data = [self.cellDataArray objectAtIndex:index];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = [QiuchangOrderEditCell_iPhone estimateUISizeByWidth:self.view.width forData:[self.cellDataArray objectAtIndex:index]];
    return size;
//    BeeUICell* cell = self.cellArray[index];
//	return cell.frame.size;
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
    
    if ([[[CommonSharedData sharedInstance] getContactListNamesString] length] <= 0)
    {
        [self presentFailureTips:@"请填写打球人姓名"];
        return;
    }
    
    if ([[[CommonSharedData sharedInstance] getContactPhoneNum] length] <= 0)
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
    if (num > 12)
    {
        BeeUIAlertView * alert = [BeeUIAlertView spawn];
        alert.title = @"打球人数最多不能超过12人";
        alert.message = @"打球人数超过12人可以享受团队优惠价，请拨打爱高服务热线人工预订。";
        [alert addCancelTitle:@"取消"];
        [alert addButtonTitle:@"拨打热线" signal:@"exceed_alert_dail"];
        [alert showInViewController:self];
    }
    else
    {
        self.numPeople = num;
        [self resetData];
    }
    
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

- (void)showOrderResult:(NSDictionary*)resultDict
{
//    QiuchangOrderResultBoard_iPhone* board = [QiuchangOrderResultBoard_iPhone boardWithNibName:@"QiuchangOrderResultBoard_iPhone"];
////    board.priceDict = [NSMutableDictionary dictionaryWithDictionary:self.priceDict];
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
                                @"tel":[[CommonSharedData sharedInstance] getContactPhoneNum],
                                @"price":[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:self.priceAll]],
                                @"id":self.courseDict[@"course_id"],
                                @"type":@"1",
                                @"agentid":self.priceDict[@"distributorid"],
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat i_textFieldY = [textField convertRect:textField.frame toView:_scroll].origin.y;
    i_textFieldY -= 80;
    if (i_textFieldY < 0)
    {
        i_textFieldY = 0;
    }
    [_scroll setContentOffset:CGPointMake(0, i_textFieldY) animated:YES];
}

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
