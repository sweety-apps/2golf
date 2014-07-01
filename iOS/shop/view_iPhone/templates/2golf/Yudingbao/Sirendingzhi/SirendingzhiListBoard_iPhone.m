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
//  SirendingzhiListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-27.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SirendingzhiListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "QuichangDetailBoard_iPhone.h"
#import "SirendingzhiListCellBoard_iPhone.h"
#import "OtherTripBoard_iPhone.h"
#import "SirendingzhiDetailBoard_iPhone.h"

#pragma mark -

@interface SirendingzhiListBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}
@property (nonatomic,retain) NSMutableDictionary* dataDict;

@end

@implementation SirendingzhiListBoard_iPhone

DEF_SIGNAL(OTHER_TRIP_RIGHT_NAV_BTN);

- (void)load
{
	[super load];
}

- (void)unload
{
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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"私人订制"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角地图按钮
        CGRect rect;
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        UILabel* rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(-50,13, 100, 17)] autorelease];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:14];
        rightLabel.text = @"其他行程";
        gRightLabel = rightLabel;
        [rightBtnContainerView addSubview:rightLabel];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.OTHER_TRIP_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 50, 40);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        rect = self.viewBound;
        rect.origin.y+=6+5;
        rect.size.height-=6+5;
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
        rect.origin.y+=6+5;
        rect.size.height-=6+5;
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

ON_SIGNAL( signal )
{
    if ( [signal is:self.OTHER_TRIP_RIGHT_NAV_BTN] )
    {
        //其他行程填表
        OtherTripBoard_iPhone* board = [OtherTripBoard_iPhone boardWithNibName:@"OtherTripBoard_iPhone"];
        [self.stack pushBoard:board animated:YES];
    }
}

ON_SIGNAL2( SirendingzhiListCell_iPhone, signal )
{
    int index = ((BeeUICell*)signal.source).tag;
    SirendingzhiDetailBoard_iPhone* board = [SirendingzhiDetailBoard_iPhone boardWithNibName:@"SirendingzhiDetailBoard_iPhone"];
    [board setCustomId:self.dataDict[@"privatecustom"][index][@"id"]];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.dataDict)
    {
        row = [self.dataDict[@"privatecustom"] count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUICell * cell = nil;
    
    cell = [scrollView dequeueWithContentClass:[SirendingzhiListCell_iPhone class]];
    cell.data = (self.dataDict[@"privatecustom"])[index];
    cell.tag = index;
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 222);
}

#pragma mark -

- (void)resetCells
{
    
}

#pragma mark - Network


- (void)fetchData
{
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"search_local"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"privatecustomlist"])
    .PARAM(@"longitude",dic[@"longitude"])
    .PARAM(@"latitude",dic[@"latitude"])
    .PARAM(@"scope",@"50")
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
        if ([[req.url absoluteString] rangeOfString:@"privatecustomlist"].length > 0)
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

@end
