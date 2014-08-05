//
//  PhotoSlideViewBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "CartBoard_iPhone.h"
#import "GoodsSpecifyBoard_iPhone.h"
#import "GoodsDetailBoard_iPhone.h"
#import "Placeholder.h"
#import "PhotoSlideViewBoard_iPhone.h"

#pragma mark -

@implementation PhotoSlide_iPhone

- (void)layoutDidFinish
{
    _photo.frame = self.bounds;
    _zoomView.frame = self.bounds;
    [_zoomView setContentSize:self.bounds.size];
    [_zoomView layoutContent];
}

- (void)load
{
    [super load];
    
    _photo = [[BeeUIImageView alloc] init];
    _photo.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _photo.contentMode = UIViewContentModeScaleAspectFit;
    
    _zoomView = [[BeeUIZoomView alloc] init];
    _zoomView.backgroundColor = [UIColor blackColor];
    [_zoomView setContent:_photo animated:NO];
    [self addSubview:_zoomView];
}

- (void)unload
{
	SAFE_RELEASE_SUBVIEW( _photo );
	SAFE_RELEASE_SUBVIEW( _zoomView );
	
	[super unload];
}

- (void)dataDidChanged
{
    if ( self.data )
	{
        [_photo GET:self.data[@"url"] useCache:YES placeHolder:[Placeholder image]];
	}
}

@end

@implementation PhotoSlideViewBoard_iPhone

@synthesize data = _data;
@synthesize pageIndex = _pageIndex;
@synthesize pageControl = _pageControl;

- (void)setCurrentEvent
{
    NSInteger offset = (int)_scroll.contentOffset.x;
    NSInteger index = (int)( (offset + _scroll.frame.size.width - 1) / _scroll.frame.size.width );
    NSDictionary * slide = [_data safeObjectAtIndex:index];
    
	CATransition * transition = [CATransition animation];
	[transition setDuration:0.3f];
	[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
	[transition setType:kCATransitionFade];
	[self.view.layer addAnimation:transition forKey:nil];
    
    if ( _currentSlide == slide )
    {
        if ( slide == nil ) {
            _hoverBackground.hidden = YES;
        }
        return;
    }
    else
    {
        _currentSlide = slide;
    }
}

- (void)back
{
    [self.stack popBoardAnimated:YES];
}

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self showNavigationBarAnimated:NO];
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"查看图片"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        self.view.backgroundColor = [UIColor blackColor];
        
        _scroll = [[BeeUIScrollView alloc] initWithFrame:CGRectZero];
        _scroll.horizontal = YES;
        _scroll.pagingEnabled = YES;
        _scroll.dataSource = self;
        [self.view addSubview:_scroll];
        
        self.pageControl = [[[BeeUIPageControl alloc] init] autorelease];
        self.pageControl.hidesForSinglePage = NO;
        self.pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        self.pageControl.layer.cornerRadius = 8.0f;
        [self.view addSubview:self.pageControl];
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        SAFE_RELEASE_SUBVIEW( _scroll );
        
        self.pageControl = nil;
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
        //        _tabbar.frame = CGRectMake(0, self.view.height - 44.0f, self.view.width, 44.0f);
        //        _scroll.frame = CGRectMake(0, 0, self.view.width, self.view.height - 44.0f);
        
        _scroll.frame = self.viewBound;
        
        CGRect controlFrame;
        controlFrame.size.width = 80.0f;
        if ([self.pictures count] > 0)
        {
            controlFrame.size.width = [self.pictures count] * 16;
        }
        controlFrame.size.height = 16.0f;
        controlFrame.origin.x = (self.view.width - controlFrame.size.width) / 2.0f;
        controlFrame.origin.y = self.view.height - 84.0f;
        self.pageControl.frame = controlFrame;
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
        self.data = self.pictures;
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
		[[AppBoard_iPhone sharedInstance] setTabbarHidden:YES];
		
		_scroll.pageIndex = self.pageIndex;
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
    {
        [self.stack popBoardAnimated:YES];
    }
}

ON_SIGNAL2( BeeUIZoomView, signal )
{
    if ( [signal is:BeeUIZoomView.SINGLE_TAPPED] )
    {
		CATransition * transition = [CATransition animation];
		[transition setDuration:0.3f];
		[transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
		[transition setType:kCATransitionFade];
		[self.view.layer addAnimation:transition forKey:nil];
		
        if ( _isHoverHidden )
        {
            _navBackground.hidden = YES;
            _hoverBackground.hidden = YES;
        }
        else
        {
            _navBackground.hidden = NO;
            _hoverBackground.hidden = NO;
        }
		
        _isHoverHidden = !_isHoverHidden;
    }
}

ON_SIGNAL2( BeeUIScrollView, signal )
{
	[super handleUISignal:signal];
    
    if ( [signal is:BeeUIScrollView.RELOADED] )
    {
        [self setCurrentEvent];
        
        NSInteger pageCount = _data.count;
		
		self.pageControl.currentPage = _scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
    }
    else if ( [signal is:BeeUIScrollView.DID_STOP] )
    {
        [self setCurrentEvent];
        
        NSInteger pageCount = _data.count;
		
		self.pageControl.currentPage = _scroll.pageIndex;
		self.pageControl.numberOfPages = pageCount;
    }
}

#pragma mark -

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
	return 1;
}

- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return _data.count;
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    PhotoSlide_iPhone * cell = [scrollView dequeueWithContentClass:[PhotoSlide_iPhone class]];
    cell.data = [_data safeObjectAtIndex:index];
    return cell;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    CGSize size = CGSizeMake( self.view.width, self.view.height );
    return size;
}

@end
