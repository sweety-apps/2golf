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

@interface QiuchangDetailInfoCell_iPhone ()
{
    
}
@property (nonatomic,retain) QiuchangDetailInfoCellBoard_iPhone* ctrl;
@property (nonatomic,retain) NSArray* hourMinDateArr;

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
            date = [CommonUtility getDateFromZeroPerDay:[NSDate now]];
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"search_date"];
        }
        str = [NSString stringWithFormat:@"%d月%d日 %@",[date month],[date day],[date weekdayChinese]];
        if ([str length] == 0)
        {
            str = @"02月21日 星期五";
        }

        self.ctrl.leftLbl2.text = @"打球日期";
        self.ctrl.rightLbl2.text = str;
        [self.ctrl.btn2 addTarget:self action:@selector(_pressedBtn2:) forControlEvents:UIControlEventTouchUpInside];
        
        //时间
        NSDate* time = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_time"];
        BOOL b = time == nil;
        BOOL b1 = (time.year != date.year) ;
        BOOL b2 = (time.month != date.month) ;
        BOOL b3 = (time.day != date.day) ;
        if (b || b1|| b2 || b3) {
            //未選事件或者日期改了的話，就從新設置下
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickTime:)])
    {
        [self.delegate onClickTime:btn];
    }
 }

- (void)webNavi
{
    NSDictionary* dict = self.data;
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = BMK_NAVI_TYPE_WEB;
    
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

- (void)_removePickerBgView:(UIView*)bgView
{
    [bgView removeFromSuperview];
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
