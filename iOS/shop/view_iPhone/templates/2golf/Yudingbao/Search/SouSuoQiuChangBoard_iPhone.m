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
//  SouSuoQiuChangBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-3-29.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SouSuoQiuChangBoard_iPhone.h"
#import "SouSuoQiuChangViewController.h"
#import "TimeSquareBoard_iPhone.h"
#import "CitySelectBoard_iPhone.h"
#import "SearchKeywordsListBoard_iPhone.h"
#import "QiuchangResultListBoard_iPhone.h"
#import "CommonUtility.h"
#import "SouSuoQiuchangBottomViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "ServerConfig.h"

#pragma mark -

@interface SouSuoQiuChangBoard_iPhone() <UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{
    SouSuoQiuChangViewController* _ctrl;
    SouSuoQiuchangBottomViewController* _bottomCtrl;
    UIView* _pickerBg;
    UIPickerView* _picker;
}

@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSMutableArray* courseArray;

@end

@implementation SouSuoQiuChangBoard_iPhone

//SUPPORT_AUTOMATIC_LAYOUT( YES )
//SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[super load];
//    NSDate* date =  [CommonUtility getDateFromZeroPerDay:[NSDate now]];
    NSDate* date = [CommonUtility getDateFromZeroPerDay:[NSDate dateWithTimeIntervalSinceNow:3600*24 ]];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    NSArray* array = [CommonUtility getCanSelectHourMin];
    if (date.istoday) {
        if (array.count == 0) {
            //超出范围,得到当前时间的最近的半个钟
            time = [NSDate dateWithTimeInterval:3600*2 sinceDate:[CommonUtility getNearestHalfTime:[NSDate now]] ];
        }
        else
        {
            time = array[0];
        }
    }
    else
    {
        time = array[5];//9點開始
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"search_time"];
}

- (void)unload
{
    [_ctrl release];
    [_bottomCtrl release];
    [_picker release];
    [_pickerBg release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场搜索"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [CommonUtility refreshLocalPositionWithCallBack:nil];
        
        _bottomCtrl = [[SouSuoQiuchangBottomViewController alloc] initWithNibName:@"SouSuoQiuchangBottomViewController" bundle:nil];
        
        CGRect rect = _bottomCtrl.view.frame;
        CGFloat y = self.scrollContentView.frame.size.height - 36-6 - rect.size.height;
        rect.origin.y = y;
        _bottomCtrl.view.frame = rect;
        [self.scrollContentView addSubview:_bottomCtrl.view];
        
        rect = self.frame;
        rect.origin = CGPointZero;
        
        _pickerBg = [[UIView alloc] initWithFrame:rect];
        _pickerBg.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:_pickerBg];
        [_pickerBg setHidden:YES];
        
        _picker = [[UIPickerView alloc] init];
        _picker.showsSelectionIndicator = YES;
        rect = _picker.frame;
        rect.origin = CGPointZero;
        rect.origin.y = _pickerBg.frame.size.height - rect.size.height;
        _picker.frame = rect;
        _picker.delegate = self;
        _picker.dataSource = self;
        
        
        
        UIView* bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
        bgView.backgroundColor = RGBA(255, 255, 255, 1.0);
        [_pickerBg addSubview:bgView];
        
        
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor clearColor];
        rect.size.height = rect.origin.y;
        rect.origin.x = 0;
        cancelBtn.frame = rect;
        [cancelBtn addTarget:self action:@selector(_onCancelTimeSelect) forControlEvents:UIControlEventTouchUpInside];
        [_pickerBg addSubview:cancelBtn];
        [_pickerBg addSubview:_picker];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"search_keywords"];
        
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
        [self _refreshSelections];
        [self resetCells];
        
        if ([UIApplication sharedApplication].keyWindow.frame.size.height <= 480)
        {
            self.scrollView.frame = CGRectMake(0, 6, 320, 480);
            self.scrollView.contentSize = CGSizeMake(320, 568);
        }
        else
        {
            self.scrollView.frame = CGRectMake(0, 6, 320, 568);
            self.scrollView.contentSize = CGSizeMake(320, 568);
        }
        
        if ([UserModel online])
        {
            [self fetchData];
        }
        
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if ([UIApplication sharedApplication].keyWindow.frame.size.height <= 480)
        {
            //self.scrollView.frame = CGRectMake(0, 6, 320, 480);
            self.scrollView.contentSize = CGSizeMake(320, 598);
        }
        else
        {
            //self.scrollView.frame = CGRectMake(0, 6, 320, 568);
            self.scrollView.contentSize = CGSizeMake(320, 598);
        }
        
        //self.scrollContentView.hidden = YES;
        //self.scrollView.backgroundColor = [UIColor redColor];
        CGRect rect = self.scrollView.frame;
        rect.size = self.viewBound.size;
        self.scrollView.frame = rect;
        self.scrollView.contentSize = CGSizeMake(320, 558);
        self.scrollView.scrollEnabled = YES;
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

#pragma mark - <UIPickerViewDataSource>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[CommonUtility getCanSelectHourMin] count];
}

#pragma mark - <UIPickerViewDelegate>
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDate* date = [CommonUtility getCanSelectHourMin][row];
    return [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDate* date = [CommonUtility getCanSelectHourMin][row];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_time"];
    [self _refreshSelections];
    [_pickerBg setHidden:YES];
}

- (void)_removePickerBgView:(UIView*)bgView
{
    [bgView removeFromSuperview];
}

#pragma mark -

- (void)_refreshSelections
{
    NSString* str = nil;
    //地区
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"] == nil)
    {
        NSDictionary* loc = @{
                              @"is_header":@NO,
                              @"is_city":@NO,
                              @"city_id":@-1,
                              @"province_id":@"current",
                              @"name":@"当前位置",
                              @"first_letter":@"",
                              @"pinyin":@"",
                              @"simple_pin":@"",
                              @"latitude":[NSNumber numberWithDouble:[((AppDelegate*)[UIApplication sharedApplication].delegate) getCurrentLatitude]],
                              @"longitude":[NSNumber numberWithDouble:[((AppDelegate*)[UIApplication sharedApplication].delegate) getCurrentLongitude]],
                              @"course_sum":@0,
                              @"city_expand":@[],
                              @"hasExpand":@NO
                              };
        [[NSUserDefaults standardUserDefaults] setObject:loc forKey:@"search_local"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    str = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"][@"name"];
    if ([str length] == 0)
    {
        str = @"当前位置";
    }
    self.lblLocal.text = str;
    //关键字
    str = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_keywords"];
    if ([str length] == 0)
    {
        str = @"请输入关键字";
    }
    self.lblKeywords.text = str;
    //日期
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_date"];
    if (date == nil)
    {
        date = [CommonUtility getDateFromZeroPerDay:[NSDate now]];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
    }
    str = [NSString stringWithFormat:@"%d月%d日 %@",[date month],[date day],[date weekdayChinese]];
    if ([str length] == 0)
    {
        str = @"02月21日 星期五";
    }
    self.lblDate.text = str;
    //时间
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    BOOL b = time == nil;
    BOOL b1 = (time.year != date.year) ;
    BOOL b2 = (time.month != date.month) ;
    BOOL b3 = (time.day != date.day) ;
    if (b || b1|| b2 || b3) {
        //未選时间或者日期改了的話，就從新設置下
        NSArray* array = [CommonUtility getCanSelectHourMin];
        if (date.istoday) {
            if (array.count == 0) {
                //超出范围,得到当前时间的最近的半个钟
                time = [NSDate dateWithTimeInterval:3600*2 sinceDate:[CommonUtility getNearestHalfTime:[NSDate now]] ];
            }
            else
            {
                time = array[0];
            }
        }
        else
        {
            time = array[5];//9點開始
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"search_time"];
    }
    else
    {
        
    }

    
    str = [NSString stringWithFormat:@"%02d:%02d",[time hour],[time minute]];
    if ([str length] == 0)
    {
        str = @"08:30";
    }
    self.lblTime.text = str;
    [_picker reloadAllComponents];
}

- (void)_onCancelTimeSelect:(UIButton*)btn
{
    [[btn superview] removeFromSuperview];
}

- (IBAction)onPressedLocal:(id)sender
{
    [self.stack pushBoard:[CitySelectBoard_iPhone boardWithNibName:@"CitySelectBoard_iPhone"] animated:YES];
}

- (IBAction)onPressedDate:(id)sender
{
    [self.stack pushBoard:[TimeSquareBoard_iPhone board] animated:YES];
}

- (IBAction)onPressedKeywords:(id)sender
{
    [self.stack pushBoard:[SearchKeywordsListBoard_iPhone boardWithNibName:@"SearchKeywordsListBoard_iPhone"] animated:YES];
}

- (IBAction)onPressedTime:(id)sender
{
    NSArray* array = [CommonUtility getCanSelectHourMin];
    if ([array count] == 0) {
        return;
    }
    [_pickerBg setHidden:NO];
    NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    if (time != nil) {
        for (int i = 0; i < [[CommonUtility getCanSelectHourMin] count]; i++) {
            if ([time isEqualToDate:[[CommonUtility getCanSelectHourMin] objectAtIndex:i]]) {
                [_picker selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
    }
}

- (IBAction)onPressedSearch:(id)sender
{
    [self.stack pushBoard:[QiuchangResultListBoard_iPhone boardWithNibName:@"QiuchangResultListBoard_iPhone"] animated:YES];
}


#pragma mark -

- (void)resetCells
{
    //[self devideDatas];
    [_bottomCtrl setDataArray:self.courseArray];
}

- (void)devideDatas
{
    self.courseArray = [NSMutableArray array];
    for (NSDictionary* dict in self.dataDict[@"order"])
    {
        if ([dict[@"type"] intValue] == 1)
        {
            [self.courseArray addObject:dict];
        }
    }
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* paramDict = @{
                                @"session":[UserModel sharedInstance].session.objectToDictionary
                                };
    //[self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"searchrecentcourse"])
    .PARAM(@"json",[paramDict JSONString])
    .TIMEOUT(30);
}

- (NSDictionary*) commonCheckRequest:(BeeHTTPRequest *)req
{
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        [self dismissTips];
        //[self presentFailureTips:__TEXT(@"error_network")];
    } else if ( req.succeed ) {
        [self dismissTips];
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            //[self presentFailureTips:__TEXT(@"error_network")];
        } else {
            dict = [self _removeNSNullInDectionary:dict];
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
        if ([[req.url absoluteString] rangeOfString:@"searchrecentcourse"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                //拉订单
                self.courseArray = [NSMutableArray arrayWithArray:(dict[@"data"])];
                [self resetCells];
            }
            else
            {
                //[self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

@end
