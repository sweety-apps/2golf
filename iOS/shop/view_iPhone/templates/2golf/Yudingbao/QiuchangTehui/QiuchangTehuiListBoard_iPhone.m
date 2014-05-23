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
//  QiuchangTehuiListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-26.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangTehuiListBoard_iPhone.h"
#import "QiuchangTehuiRiziCellBoard_iPhone.h"
#import "QiuchangTehuiShiduanCellBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "QuichangDetailBoard_iPhone.h"
#import "CitySelectBoard_iPhone.h"
#import "AppDelegate.h"
#import "CommonUtility.h"

#pragma mark -

@interface QiuchangTehuiListBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSMutableDictionary* dataDict;

@end

@implementation QiuchangTehuiListBoard_iPhone

DEF_SIGNAL(LOCAL_RIGHT_NAV_BTN);

- (void)load
{
	[super load];
}

- (void)unload
{
    //self.cellArray = nil;
    self.dataDict = nil;
    
	[super unload];
}

#pragma mark Signal

static BeeUIButton* gRightBtn = nil;
static UILabel* gRightLabel = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场特惠"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角地图按钮
        CGRect rect;
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        UILabel* rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-60,13, 100, 17)] autorelease];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:13];
        rightLabel.text = @"";
        gRightLabel = rightLabel;
        [rightBtnContainerView addSubview:rightLabel];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.LOCAL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-23, 0, 50, 40);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        rect = self.viewBound;
        rect.origin.y+=6+self.headView.height;
        rect.size.height-=6+self.headView.height;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.backgroundColor = [UIColor clearColor];
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
        gRightBtn = nil;
        gRightLabel = nil;
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
        rect.origin.y+=6+self.headView.height;
        rect.size.height-=6+self.headView.height;
        _scroll.frame =rect;
        
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
        if ([str length] == 0 || [str isEqualToString:@"当前位置"])
        {
            str = @"当前位置";
        }
        else
        {
            str = [NSString stringWithFormat:@"地区|%@",str];
        }
        gRightLabel.text = str;
        
        [self onPressedShiduanBtn:self.shiduanBtn];
        [self onPressedJiagepaixuBtn:self.jiagepaixuBtn];
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


ON_SIGNAL( signal )
{
    if ( [signal is:self.LOCAL_RIGHT_NAV_BTN] )
    {
        [self.stack pushBoard:[CitySelectBoard_iPhone boardWithNibName:@"CitySelectBoard_iPhone"] animated:YES];
    }
}

ON_SIGNAL2( QiuchangTehuiRiziCell_iPhone, signal )
{
    int index = ((BeeUICell*)signal.source).tag;
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"specialday"][index][@"courseid"]];
    [self.stack pushBoard:board animated:YES];
}

ON_SIGNAL2( QiuchangTehuiShiduanCell_iPhone, signal )
{
    int index = ((BeeUICell*)signal.source).tag;
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"teetime"][index][@"courseid"]];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.dataDict)
    {
        if (self.shiduanBtn.selected)
        {
            row = [self.dataDict[@"teetime"] count];
        }
        else
        {
            row = [self.dataDict[@"specialday"] count];
        }
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUICell * cell = nil;
    
    if (self.shiduanBtn.selected)
    {
        cell = [scrollView dequeueWithContentClass:[QiuchangTehuiShiduanCell_iPhone class]];
        cell.data = (self.dataDict[@"teetime"])[index];
    }
    else
    {
        cell = [scrollView dequeueWithContentClass:[QiuchangTehuiRiziCell_iPhone class]];
        cell.data = (self.dataDict[@"specialday"])[index];
    }
    cell.tag = index;
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 48);
}

#pragma mark -

- (void)resetCells
{
    
}

#pragma mark - Network


- (void)fetchData
{
    if (self.shiduanBtn.selected)
    {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"];
        self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"searchteetime"])
        .PARAM(@"longitude",dic[@"longitude"])
        .PARAM(@"latitude",dic[@"latitude"])
        .PARAM(@"scope",@"50")
        .PARAM(@"timestamp", [NSString stringWithFormat:@"%ld",[CommonUtility getSearchTimeStamp]])
        .TIMEOUT(30);
    }
    else
    {
        NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"];
        self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"searchspecialday"])
        .PARAM(@"longitude",dic[@"longitude"])
        .PARAM(@"latitude",dic[@"latitude"])
        .PARAM(@"scope",@"50")
        .PARAM(@"timestamp", [NSString stringWithFormat:@"%ld",[CommonUtility getSearchTimeStamp]])
        .TIMEOUT(30);
    }
    
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
        if ([[req.url absoluteString] rangeOfString:@"searchteetime"].length > 0 || [[req.url absoluteString] rangeOfString:@"searchspecialday"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataDict = [NSMutableDictionary dictionaryWithDictionary:(dict[@"data"])];
                [self resetCells];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

#pragma mark - Events

-(IBAction)onPressedShiduanBtn:(id)sender
{
    self.shiduanBtn.selected = YES;
    self.riziBtn.selected = NO;
    
    self.dataDict = nil;
    [_scroll reloadData];
    [self fetchData];
}

-(IBAction)onPressedRiziBtn:(id)sender
{
    self.shiduanBtn.selected = NO;
    self.riziBtn.selected = YES;
    
    self.dataDict = nil;
    [_scroll reloadData];
    [self fetchData];
}

-(IBAction)onPressedJiagepaixuBtn:(id)sender
{
    self.jiagepaixuBtn.selected = YES;
    self.shijianpaixuBtn.selected = NO;
    
    //[self fetchData];
}

-(IBAction)onPressedShijianpaixuBtn:(id)sender
{
    self.jiagepaixuBtn.selected = NO;
    self.shijianpaixuBtn.selected = YES;
    
    //[self fetchData];
}

@end
