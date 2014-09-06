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
//  BrandListBoard_iPhone.m
//  example
//
//  Created by rolandxu on 14-9-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "BrandListBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "BrandListCell_iPhone.h"
#import "QiuchangOrderCell_iPhoneV2.h"
#import "QiuChangOrderDetailCell.h"
#import "ecmobile.h"
#import "GoodsListBoard_iPhone.h"

#pragma mark -

@interface BrandListBoard_iPhone()
<BrandListCell_iPhoneDelegate>
{
	BeeUIScrollView* _scroll;
    FILTER *                _tempFilter;
}
@end

@implementation BrandListBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	[super load];
    self.brandModel = [[[BrandModel alloc] init] autorelease];
    [self.brandModel addObserver:self];
}

- (void)unload
{
	[super unload];
    [self.brandModel removeObserver:self];
    self.brandModel = nil;
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"品牌"];
        
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        [self showBarButton:BeeUINavigationBar.RIGHT title:__TEXT(@"collect_done") image:[UIImage imageNamed:@"nav-right.png"]];
        
        
        CGSize rSize = __IMAGE(@"titleicon").size;
        CGRect rRect = CGRectMake(0, 10, rSize.width, rSize.height+10);
        UIImageView* rightImg = [[UIImageView alloc] initWithFrame:rRect];
        rightImg.image = __IMAGE(@"titleicon");
        rightImg.contentMode = UIViewContentModeBottom;
        rightImg.backgroundColor = [UIColor clearColor];
        [self showBarButton:BeeUINavigationBar.RIGHT custom:rightImg];
        
        CGRect rect;
        
        ////
        rect = self.viewBound;
        rect.origin.y+=40;
        rect.size.height-=40;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:NO animated:NO];
		[self.view addSubview:_scroll];
        _tempFilter = [[FILTER alloc] init];

        
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )

    {
        [_tempFilter release];
        _tempFilter = nil;
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
        CGRect rect = self.viewBound;
        rect.origin.y+=40;
        rect.size.height-=40;
        _scroll.frame =rect;
        
        if ( NO == self.brandModel.loaded )
        {
            [self.brandModel fetchFromServer];
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


#pragma mark -

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
    
    if ( msg.sending )
    {
        [self presentLoadingTips:__TEXT(@"tips_loading")];
    }
    else if ( msg.failed )
    {
        [ErrorMsg presentErrorMsg:msg inBoard:self];
    }
    else if ( [msg is:API.brand] )
	{
		if ( msg.succeed )
		{
            [self dismissTips];
			[_scroll asyncReloadData];
		}
    }
    else
    {
        [self dismissTips];
    }

}
#pragma mark - scrollview datasource


- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView*)scrollView
{
    return 1;
}

#define COLNUM 3
- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    int rownum = self.brandModel.brands.count / COLNUM;
    if (self.brandModel.brands.count % 3 == 0) {
        
    }
    else
    {
        rownum ++;
    }
	return rownum;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    //    if ( self.loaded && 0 == self.currentArray.count )
    //	{
    //
    //	}
    
    //	QiuchangOrderCell_iPhone* cell = [scrollView dequeueWithContentClass:[QiuchangOrderCell_iPhone class]];
    BrandListCell_iPhone* cell = [scrollView dequeueWithContentClass:[BrandListCell_iPhone class]];
    
    cell.data = [self getRowData:index];
    cell.tag = index;
    cell.delegate = self;
    //    cell.data = self.currentArray[index];
    
    //    QiuchangOrderCell_iPhoneLayout* lo = self.currentLayoutArray[index];
    
    //    [cell setCellLayout:lo];
    
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    //	if ( self.loaded && 0 == self.currentArray.count )
    //	{
    //		return self.size;
    //	}
    
	int height = 53;
	return CGSizeMake(scrollView.width, height);
    
}

-(void)onClickBrand:(BRAND*)brand
{
    _tempFilter.brand_id = brand.brand_id;
    _tempFilter.brand_name = brand.brand_name;
 
    GoodsListBoard_iPhone * board = nil;
    
    if ([self.previousBoard isKindOfClass:[GoodsListBoard_iPhone class]])
    {
        board = (GoodsListBoard_iPhone *)self.previousBoard;
    }
    else
    {
        board = [GoodsListBoard_iPhone board];
    }
    [board.model1 setValueWithFilter:_tempFilter];
    [board.model2 setValueWithFilter:_tempFilter];
    [board.model3 setValueWithFilter:_tempFilter];
    [board.model4 setValueWithFilter:_tempFilter];
    [self.stack popBoardAnimated:YES];
}

-(NSArray*)getRowData:(int)row
{
    NSMutableArray* array = [NSMutableArray array];
    for (int i = row * COLNUM; i < COLNUM*(row+1) && i < self.brandModel.brands.count; i++) {
        [array addObject:self.brandModel.brands[i]];
    }
    return array;
}
@end
