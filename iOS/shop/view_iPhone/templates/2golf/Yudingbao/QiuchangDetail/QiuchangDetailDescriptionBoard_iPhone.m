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
//  QiuchangDetailDescriptionBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangDetailDescriptionBoard_iPhone.h"
#import "Placeholder.h"
#import "AppBoard_iPhone.h"
#import "PhotoSlideViewBoard_iPhone.h"

#pragma mark -

@interface QiuchangDetailDescriptionCell_iPhone()
{
}

@property (nonatomic,retain) BeeUIImageView * bgImage;
@property (nonatomic,retain) BeeUILabel* titleLabel;
@property (nonatomic,retain) BeeUILabel* contentLabel;
@property (nonatomic,retain) BeeUIImageView * contentImg0;
@property (nonatomic,retain) BeeUIImageView * contentImg1;
@property (nonatomic,retain) BeeUIImageView * contentImg2;
@end

#pragma mark -

@implementation QiuchangDetailDescriptionCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
	self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
	self.bgImage = [[[BeeUIImageView alloc] init] autorelease];
    self.bgImage.image = [__IMAGE(@"normallist_content_bg_s") stretchableImageWithLeftCapWidth:25.f topCapHeight:10.f];
	self.bgImage.indicatorStyle = UIActivityIndicatorViewStyleGray;
    self.bgImage.frame = CGRectZero;
    self.bgImage.contentMode = UIViewContentModeScaleToFill;
	[self addSubview:self.bgImage];
    
    self.titleLabel = [[[BeeUILabel alloc] init] autorelease];
    self.titleLabel.text = @"";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
	self.titleLabel.contentMode = UIViewContentModeScaleAspectFill;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.textColor = RGBA(0, 104, 56, 1.0);
	self.titleLabel.frame = CGRectMake(40, 20, 240, 16);
	[self addSubview:self.titleLabel];
    
    self.contentLabel = [[[BeeUILabel alloc] init] autorelease];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.text = @"";
	self.contentLabel.contentMode = UIViewContentModeScaleAspectFill;
	self.contentLabel.font = [UIFont systemFontOfSize:10.0f];
    self.contentLabel.textColor = [UIColor blackColor];
	self.contentLabel.frame = CGRectMake(40, 20, 240, 16);
    self.contentLabel.numberOfLines = 0;
	[self addSubview:self.contentLabel];
    
    self.contentImg0 = [[[BeeUIImageView alloc] init] autorelease];
    self.contentImg0.image = [Placeholder image];
	self.contentImg0.contentMode = UIViewContentModeScaleAspectFill;
	self.contentImg0.indicatorStyle = UIActivityIndicatorViewStyleGray;
	self.contentImg0.frame = CGRectZero;
    [self addSubview:self.contentImg0];
    
    self.contentImg1 = [[[BeeUIImageView alloc] init] autorelease];
    self.contentImg1.image = [Placeholder image];
	self.contentImg1.contentMode = UIViewContentModeScaleAspectFill;
	self.contentImg1.indicatorStyle = UIActivityIndicatorViewStyleGray;
	self.contentImg1.frame = CGRectZero;
    [self addSubview:self.contentImg1];
    
    self.contentImg2 = [[[BeeUIImageView alloc] init] autorelease];
    self.contentImg2.image = [Placeholder image];
	self.contentImg2.contentMode = UIViewContentModeScaleAspectFill;
	self.contentImg2.indicatorStyle = UIActivityIndicatorViewStyleGray;
	self.contentImg2.frame = CGRectZero;
    [self addSubview:self.contentImg2];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)unload
{
	self.bgImage = nil;
	
	[super unload];
}

- (void)layoutDidFinish
{
	//_image.frame = self.bounds;
}

- (void)setImageUrl:(NSString*)url
{
    //_image.url = url;
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSString* str = nil;
        str = self.data[@"title"];
        self.titleLabel.text = str;
        str = self.data[@"contentText"];
        self.contentLabel.text = str;
        str = self.data[@"image"][0];
        if ([str length] > 0)
        {
            [self.contentImg0 setUrl:str];
        }
        str = self.data[@"image"][1];
        if ([str length] > 0)
        {
            [self.contentImg1 setUrl:str];
        }
        str = self.data[@"image"][2];
        if ([str length] > 0)
        {
            [self.contentImg2 setUrl:str];
        }
        [self resetCellSize];
    }
}

#pragma mark methods

- (void)resetCellSize
{
    NSString* str = nil;
    CGRect rect = self.titleLabel.frame;
    CGSize size = CGSizeZero;
    
    str = self.data[@"contentText"];
    if ([str length] > 0)
    {
        size = rect.size;
        size.height = MAXFLOAT;
        size = [self.contentLabel.text sizeWithFont:self.contentLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.frame = CGRectMake(rect.origin.x, CGRectGetMaxY(rect) + 10, size.width, size.height);
    }
    
    str = self.data[@"image"][0];
    if ([str length] > 0)
    {
        self.contentImg0.frame = CGRectMake(rect.origin.x, CGRectGetMaxY(rect) + 10, 70, 70);
    }
    str = self.data[@"image"][1];
    if ([str length] > 0)
    {
        self.contentImg1.frame = CGRectMake(rect.origin.x+85, CGRectGetMaxY(rect) + 10, 70, 70);
    }
    str = self.data[@"image"][2];
    if ([str length] > 0)
    {
        self.contentImg2.frame = CGRectMake(rect.origin.x+170, CGRectGetMaxY(rect) + 10, 70, 70);
    }
    
    self.bgImage.frame = CGRectMake(15, 0, 290, MAX(CGRectGetMaxY(self.contentLabel.frame), CGRectGetMaxY(self.contentImg0.frame))+20);
    
    self.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(self.bgImage.frame)+5);
}

@end

#pragma mark -

@interface QiuchangDetailDescriptionBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSMutableArray* cellArray;
@property (nonatomic,retain) NSMutableDictionary* dataDict;

@end

@implementation QiuchangDetailDescriptionBoard_iPhone

- (void)load
{
	[super load];
}

- (void)unload
{
    self.cellArray = nil;
    self.dataDict = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"深圳XXX球场"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect;
        
        rect = self.viewBound;
        rect.origin.y+=16;
        rect.size.height-=16;
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
        rect.origin.y+=16;
        rect.size.height-=16;
        _scroll.frame =rect;
        self.view.backgroundColor = RGB(238, 238, 239);
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

ON_SIGNAL2( QiuchangDetailDescriptionCell_iPhone, signal )
{
	PhotoSlideViewBoard_iPhone * board = [PhotoSlideViewBoard_iPhone board];
    board.pictures = self.dataDict[@"imgdetail"];
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

- (void)setDataDictionary:(NSDictionary*)dataDict
{
    self.dataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    [self resetCells];
    [_scroll reloadData];
}

- (void)resetCells
{
    if (self.cellArray == nil)
    {
        self.cellArray = [NSMutableArray array];
    }
    [self.cellArray removeAllObjects];
    
    QiuchangDetailDescriptionCell_iPhone * cell = nil;
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"球场简介",
                  @"contentText":self.dataDict[@"brief"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"球场电话",
                  @"contentText":self.dataDict[@"tel"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"球场设施",
                  @"contentText":self.dataDict[@"facilities"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    NSString* url = nil;
    NSMutableArray* imgArr = [NSMutableArray array];
    
    if ([((NSArray*)(self.dataDict[@"imgdetail"])) count] > 0)
    {
        url = self.dataDict[@"imgdetail"][0][@"small"];
    }
    else
    {
        url = @"";
    }
    imgArr[0] = url;
    
    if ([((NSArray*)(self.dataDict[@"imgdetail"])) count] > 1)
    {
        url = self.dataDict[@"imgdetail"][1][@"small"];
    }
    else
    {
        url = @"";
    }
    imgArr[1] = url;
    
    if ([((NSArray*)(self.dataDict[@"imgdetail"])) count] > 2)
    {
        url = self.dataDict[@"imgdetail"][2][@"small"];
    }
    else
    {
        url = @"";
    }
    imgArr[2] = url;
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"球道详情",
                  @"contentText":@"",
                  @"image":imgArr};
    [self.cellArray addObject:cell];
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"地址",
                  @"contentText":self.dataDict[@"address"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"交通方式",
                  @"contentText":self.dataDict[@"traffic"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    cell = [QiuchangDetailDescriptionCell_iPhone cell];
    cell.data = @{@"title":@"球场描述",
                  @"contentText":self.dataDict[@"description"],
                  @"image":@[@"",@"",@""]};
    [self.cellArray addObject:cell];
    
    //navigation title
    [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:self.dataDict[@"coursename"]];
}

@end
