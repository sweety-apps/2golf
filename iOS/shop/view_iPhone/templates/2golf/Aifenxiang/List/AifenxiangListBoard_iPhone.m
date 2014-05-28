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
//  AifenxiangListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-28.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AifenxiangListBoard_iPhone.h"
#import "AifenxiangMenuTab.h"
#import "AifenxiangListCellBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "AifenxiangDetailWebBoard_iPhone.h"
#import "WebViewBoard_iPhone.h"

#pragma mark -

@interface AifenxiangListBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
    BOOL _fetchedTabs;
}

@property (nonatomic,retain) NSMutableDictionary* menuDataDict;
@property (nonatomic,retain) NSMutableDictionary* listDataDict;
@property (nonatomic,retain) NSMutableArray* menuTabArray;
@property (nonatomic,assign) NSInteger selectedTabIndex;

@end

@implementation AifenxiangListBoard_iPhone

+ (id)board
{
    return [super boardWithNibName:@"AifenxiangListBoard_iPhone"];
}

- (instancetype)init
{
    self = [super initWithNibName:@"AifenxiangListBoard_iPhone" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)load
{
	[super load];
    self.selectedTabIndex = -1;
    _fetchedTabs = NO;
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

static UIImageView* gBarBGView = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"爱分享"];
        
        CGRect rect;
        
        rect = self.viewBound;
        rect.origin.y+=6+self.menuScroll.frame.size.height;
        rect.size.height-=6+self.menuScroll.frame.size.height;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        _scroll.backgroundColor = [UIColor clearColor];
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view insertSubview:_scroll belowSubview:self.menuScroll];
        _scroll.clipsToBounds = NO;
        
        //NavigationBar背景太短
        UIImageView* barBGView = [[[UIImageView alloc] initWithImage:__IMAGE(@"titlebarbg")] autorelease];
        rect = barBGView.frame;
        rect.origin.y = 0;
        barBGView.frame = rect;
        gBarBGView=barBGView;
        UINavigationBar* bar = self.navigationController.navigationBar;
        bar.clipsToBounds = NO;
        [[bar subviews][0] insertSubview:barBGView atIndex:2];
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
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:NO];
        
        [_scroll setBaseInsets:UIEdgeInsetsMake(0, 0, [AppBoard_iPhone sharedInstance].tabbar.height, 0)];
		CGRect rect = self.viewBound;
        rect.origin.y+=6+self.menuScroll.frame.size.height;
        rect.size.height-=6+self.menuScroll.frame.size.height;
        _scroll.frame =rect;
        
        if (!_fetchedTabs)
        {
            [self fetchMenu];
        }
        else
        {
            [self fetchList];
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
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

ON_SIGNAL2( AifenxiangListCell_iPhone, signal )
{
    NSInteger index = ((AifenxiangListCell_iPhone*)signal.source).tag;
    switch ([self.listDataDict[@"share"][index][@"sharetype"] intValue])
    {
        case 0:
            //网页
        {
#if 0
            WebViewBoard_iPhone * board = [[[WebViewBoard_iPhone alloc] init] autorelease];
            board.defaultTitle = @"HAHAHA";
            board.urlString = @"http://localhost/test.html";
            [self.stack pushBoard:board animated:YES];
#else
            AifenxiangDetailWebBoard_iPhone* board = [AifenxiangDetailWebBoard_iPhone boardWithNibName:@"AifenxiangDetailWebBoard_iPhone"];
            [board setShareDetailID:self.listDataDict[@"share"][index][@"sharecontentid"]];
            [board setSummaryDictionary:self.listDataDict[@"share"][index]];
            [self.stack pushBoard:board animated:YES];
#endif
        }
            break;
            
        default:
            break;
    }
	
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (true)
    {
        row = [self.listDataDict[@"share"] count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    AifenxiangListCell_iPhone * cell = [scrollView dequeueWithContentClass:[AifenxiangListCell_iPhone class]];
    
    cell.data = self.listDataDict[@"share"][index];
    cell.tag = index;
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 202);
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (void)resetTabs
{
    _fetchedTabs = YES;
    CGFloat width = 0;
    self.menuTabArray = [NSMutableArray array];
    int i = 0;
    for (NSDictionary* dict in self.menuDataDict[@"category"])
    {
        AifenxiangMenuTab* tab = CREATE_NIBVIEW(@"AifenxiangMenuTab");
        [tab setTabTitleAndResizeTab:dict[@"categoryname"]];
        [tab addTarget:self action:@selector(pressedTab:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = tab.frame;
        rect.origin.x = width;
        tab.frame = rect;
        width+=tab.frame.size.width;
        tab.tag = i;
        [self.menuTabArray addObject:tab];
        [self.menuScroll addSubview:tab];
        i++;
    }
    CGSize size = self.menuScroll.contentSize;
    size.width = width;
    self.menuScroll.contentSize = size;
}


#pragma mark - Network

- (void)fetchMenu
{
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"sharecategory"]).TIMEOUT(30);
}

- (void)fetchList
{
    [self presentLoadingTips:@"正在加载"];
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"sharelist"]).PARAM(@"sharecategory",self.menuDataDict[@"category"][self.selectedTabIndex][@"icategoryd"]).TIMEOUT(30);
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
        //头顶tab
        if ([[req.url absoluteString] rangeOfString:@"sharecategory"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.menuDataDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
                [self resetTabs];
                [self selectTab:0];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
        //下面列表
        else if ([[req.url absoluteString] rangeOfString:@"sharelist"].length > 0)
        {
            //正确逻辑
            if (dict[@"data"])
            //if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.listDataDict = [NSMutableDictionary dictionaryWithDictionary:dict[@"data"]];
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
    }
}

#pragma mark - Private

- (void)pressedTab:(AifenxiangMenuTab*)tab
{
    int index = tab.tag;
    [self selectTab:index];
}

- (void)selectTab:(NSInteger)index
{
    self.selectedTabIndex = index;
    for (AifenxiangMenuTab* tab in self.menuTabArray)
    {
        tab.selected = NO;
    }
    ((AifenxiangMenuTab*)self.menuTabArray[index]).selected = YES;
    [self fetchList];
}

@end
