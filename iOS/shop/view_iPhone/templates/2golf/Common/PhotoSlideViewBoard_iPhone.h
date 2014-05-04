//
//  PhotoSlideViewBoard_iPhone.h
//  2golf
//
//  Created by Lee Justin on 14-5-4.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//
#import "Bee.h"
#import "ecmobile.h"

#pragma mark -

@interface PhotoSlide_iPhone : BeeUICell
{
    BeeUIImageView *    _photo;
    BeeUIZoomView *     _zoomView;
}
@end

#pragma mark -

@interface PhotoSlideViewBoard_iPhone : BeeUIBoard
{
    BeeUIButton *       _navBackButton;
    BeeUICell *     _navBackground;
    
    //    BeeUILabel *        _hoverTitle;
    BeeUILabel *        _hoverContent;
    BeeUICell *     _hoverBackground;
    
    BeeUIScrollView *	_scroll;
    
    NSObject *          _currentSlide;
    BOOL                _isHoverHidden;
}

@property (nonatomic, retain) NSArray *				data;
@property (nonatomic, retain) NSArray *				pictures;
@property (nonatomic, assign) NSUInteger			pageIndex;
@property (nonatomic, retain) BeeUIPageControl *	pageControl;

@end
