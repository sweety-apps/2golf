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
//  SirendingzhiDetailBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-10.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "SirendingzhiDetailBoard_iPhone.h"
#import "Placeholder.h"
#import "AppBoard_iPhone.h"
#import "PhotoSlideViewBoard_iPhone.h"
#import "SirendingzhiDetailHeaderCellBoard_iPhone.h"
#import "SirendingzhiDetailInfoCellBoard_iPhone.h"
#import "ServerConfig.h"
#import "FlightViewBoard_iPhone.h"
#import "SirendingzhiDetailSingleCell.h"
#import "NibLoader.h"
#import "QuichangDetailBoard_iPhone.h"

#pragma mark -

@interface SirendingzhiDetailBannerPhotoCell_iPhone()
{
	BeeUIImageView * _image;
}
@end

#pragma mark -

@implementation SirendingzhiDetailBannerPhotoCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
	self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
	_image = [[BeeUIImageView alloc] init];
    _image.image = [Placeholder image];
	_image.contentMode = UIViewContentModeScaleAspectFill;
	_image.indicatorStyle = UIActivityIndicatorViewStyleGray;
	[self addSubview:_image];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _image );
	
	[super unload];
}

- (void)layoutDidFinish
{
	_image.frame = self.bounds;
}

- (void)setImageUrl:(NSString*)url
{
    _image.url = url;
}

- (void)dataDidChanged
{
    [self setImageUrl:self.data[@"thumb"]];
}

@end

#pragma mark -

@implementation SirendingzhiDetailBannerCell_iPhone

DEF_SIGNAL( TOUCHED )

SUPPORT_RESOURCE_LOADING( YES )

@synthesize shadow = _shadow;
@synthesize scroll = _scroll;
@synthesize pageControl = _pageControl;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;
@synthesize arrowImg = _arrowImg;
@synthesize detailBtn = _detailBtn;

- (void)load
{
    [super load];
    
    self.scroll = [[[BeeUIScrollView alloc] init] autorelease];
	self.scroll.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    self.scroll.dataSource = self;
    self.scroll.horizontal = YES;
    self.scroll.pagingEnabled = YES;
    [self addSubview:self.scroll];
	
    /*
    self.shadow = [[[UIView alloc] init] autorelease];
    self.shadow.backgroundColor = RGBA(0, 180, 0, 0.3);
    [self addSubview:self.shadow];
    
    self.leftLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(22, 0, 200, 20)] autorelease];
    self.leftLabel.backgroundColor = [UIColor clearColor];
    self.leftLabel.font = [UIFont systemFontOfSize:13];
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    self.leftLabel.text = @"";
    [self.shadow addSubview:self.leftLabel];
    
    self.rightLabel  = [[[UILabel alloc]initWithFrame:CGRectMake(256, 0, 100, 20)] autorelease];
    self.rightLabel.backgroundColor = [UIColor clearColor];
    self.rightLabel.font = [UIFont systemFontOfSize:13];
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    self.rightLabel.text = @"详情";
    [self.shadow addSubview:self.rightLabel];
    
    self.arrowImg = [[[UIImageView alloc] initWithImage:__IMAGE(@"expand_left_white")] autorelease];
    self.arrowImg.frame = CGRectMake(287, 2, self.arrowImg.frame.size.width, self.arrowImg.frame.size.height);
    [self.shadow addSubview:self.arrowImg];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.frame = CGRectMake(0, 0, 320, 20);
    [self.shadow addSubview:self.detailBtn];
    
    [self.detailBtn addTarget:self action:@selector(_pressedDetail:) forControlEvents:UIControlEventTouchUpInside];
    */
    
	self.pageControl = [[[BeeUIPageControl alloc] init] autorelease];
	self.pageControl.hidesForSinglePage = NO;
	self.pageControl.layer.cornerRadius = 8.0f;
	self.pageControl.layer.shadowColor = RGBA(230, 240, 243, 1.0).CGColor;
    self.pageControl.pageIndicatorTintColor = RGBA(230, 240, 243, 1.0);
    self.pageControl.currentPageIndicatorTintColor = RGBA(15, 165, 247, 1.0);
	self.pageControl.layer.shadowOffset = CGSizeMake( 0.0f, 0.0f );
	self.pageControl.layer.shadowRadius = 0.0f;
	self.pageControl.layer.shadowOpacity = 1.0f;
    
    self.pageControl.hidden = YES;
	[self addSubview:self.pageControl];
    
    //[[self superview] superview].board
}

- (void)unload
{
    self.shadow = nil;
	self.scroll = nil;
	self.pageControl = nil;
	self.leftLabel = nil;
    self.rightLabel = nil;
    self.arrowImg = nil;
    self.detailBtn = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
    self.scroll.frame = self.bounds;
	[_scroll reloadData];
    
    //CGRect shadowFrame = CGRectMake(0, self.scroll.height - 20, 320, 20);
    //self.shadow.frame = shadowFrame;
	
	CGRect controlFrame;
	controlFrame.size.width = 60.0f;
	controlFrame.size.height = 16.0f;
	controlFrame.origin.x = 230;
	controlFrame.origin.y = self.height - controlFrame.size.height - 1.0f;
	self.pageControl.frame = controlFrame;
}

- (void)dataDidChanged
{
    if (self.data)
    {
        //self.leftLabel.text = self.data[@"slogan"];
    }
    
    [self.scroll reloadData];
}

#pragma mark -

ON_SIGNAL2( BeeUIScrollView , signal)
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIScrollView.DID_STOP] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
	else if ( [signal is:BeeUIScrollView.RELOADED] )
	{
		NSInteger pageCount = ((NSArray *)self.data).count;
		
		self.pageControl.currentPage = self.scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
	}
}

#pragma mark -

- (void)_pressedDetail:(UIButton*)btn
{
    /*
    QiuchangDetailDescriptionBoard_iPhone* board = [QiuchangDetailDescriptionBoard_iPhone board];
    [[self recursiveFindUIBoard].stack pushBoard:board animated:YES];
    [board setDataDictionary:self.data];
    */
    
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;//((NSArray *)(self.data[@"img"])).count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    SirendingzhiDetailBannerPhotoCell_iPhone * cell = [scrollView dequeueWithContentClass:[SirendingzhiDetailBannerPhotoCell_iPhone class]];
    //cell.data = (self.data[@"img"])[index];
    cell.data = (self.data[@"img"]);
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
	return scrollView.bounds.size;
}

@end


#pragma mark -

@interface SirendingzhiDetailBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}
@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) NSMutableDictionary* dataDict;
@property (nonatomic,retain) NSString* custom_Id;

@end

@implementation SirendingzhiDetailBoard_iPhone

- (void)load
{
	[super load];
}

- (void)unload
{
    self.cellArray = nil;
    self.dataDict = nil;
    self.custom_Id = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {	
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"套餐详情"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect;
        
        rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
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

ON_SIGNAL2( SirendingzhiDetailBannerPhotoCell_iPhone, signal )
{
    PhotoSlideViewBoard_iPhone * board = [PhotoSlideViewBoard_iPhone board];
    board.pictures = @[self.dataDict[@"img"]];
	//board.pageIndex = [self.goodsModel.goods.pictures indexOfObject:photo];
    [self.stack pushBoard:board animated:YES];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    //self.view.backgroundColor = RGBA(255, 0, 0, 0.5f);
    NSUInteger row = 0;
    if (true)
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
    BeeUICell * cell = self.cellArray[index];
	return cell.frame.size;
}

#pragma mark -

- (void)resetCells
{
    if (self.cellArray == nil)
    {
        self.cellArray = [NSMutableArray array];
    }
    [self.cellArray removeAllObjects];
    
    //banner
    {
        SirendingzhiDetailBannerCell_iPhone * cell = [[[SirendingzhiDetailBannerCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 126)] autorelease];
        cell.data = self.dataDict;
        [self.cellArray addObject:cell];
    }
    
    //
    {
        SirendingzhiDetailHeaderCell_iPhone* cell = [[SirendingzhiDetailHeaderCell_iPhone alloc] initWithFrame:CGRectZero];
        cell.data = self.dataDict;
        //[cell.ctrl.bgBtn5 addTarget:self action:@selector(onShowFlight) forControlEvents:UIControlEventTouchUpInside];
        [self.cellArray addObject:cell];
    }
    
    //球场
    int ncourse = [((NSArray*)self.dataDict[@"courseid"]) count];
    for (int i = 0; i < ncourse; ++i)
    {
        SirendingzhiDetailSingleCell* cell = CREATE_NIBVIEW(@"SirendingzhiDetailSingleCell");
        if (i == 0)
        {
            [cell setH];
        }
        else
        {
            [cell setM];
        }
        cell.bgBtn.tag = i;
        [cell.bgBtn addTarget:self action:@selector(_onShowCourse:) forControlEvents:UIControlEventTouchUpInside];
        cell.leftLabel.text = self.dataDict[@"coursename"][i];
        cell.rightLabel.text = @"";
        [self.cellArray addObject:cell];
    }
    
    //航班
    {
        SirendingzhiDetailSingleCell* cell = CREATE_NIBVIEW(@"SirendingzhiDetailSingleCell");
        [cell setB];
        [cell.bgBtn addTarget:self action:@selector(onShowFlight) forControlEvents:UIControlEventTouchUpInside];
        cell.leftLabel.text = @"往返航班及机票参考价";
        cell.rightLabel.text = @"详情";
        [self.cellArray addObject:cell];
        CGRect rect = cell.frame;
        rect.size.height += 20;
        cell.frame = rect;
    }
    
    //
    {
        SirendingzhiDetailInfoCell_iPhone* cell = [[SirendingzhiDetailInfoCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        cell.data = @{@"title":@"行程安排",@"content":self.dataDict[@"journey"]};
        cell.RELAYOUT();
        [self.cellArray addObject:cell];
    }
    {
        SirendingzhiDetailInfoCell_iPhone* cell = [[SirendingzhiDetailInfoCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        cell.data = @{@"title":@"价格包括",@"content":self.dataDict[@"containcontent"]};
        [self.cellArray addObject:cell];
    }
    {
        SirendingzhiDetailInfoCell_iPhone* cell = [[SirendingzhiDetailInfoCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        cell.data = @{@"title":@"价格不含",@"content":self.dataDict[@"nocontaincontent"]};
        [self.cellArray addObject:cell];
    }
    {
        SirendingzhiDetailInfoCell_iPhone* cell = [[SirendingzhiDetailInfoCell_iPhone alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        cell.data = @{@"title":@"备注",@"content":self.dataDict[@"remark"]};
        [self.cellArray addObject:cell];
    }
    
    
    //navigation title
    [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"套餐详情"];
}

#pragma mark - Network


- (void)fetchData
{
    self.HTTP_POST([[ServerConfig sharedInstance].url stringByAppendingString:@"privatecustomdetail"]).PARAM(@"customid",self.custom_Id).TIMEOUT(30);
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
        if ([[req.url absoluteString] rangeOfString:@"privatecustomdetail"].length > 0)
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

#pragma mark -

- (void) setCustomId:(NSString*)customId
{
    self.custom_Id = customId;
}

- (void) onShowFlight
{
    if (self.dataDict)
    {
        for (UIViewController* ctrl in [self childViewControllers])
        {
            if ([ctrl isKindOfClass:[FlightViewBoard_iPhone class]])
            {
                [ctrl removeFromParentViewController];
            }
        }
        NSArray* flightArr = self.dataDict[@"flightinfo"];
        FlightViewBoard_iPhone* board = [FlightViewBoard_iPhone boardWithNibName:@"FlightViewBoard_iPhone"];
        [self addChildViewController:board];
        [self.view addSubview:board.view];
        [board showViewWithDataArray:flightArr];
    }
}

- (void) _onShowCourse:(UIButton*)btn
{
    int index = btn.tag;
    
    QuichangDetailBoard_iPhone* board = [QuichangDetailBoard_iPhone boardWithNibName:@"QuichangDetailBoard_iPhone"];
    [board setCourseId:self.dataDict[@"courseid"][index]];
    [self.stack pushBoard:board animated:YES];
}

@end
