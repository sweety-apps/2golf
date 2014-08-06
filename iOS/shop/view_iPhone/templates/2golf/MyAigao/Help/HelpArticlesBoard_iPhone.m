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
//  HelpArticlesBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-8-6.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "HelpArticlesBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "HelpCell_iPhone.h"
#import "HelpBoard_iPhone.h"
#import "HelpMainBoard_iPhone.h"

#pragma mark -

@interface HelpArticlesBoard_iPhone()
{
	BeeUIScrollView *	_scroll;
}

@property (nonatomic,retain) NSArray* dataArr;
@end

@implementation HelpArticlesBoard_iPhone

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
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"帮助"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        CGRect rect = self.viewBound;
        rect.origin.y+=6;
        rect.size.height-=6;
        _scroll = [[BeeUIScrollView alloc] initWithFrame:rect];
		_scroll.dataSource = self;
		_scroll.vertical = YES;
        //_scroll.bounces = NO;
		[_scroll showHeaderLoader:YES animated:NO];
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
        
        [self setupDataArray];
        
        [_scroll reloadData];
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

ON_SIGNAL2( HelpCell_iPhone, signal )
{
	[super handleUISignal:signal];
	
    NSDictionary* dict = signal.sourceCell.data;
	if ( dict )
	{
		HelpMainBoard_iPhone * board = [HelpMainBoard_iPhone boardWithNibName:@"HelpMainBoard_iPhone"];
        board.customDict = dict;
		[self.stack pushBoard:board animated:YES];
	}
}

#pragma mark - Datas

- (void)setupDataArray
{
    self.dataArr = @[
  @{
      @"name":@"帮助中心",
      @"url":@"http://115.29.144.237/ECMobile/help/%E5%B8%AE%E5%8A%A9%E4%B8%AD%E5%BF%83.htm"
      },
  @{
      @"name":@"用户协议",
      @"url":@"http://115.29.144.237/ECMobile/help/%E7%88%B1%E9%AB%98%E9%AB%98%E5%B0%94%E5%A4%AB%E7%94%A8%E6%88%B7%E5%8D%8F%E8%AE%AE.htm"
      },
  @{
      @"name":@"关于我们",
      @"url":@"http://115.29.144.237/ECMobile/help/%E5%85%B3%E4%BA%8E%E6%88%91%E4%BB%AC.htm"
      },
  
                     ];
}

#pragma mark -

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    NSUInteger row = 0;
    
    if (self.helpModel)
    {
        //row = self.helpModel.articleGroups.count;
        row = [self.dataArr count];
    }
    
	return row;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    if (self.helpModel)
    {
        BeeUICell * cell = [scrollView dequeueWithContentClass:[HelpCell_iPhone class]];
        //cell.data = [self.helpModel.articleGroups safeObjectAtIndex:index];
        cell.data = self.dataArr[index];
        return cell;
    }
    
    return nil;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    if (self.helpModel)
    {
        id data = [self.helpModel.articleGroups safeObjectAtIndex:index];
        return [HelpCell_iPhone estimateUISizeByWidth:scrollView.width forData:data];
    }
    
    return CGSizeZero;
}

@end
