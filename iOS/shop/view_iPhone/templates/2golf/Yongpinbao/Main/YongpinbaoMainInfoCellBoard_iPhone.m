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
//  YongpinbaoMainInfoCellBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-5-23.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "YongpinbaoMainInfoCellBoard_iPhone.h"
#import "SearchCategoryModel.h"
#import "ServerConfig.h"

#pragma mark -

@interface YongpinbaoMainInfoCell_iPhone ()

@property (nonatomic,retain) YongpinbaoMainInfoCellBoard_iPhone* ctrl;

@end

#pragma mark -

@implementation YongpinbaoMainInfoCell_iPhone

DEF_SIGNAL( TOUCHED )

- (void)load
{
    [super load];
    
    self.tappable = YES;
	self.tapSignal = self.TOUCHED;
    
    self.ctrl = [YongpinbaoMainInfoCellBoard_iPhone boardWithNibName:@"YongpinbaoMainInfoCellBoard_iPhone"];
    self.frame = self.ctrl.view.frame;
    CGRect rect = self.frame;
    rect.size.height = 350.f;
    self.frame = rect;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.ctrl.view];
    
    self.categoryBtns = [NSMutableArray
                         arrayWithArray:@[
                                          self.ctrl.categoryBtn0,
                                          self.ctrl.categoryBtn1,
                                          self.ctrl.categoryBtn2,
                                          self.ctrl.categoryBtn3,
                                          self.ctrl.categoryBtn4,
                                          self.ctrl.categoryBtn5
                                          ]];
    
    self.brandBtns = [NSMutableArray
                      arrayWithArray:@[
                                       self.ctrl.brandBtn0,
                                       self.ctrl.brandBtn1,
                                       self.ctrl.brandBtn2,
                                       self.ctrl.brandBtn3,
                                       self.ctrl.brandBtn4,
                                       self.ctrl.brandBtn5,
                                       self.ctrl.brandBtn6,
                                       self.ctrl.brandBtn7,
                                       self.ctrl.brandBtn8,
                                       ]];
    
    self.brandImageViews = [NSMutableArray
                            arrayWithArray:@[
                                             self.ctrl.brandImageView0,
                                             self.ctrl.brandImageView1,
                                             self.ctrl.brandImageView2,
                                             self.ctrl.brandImageView3,
                                             self.ctrl.brandImageView4,
                                             self.ctrl.brandImageView5,
                                             self.ctrl.brandImageView6,
                                             self.ctrl.brandImageView7,
                                             self.ctrl.brandImageView8,
                                             ]];
    
    
    for (UIButton* btn in self.brandBtns)
    {
        //[btn setBackgroundImage:[__IMAGE(@"brandbtnborder") stretched] forState:UIControlStateNormal];
        [btn setBackgroundImage:[__IMAGE(@"brandbtnborder") stretched] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[__IMAGE(@"brandbtnborder") stretched] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(_onpressed:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(_onendpressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(_onendpressed:) forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(_onendpressed:) forControlEvents:UIControlEventTouchCancel];
        btn.alpha = 0.1;
        btn.enabled = YES;
    }
}

- (void)unload
{
    self.ctrl = nil;
    
    self.categoryBtns = nil;
    self.brandBtns = nil;
    self.brandImageViews = nil;
    
	[super unload];
}

- (void)layoutDidFinish
{
}

- (void)_onpressed:(UIButton*)btn
{
    [btn setBackgroundImage:[__IMAGE(@"brandbtnborder") stretched] forState:UIControlStateNormal];
    btn.alpha = 1.0;
}

- (void)_onendpressed:(UIButton*)btn
{
    [btn setBackgroundImage:[__IMAGE(@"brandbtnborder") stretched] forState:UIControlStateNormal];
    btn.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^(){
        btn.alpha = 0.1;
    } completion:^(BOOL finished) {
        btn.alpha = 0.1;
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }];
}

- (void)dataDidChanged
{
    if (self.data)
    {
        NSArray* arr = self.data;
        
        //目录
        for (int i = 0; i < self.categoryBtns.count; ++i)
        {
            if (i < [SearchCategoryModel sharedInstance].topCategories.count)
            {
                NSObject * obj = [SearchCategoryModel sharedInstance].topCategories[i];
                
                if ( [obj isKindOfClass:[TOP_CATEGORY class]] )
                {
                    TOP_CATEGORY * category = (TOP_CATEGORY *)obj;
                    if ( category )
                    {
                        [self.categoryBtns[i] setTitle:category.name forState:UIControlStateNormal];
                    }
                }
                else if ( [obj isKindOfClass:[CATEGORY class]] )
                {
                    CATEGORY * category = (CATEGORY *)obj;
                    if ( category )
                    {
                        [self.categoryBtns[i] setTitle:category.name forState:UIControlStateNormal];
                    }		
                }
            }
        }
        
        for (int i = 0; i < self.brandBtns.count; ++i)
        {
            if (i < arr.count)
            {
                [((BeeUIImageView*)self.brandImageViews[i]) GET:
                 [NSString stringWithFormat:@"%@%@",
                  [ServerConfig sharedInstance].baseUrl,
                  arr[i][@"photo"][@"url"]]];
            }
        }
    }
}

@end

#pragma mark -

@interface YongpinbaoMainInfoCellBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation YongpinbaoMainInfoCellBoard_iPhone

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
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}

@end
