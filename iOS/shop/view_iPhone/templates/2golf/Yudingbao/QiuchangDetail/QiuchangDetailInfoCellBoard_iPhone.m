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
//  QiuchangDetailInfoCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-17.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangDetailInfoCellBoard_iPhone.h"
#import "QiuchangResultMapBoard_iPhone.h"
#import "TimeSquareBoard_iPhone.h"
#import "CommonUtility.h"
#import "BMKNavigation.h"
#import "AppDelegate.h"

#pragma mark -

@interface QiuchangDetailInfoCell_iPhone ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain) QiuchangDetailInfoCellBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation QiuchangDetailInfoCell_iPhone

- (void)load
{
    [super load];
    
    self.ctrl = [QiuchangDetailInfoCellBoard_iPhone boardWithNibName:@"QiuchangDetailInfoCellBoard_iPhone"];
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
        
        //导航
        self.ctrl.leftLbl1.text = dict[@"address"];
        self.ctrl.rightLbl1.text = @"导航";
        [self.ctrl.btn1 addTarget:self action:@selector(_pressedBtn1:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString* str = nil;
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
        self.ctrl.leftLbl2.text = @"打球日期";
        self.ctrl.rightLbl2.text = str;
        [self.ctrl.btn2 addTarget:self action:@selector(_pressedBtn2:) forControlEvents:UIControlEventTouchUpInside];
        
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
        self.ctrl.leftLbl3.text = @"打球时间";
        self.ctrl.rightLbl3.text = str;
        [self.ctrl.btn3 addTarget:self action:@selector(_pressedBtn3:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -

- (void)_pressedBtn1:(UIButton*)btn
{
    [self webNavi];
    //[[[self superview] superview].board.stack pushBoard:[QiuchangResultMapBoard_iPhone board] animated:YES];
}

- (void)_pressedBtn2:(UIButton*)btn
{
    [[[self superview] superview].board.stack pushBoard:[TimeSquareBoard_iPhone board] animated:YES];
}

- (void)_pressedBtn3:(UIButton*)btn
{
    CGRect rect = [[self superview] superview].board.view.frame;
    rect.origin = CGPointZero;
    
    UIView* pickerBg = [[[UIView alloc] initWithFrame:rect] autorelease];
    pickerBg.backgroundColor = RGBA(0, 0, 0, 0.4);
    [[[self superview] superview].board.view addSubview:pickerBg];
    
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

- (void)webNavi
{
    NSDictionary* dict = self.data;
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = NAVI_TYPE_WEB;
    
    //初始化起点节点
    BMKPlanNode* start = [[[BMKPlanNode alloc]init] autorelease];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    AppDelegate* del = ((AppDelegate*)[UIApplication sharedApplication].delegate);
    coor1.latitude = [del getCurrentLatitude] ;
	coor1.longitude = [del getCurrentLongitude];
    start.pt = coor1;
    //指定起点名称
    
    start.name = @"当前位置";
    //指定起点
    para.startPoint = start;
    
    
    //初始化终点节点
    BMKPlanNode* end = [[[BMKPlanNode alloc]init] autorelease];
    CLLocationCoordinate2D coor2;
	coor2.latitude = [dict[@"latitude"] floatValue];
	coor2.longitude = [dict[@"longitude"] floatValue];
	end.pt = coor2;
    para.endPoint = end;
    //指定终点名称
    end.name = dict[@"coursename"];
    //指定调启导航的app名称
    para.appName = [NSString stringWithFormat:@"%@", @"testAppName"];
    //调启web导航
    [BMKNavigation openBaiduMapNavigation:para];
    [para release];

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
    [self dataDidChanged];
    if (self.delegate && [self.delegate respondsToSelector:@selector(qiuchangDetailInfoCell:shouldRefreshData:)])
    {
        [self.delegate qiuchangDetailInfoCell:self shouldRefreshData:[CommonUtility getSearchTimeStamp]];
    }
}

@end


#pragma mark -

@interface QiuchangDetailInfoCellBoard_iPhone()
{
	
}
@end

@implementation QiuchangDetailInfoCellBoard_iPhone

@synthesize leftLbl1;
@synthesize rightLbl1;
@synthesize btn1;

@synthesize leftLbl2;
@synthesize rightLbl2;
@synthesize btn2;

@synthesize leftLbl3;
@synthesize rightLbl3;
@synthesize btn3;

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
        [self.btn1 setBackgroundImage:[__IMAGE(@"normallist_content_bg_h") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.btn2 setBackgroundImage:[__IMAGE(@"normallist_content_bg_m") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
        [self.btn3 setBackgroundImage:[__IMAGE(@"normallist_content_bg_t") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f] forState:UIControlStateNormal];
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

- (void)setData:(NSDictionary*)data
{
    
}

@end
