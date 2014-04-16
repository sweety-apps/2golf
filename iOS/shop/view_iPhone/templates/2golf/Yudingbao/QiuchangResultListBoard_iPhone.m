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
//  QiuchangResultListBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-16.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangResultListBoard_iPhone.h"
#import "QiuchangCellViewController.h"
#import "AppBoard_iPhone.h"
#import "ServerConfig.h"
#import "CommonUtility.h"
#import "QiuchangResultMapBoard_iPhone.h"
#import "QuichangDetailBoard_iPhone.h"

#pragma mark -

@interface QiuchangResultListCellContainer : BeeUICell
{
    QiuchangCellViewController* _ctrl;
}

@property (nonatomic, retain) QiuchangCellViewController* ctrl;

@end


@implementation QiuchangResultListCellContainer

@synthesize ctrl;

+ (CGSize)estimateUISizeByWidth:(CGFloat)width forData:(id)data expaned:(BOOL)expaned
{
    return CGSizeMake( width, 35.0f );
}

- (void)initSubView
{
    QiuchangCellViewController* board = [[QiuchangCellViewController alloc] initWithNibName:@"QiuchangCellViewController" bundle:nil];
    [self addSubview:board.view];
    self.ctrl = board;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)dealloc
{
    self.ctrl = nil;
    [super dealloc];
}

- (void)dataDidChanged
{
    
}

@end

#pragma mark -

@interface QiuchangResultListBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSMutableArray* dataArray;
@property (nonatomic,retain) NSMutableArray* distanceArray;

@end

@implementation QiuchangResultListBoard_iPhone

DEF_SIGNAL(DAIL_RIGHT_NAV_BTN);

@synthesize dataArray;
@synthesize distanceArray;

- (void)load
{
	[super load];
}

- (void)unload
{
    self.dataArray = nil;
    self.distanceArray = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.HEADER_REFRESH] )
	{
		[self fetchData];
	}
	else if ( [signal is:BeeUIScrollView.REACH_BOTTOM] || [signal is:BeeUIScrollView.FOOTER_REFRESH] )
	{
		//[[self currentModel] nextPageFromServer];
	}
}

static BeeUIButton* gRightBtn = nil;

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"球场列表"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        //右上角地图按钮
        CGRect rect;
        UIView* rightBtnContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)] autorelease];
        
        UIImageView* rightIcon = [[[UIImageView alloc] initWithImage:__IMAGE(@"courselisticonmap")] autorelease];
        rightIcon.frame = CGRectMake(-23, 13, 17, 17);
        rightIcon.contentMode = UIViewContentModeTopLeft;
        [rightBtnContainerView addSubview:rightIcon];
        
        UILabel* rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(17-23,13, 50-17, 17)] autorelease];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.text = @"地图";
        [rightBtnContainerView addSubview:rightLabel];
        
        rightBtnContainerView.backgroundColor = [UIColor clearColor];
        BeeUIButton* rightBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor clearColor];
        gRightBtn = rightBtn;
        [rightBtn addSignal:self.DAIL_RIGHT_NAV_BTN forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(-23, 0, 50, 40);
        [rightBtnContainerView addSubview:rightBtn];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightBtnContainerView];
        
        
        ////
        rect = self.viewBound;
        rect.origin.y+=49;
        rect.size.height-=49;
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
        rect.origin.y+=49;
        rect.size.height-=49;
        _scroll.frame =rect;
        
        [self btn1Pressed:self.btn1];
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

- (void)fetchData
{
    self.HTTP_GET([[ServerConfig sharedInstance].url stringByAppendingString:@"searcharound"]).TIMEOUT(30);
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
        //球场列表
        if ([[req.url absoluteString] rangeOfString:@"searcharound"].length > 0)
        {
            //正确逻辑
            if ([(dict[@"status"])[@"succeed"] intValue] == 1)
            {
                self.dataArray = [NSMutableArray arrayWithArray:(dict[@"data"])[@"course"]];
                self.distanceArray = [NSMutableArray array];
                for (int i = 0; i < [dataArray count]; ++i)
                {
                    double locX = [((self.dataArray[i])[@"latitude"]) doubleValue];
                    double locY = [((self.dataArray[i])[@"longitude"]) doubleValue];
                    double dis =
                    [CommonUtility metersOfDistanceBetween:[CommonUtility currentPositionX] _y1:[CommonUtility currentPositionY] _x2:locX _y2:locY];
                    [self.distanceArray addObject:[NSNumber numberWithDouble:dis]];
                }
                [_scroll reloadData];
            }
            else
            {
                [self presentFailureTips:__TEXT(@"error_network")];
            }
        }
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
    if ( [signal is:self.DAIL_RIGHT_NAV_BTN] )
    {
        //打开地图
        QiuchangResultMapBoard_iPhone * board = [QiuchangResultMapBoard_iPhone board];
        [self.stack pushBoard:board animated:YES];
        [board setPoints:self.dataArray];
    }
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (self.dataArray)
    {
        row = [self.dataArray count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
	QiuchangResultListCellContainer * cell = [scrollView dequeueWithContentClass:[QiuchangResultListCellContainer class]];
    
    [cell setFrame:CGRectMake(0, 0, 320, 58)];
    cell.ctrl.nameLabel.text = (self.dataArray[index])[@"coursename"];
    cell.ctrl.distanceLabel.text = [NSString stringWithFormat:@"距离：%.3f公里",[((NSNumber*)(self.distanceArray[index])) doubleValue]/1000.f];
    cell.ctrl.descriptionLabel.text = (self.dataArray[index])[@"slogan"];
    cell.ctrl.valueLabel.text = [NSString stringWithFormat:@"￥%@",(self.dataArray[index])[@"cheapestprice"]];
    [cell.ctrl.iconImageView GET:((self.dataArray[index])[@"img"])[@"small"] useCache:YES];
    cell.ctrl.btn.tag = index;
    [cell.ctrl.btn addTarget:self action:@selector(_onTouchedCell:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return CGSizeMake(320, 58);
}

#pragma mark -

- (void)_onTouchedCell:(UIButton*)btn
{
    NSInteger index = btn.tag;
    
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [self.stack pushBoard:board animated:YES];
    
}

#pragma mark -
- (IBAction)btn1Pressed:(id)sender
{
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    
    self.btn1.selected = YES;
    [self fetchData];
}

- (IBAction)btn2Pressed:(id)sender
{
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    
    self.btn2.selected = YES;
    [self fetchData];
}

- (IBAction)btn3Pressed:(id)sender
{
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    
    self.btn3.selected = YES;
    [self fetchData];
}

@end
