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
//  QiuchangOrderResultBoard_iPhone.m
//  2golf
//
//  Created by Lee Justin on 14-4-18.
//  Copyright (c) 2014年 geek-zoo studio. All rights reserved.
//

#import "QiuchangOrderResultBoard_iPhone.h"
#import "QiuchangOrderCellViewController.h"

#pragma mark -

@interface QiuchangOrderResultBoard_iPhone()
{
	QiuchangOrderCell_iPhone* _cell;
}
@end

@implementation QiuchangOrderResultBoard_iPhone

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
        [self setTitleViewWithIcon:__IMAGE(@"titleicon") andTitleString:@"预订结果"];
        [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage imageNamed:@"nav-back.png"]];
        
        _cell = [QiuchangOrderCell_iPhone cell];
        [self.view addSubview:_cell];
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
        CGRect rect = _cell.frame;
        rect.origin.y = 6;
        _cell.frame = rect;
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

- (IBAction)pressedBackToHome:(id)sender
{
    [self.stack popToRootViewControllerAnimated:YES];
}

#pragma mark -

-(void)setDataDict:(NSDictionary *)dataDict
{
    _cell.data = dataDict;
}

@end
