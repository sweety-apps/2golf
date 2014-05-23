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

#pragma mark -

@interface SouSuoQiuChangBoard_iPhone() <UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{
    SouSuoQiuChangViewController* _ctrl;
    SouSuoQiuchangBottomViewController* _bottomCtrl;
}
@end

@implementation SouSuoQiuChangBoard_iPhone

//SUPPORT_AUTOMATIC_LAYOUT( YES )
//SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[super load];
}

- (void)unload
{
    [_ctrl release];
    [_bottomCtrl release];
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
        CGFloat y = self.scrollContentView.frame.size.height - 66-6 - rect.size.height;
        rect.origin.y = y;
        _bottomCtrl.view.frame = rect;
        [self.scrollContentView addSubview:_bottomCtrl.view];
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
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        if (self.view.frame.size.height <= 480)
        {
            self.scrollView.frame = CGRectMake(0, 6, 320, 480);
            self.scrollView.contentSize = CGSizeMake(320, 568);
        }
        else
        {
            self.scrollView.frame = CGRectMake(0, 6, 320, 568);
            self.scrollView.contentSize = CGSizeMake(320, 568);
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
    return 24*6;//10分钟区间
}

#pragma mark - <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:row*10.0f*60.f];
    return [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:row*10.0f*60.f];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_time"];
    [[pickerView superview] removeFromSuperview];
    [self _refreshSelections];
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
        date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
    }
    str = [NSString stringWithFormat:@"%d年%d月%d日\n%@",[date year],[date month],[date day],[date weekdayChinese]];
    if ([str length] == 0)
    {
        str = @"2014年02月21日\n星期五";
    }
    self.lblDate.text = str;
    //时间
    date = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
    if (date == nil)
    {
        date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_time"];
    }
    str = [NSString stringWithFormat:@"%02d:%02d",[date hour],[date minute]];
    if ([str length] == 0)
    {
        str = @"08:30";
    }
    self.lblTime.text = str;
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
    CGRect rect = self.frame;
    rect.origin = CGPointZero;
    
    UIView* pickerBg = [[[UIView alloc] initWithFrame:rect] autorelease];
    pickerBg.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self.view addSubview:pickerBg];
    
    UIPickerView* picker = [[[UIPickerView alloc] init] autorelease];
    rect = picker.frame;
    rect.origin = CGPointZero;
    rect.origin.y = pickerBg.frame.size.height - rect.size.height;
    picker.frame = rect;
    picker.delegate = self;
    picker.dataSource = self;
    
    UIView* bgView = [[[UIView alloc] initWithFrame:rect] autorelease];
    bgView.backgroundColor = RGBA(255, 255, 255, 1.0);
    [pickerBg addSubview:bgView];
    
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor clearColor];
    rect.size.height = rect.origin.y;
    rect.origin.x = 0;
    cancelBtn.frame = rect;
    [cancelBtn addTarget:self action:@selector(_onCancelTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    [pickerBg addSubview:cancelBtn];
     
    
    
    [pickerBg addSubview:picker];
}

- (IBAction)onPressedSearch:(id)sender
{
    [self.stack pushBoard:[QiuchangResultListBoard_iPhone boardWithNibName:@"QiuchangResultListBoard_iPhone"] animated:YES];
}

@end
